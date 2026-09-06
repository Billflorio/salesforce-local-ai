public with sharing class GeminiContextEngine {
    @AuraEnabled
    public static String getRecordContext(Id recordId) {
        if (recordId == null) return '{}';

        Schema.SObjectType sObjType = recordId.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = sObjType.getDescribe();
        String sObjName = objDescribe.getName();

        // Dynamically discover all accessible fields from the schema
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<String> queryFields = new List<String>();
        List<String> parentFields = new List<String>();

        for (String fieldKey : fieldMap.keySet()) {
            Schema.DescribeFieldResult fd = fieldMap.get(fieldKey).getDescribe();

            // Skip fields the running user cannot see, or binary/compound types
            if (!fd.isAccessible()) continue;
            Schema.DisplayType dt = fd.getType();
            if (dt == Schema.DisplayType.BASE64 || dt == Schema.DisplayType.LOCATION) continue;

            queryFields.add(fd.getName());

            // For lookups, also grab the parent record's Name for richer context
            if (dt == Schema.DisplayType.REFERENCE && fd.getRelationshipName() != null) {
                List<Schema.SObjectType> refs = fd.getReferenceTo();
                if (!refs.isEmpty()) {
                    Map<String, Schema.SObjectField> parentFieldMap = refs[0].getDescribe().fields.getMap();
                    if (parentFieldMap.containsKey('name') && parentFieldMap.get('name').getDescribe().isAccessible()) {
                        parentFields.add(fd.getRelationshipName() + '.Name');
                    }
                }
            }
        }

        queryFields.addAll(parentFields);

        // sObjName comes from a describe call so it is safe for dynamic SOQL
        String soql = 'SELECT ' + String.join(queryFields, ', ') +
                       ' FROM ' + sObjName +
                       ' WHERE Id = :recordId LIMIT 1';

        List<SObject> records = Database.query(soql);
        if (records.isEmpty()) return '{}';

        Map<String, Object> result = new Map<String, Object>();
        result.put('objectType', sObjName);
        result.put('objectLabel', objDescribe.getLabel());
        result.put('recordId', String.valueOf(recordId));
        result.put('data', records[0]);

        return JSON.serialize(result);
    }
}
