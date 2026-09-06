public with sharing class GeminiCalloutService {

    @AuraEnabled
    public static String generateResponse(String prompt, String recordContext, String chatHistory) {
        Map<String, Object> payload = new Map<String, Object>();

        // ── 1. System Instruction ──────────────────────────────────────────
        String systemPrompt =
            'You are a highly capable Salesforce AI assistant embedded in the Utility Bar. ' +
            'Your goal is to help the user analyze and take action on CRM data.\n\n' +
            'RULES:\n' +
            '1. When the user asks to update a record, always confirm the exact field and new value with the user BEFORE calling the updateSalesforceRecord function.\n' +
            '2. Never fabricate data. If you do not know something, say so honestly.\n' +
            '3. Format your responses with markdown (bold, bullets, headers) for readability.\n\n' +
            'Here is the JSON data of the record the user is currently viewing:\n' + recordContext;

        Map<String, Object> sysInst = new Map<String, Object>();
        sysInst.put('parts', new List<Map<String, Object>>{
            new Map<String, Object>{'text' => systemPrompt}
        });
        payload.put('system_instruction', sysInst);

        // ── 2. Chat History ────────────────────────────────────────────────
        List<Map<String, Object>> contents = new List<Map<String, Object>>();
        if (String.isNotBlank(chatHistory)) {
            List<Object> historyList = (List<Object>)JSON.deserializeUntyped(chatHistory);
            for (Object obj : historyList) {
                Map<String, Object> histMsg = (Map<String, Object>)obj;
                String role = (String)histMsg.get('role');
                if (role != 'user' && role != 'model') continue;
                Map<String, Object> contentMap = new Map<String, Object>();
                contentMap.put('role', role);
                contentMap.put('parts', new List<Map<String, Object>>{
                    new Map<String, Object>{'text' => (String)histMsg.get('text')}
                });
                contents.add(contentMap);
            }
        }

        // ── 3. Current User Prompt ─────────────────────────────────────────
        Map<String, Object> newMsg = new Map<String, Object>();
        newMsg.put('role', 'user');
        newMsg.put('parts', new List<Map<String, Object>>{
            new Map<String, Object>{'text' => prompt}
        });
        contents.add(newMsg);
        payload.put('contents', contents);

        // ── 4. Tools ───────────────────────────────────────────────────────
        List<Object> tools = new List<Object>();

        // Google Search (server-side / built-in)
        tools.add(new Map<String, Object>{'googleSearch' => new Map<String, Object>()});

        // Custom function: updateSalesforceRecord
        Map<String, Object> updateFn = new Map<String, Object>{
            'name' => 'updateSalesforceRecord',
            'description' => 'Updates a single field on a Salesforce record. Use this ONLY after the user has explicitly confirmed the change.',
            'parameters' => new Map<String, Object>{
                'type' => 'OBJECT',
                'properties' => new Map<String, Object>{
                    'recordId'  => new Map<String, Object>{'type' => 'STRING', 'description' => 'The 18-character Salesforce record ID'},
                    'fieldName' => new Map<String, Object>{'type' => 'STRING', 'description' => 'The exact API name of the field to update (e.g. FirstName, LastName, Title, Email, MiddleName)'},
                    'newValue'  => new Map<String, Object>{'type' => 'STRING', 'description' => 'The new value to set on the field'}
                },
                'required' => new List<String>{'recordId', 'fieldName', 'newValue'}
            }
        };
        tools.add(new Map<String, Object>{'functionDeclarations' => new List<Object>{updateFn}});

        payload.put('tools', tools);
        payload.put('toolConfig', new Map<String, Object>{'includeServerSideToolInvocations' => true});

        // ── 5. Send Request ────────────────────────────────────────────────
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Gemini_API/v1beta/models/gemini-flash-latest:generateContent');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(120000);
        req.setBody(JSON.serialize(payload));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('Error from Gemini: ' + res.getStatusCode() + ' - ' + res.getBody());
        }

        // ── 6. Intercept Function Calls ────────────────────────────────────
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        List<Object> candidates = (List<Object>)responseMap.get('candidates');

        if (candidates != null && !candidates.isEmpty()) {
            Map<String, Object> candidate = (Map<String, Object>)candidates[0];
            Map<String, Object> content = (Map<String, Object>)candidate.get('content');

            if (content != null && content.get('parts') != null) {
                List<Object> parts = (List<Object>)content.get('parts');

                // Loop through ALL parts (functionCall may not be the first one)
                for (Object partObj : parts) {
                    Map<String, Object> part = (Map<String, Object>)partObj;
                    if (!part.containsKey('functionCall')) continue;

                    Map<String, Object> functionCall = (Map<String, Object>)part.get('functionCall');
                    if ((String)functionCall.get('name') == 'updateSalesforceRecord') {
                        return handleRecordUpdate(functionCall);
                    }
                }
            }
        }

        return res.getBody();
    }

    // ── Helper: Execute a Salesforce DML update ────────────────────────────
    private static String handleRecordUpdate(Map<String, Object> functionCall) {
        Map<String, Object> args = (Map<String, Object>)functionCall.get('args');
        String recId = (String)args.get('recordId');
        String field = (String)args.get('fieldName');
        String val   = (String)args.get('newValue');

        try {
            Id rId = (Id)recId;
            Schema.DescribeSObjectResult objDesc = rId.getSObjectType().getDescribe();

            // FLS check: verify the field exists and is updateable
            Map<String, Schema.SObjectField> fieldMap = objDesc.fields.getMap();
            Schema.SObjectField sField = fieldMap.get(field.toLowerCase());

            if (sField == null) {
                return buildTextResponse('\u274c **Field not found:** The field `' + String.escapeSingleQuotes(field) + '` does not exist on ' + objDesc.getLabel() + '.');
            }
            if (!sField.getDescribe().isUpdateable()) {
                return buildTextResponse('\u274c **Permission denied:** You do not have permission to update the `' + sField.getDescribe().getLabel() + '` field.');
            }

            SObject sObj = rId.getSObjectType().newSObject(rId);
            sObj.put(sField.getDescribe().getName(), val);
            update sObj;

            return buildTextResponse('\u2705 **Action Complete:** I successfully updated **' + sField.getDescribe().getLabel() + '** to "' + val + '" in Salesforce. Please refresh your page to see the changes.');
        } catch (Exception e) {
            return buildTextResponse('\u274c **Failed to update record:** ' + e.getMessage());
        }
    }

    // ── Helper: Build a safe JSON response (prevents injection) ────────────
    private static String buildTextResponse(String text) {
        Map<String, Object> response = new Map<String, Object>();
        Map<String, Object> content = new Map<String, Object>();
        content.put('parts', new List<Object>{
            new Map<String, Object>{'text' => text}
        });
        response.put('candidates', new List<Object>{
            new Map<String, Object>{'content' => content}
        });
        return JSON.serialize(response);
    }
}
