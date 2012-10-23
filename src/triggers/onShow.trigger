trigger onShow on Show__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	if(Trigger.isAfter)
	{
		new TriggerShowUpdateVenuesSumFields().execute();
	}
}