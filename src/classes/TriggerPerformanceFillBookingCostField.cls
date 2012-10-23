public with sharing class TriggerPerformanceFillBookingCostField {
	public void execute()
	{
		for(sObject s : Trigger.new)
		{
			if(s.get('Booking_Cost__c') == null)
			{
				s.put('Booking_Cost__c', s.get('Artist_List_Cost__c'));
			}
		}
	}
}