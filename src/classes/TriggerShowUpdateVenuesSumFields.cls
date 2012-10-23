public class TriggerShowUpdateVenuesSumFields 
{
	

	public void execute()
	{
		Set<String>venueIdSet = collectToBeChanagedParentRecordIds();
		Map<Id, Venue__c>venueForUpdate = new Map<Id, Venue__c>();

		for(String venueId : venueIdSet)
		{
			venueForUpdate.put((Id) venueId, new Venue__c(id = venueId, Avg_Show_Cost__c = null, Total_Show_Spend__c = null));
		}

		for(AggregateResult a : [SELECT Venue__c Venue, SUM(Performer_Cost__c) Total_Spend, AVG(Performer_Cost__c) Avg_Show_Cost FROM Show__c WHERE Venue__c IN :venueIdSet GROUP BY Venue__c])
		{
			venueForUpdate.get(String.valueOf(a.get('Venue'))).Avg_Show_Cost__c = Double.valueOf(a.get('Avg_Show_Cost'));
			venueForUpdate.get(String.valueOf(a.get('Venue'))).Total_Show_Spend__c = Double.valueOf(a.get('Total_Spend'));
		}
		if(venueForUpdate.size()>0)
		{
			update venueForUpdate.values();
		}
	}
	
	private Set<String> collectToBeChanagedParentRecordIds()
	{
		Set<Object>parentIdSet = new Set<Object>();
		Map<Id, Show__c> approvedRecordsNew = getApprovedRecords(trigger.new);
		Map<Id, Show__c> approvedRecordsOld = getApprovedRecords(trigger.old);
		if(Trigger.isInsert || Trigger.isUndelete)
		{
			parentIdSet.addAll(Util.getValuesOfField(approvedRecordsNew.values(), 'Venue__c'));
		}
		else if(Trigger.isDelete)
		{
			parentIdSet.addAll(Util.getValuesOfField(approvedRecordsOld.values(), 'Venue__c'));
		}
		else if(Trigger.isUpdate)
		{
			List<sObject>changedsObjects = Util.getChangedsObjects(approvedRecordsOld, approvedRecordsNew);
			parentIdSet.addAll(Util.getValuesOfField(changedsObjects, 'Venue__c'));
		}
		
		return Util.setToString(parentIdSet);
	}

	private Map<Id, Show__c>getApprovedRecords(List<Show__c> shows)
	{

		Map<Id, Show__c> approvedRecords = new Map<Id, Show__c>();
		if(shows <> null)
		{
			for(Show__c show : shows)
			{
				if(show.Status__c == 'On Sale' || show.Status__c == 'Sold Out' || show.Status__c == 'Done')
				{
					approvedRecords.put(show.id, show);
				}
			}
		}
		return approvedRecords;
	}
}