public class Util
{
	public static Set<Object>getValuesOfField(List<sObject> aSObject, String field)
	{
		Set<Object>values = new Set<Object>();
		for(sObject o : aSObject)
		{
			values.add(o.get(field));
		}
		return values;
	}
	
	public static List<sObject>getChangedsObjects(Map<id, sObject>oldRecords, Map<id, sObject>newRecords)
	{
		List<sObject>changedObjects = new List<sObject>();
		for(sObject newRecord : newRecords.values())
		{
			if(!fieldValueEquals(oldRecords.get((id)newRecord.get('id')), newRecord))
			{
				changedObjects.add(newRecord);
			}
		}
		return changedObjects;
	}
	
	public static boolean fieldValueEquals(sObject oldRecord, sObject newRecord)
	{
		// check if record is not null
		if(oldRecord == null || newRecord == null)
		{
			return false;
		}
		
		// compair type
		if(oldRecord.getsObjectType() <> newRecord.getsObjectType())
		{
			return false;
		}
		else
		{
			
			for(Schema.SObjectField field : getFieldMap(newRecord).values())
			{
				Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
				if(oldRecord.get(fieldDescribe.getName())<> newRecord.get(fieldDescribe.getName()))
				{
					return false;
				}
			}
		}
		
		return true;
	}
	
	public static Map<String, Schema.SObjectField> getFieldMap(sObject aSObject)
	{
		return aSObject.getsObjectType().getDescribe().fields.getMap();
	}

	public static Set<String>setToString(Set<Object> inputSet)
	{
		Set<String>stringSet = new Set<String>();
		for(Object input : inputSet)
		{
			stringSet.add(String.valueOf(input));
		}
		return stringSet;
	}
}