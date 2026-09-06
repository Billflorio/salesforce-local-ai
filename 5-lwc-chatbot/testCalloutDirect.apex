Map<String, Object> payload = new Map<String, Object>();
List<Map<String, Object>> contents = new List<Map<String, Object>>();
contents.add(new Map<String, Object>{'role' => 'user', 'parts' => new List<Object>{new Map<String, Object>{'text' => 'Who won the super bowl in 2024?'}}});
payload.put('contents', contents);

List<Object> tools = new List<Object>();
tools.add(new Map<String, Object>{'googleSearch' => new Map<String, Object>()});
tools.add(new Map<String, Object>{'functionDeclarations' => new List<Object>{
    new Map<String, Object>{'name' => 'dummy', 'description' => 'dummy'}
}});
payload.put('tools', tools);

// Add the config the error asked for
payload.put('toolConfig', new Map<String, Object>{
    'includeServerSideToolInvocations' => true
});

HttpRequest req = new HttpRequest();
req.setEndpoint('callout:Gemini_API/v1beta/models/gemini-flash-latest:generateContent');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json');
req.setBody(JSON.serialize(payload));

Http http = new Http();
HttpResponse res = http.send(req);
System.debug('HTTP_STATUS: ' + res.getStatusCode());
System.debug('HTTP_BODY: ' + res.getBody());
