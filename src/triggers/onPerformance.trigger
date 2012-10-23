trigger onPerformance on Performance__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update)
{
	if(Trigger.isBefore && Trigger.isInsert)
	{
		new TriggerPerformanceFillBookingCostField().execute();
	}else if(Trigger.isBefore && Trigger.isUpdate)
	{
		new TriggerPerformanceFillBookingCostField().execute();
	}
}