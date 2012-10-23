@isTest
private class Test_TestInit
{
	// Test vanues
	private static testMethod void test_Insert_Venues()
	{
		System.assert(TestInit.venues.size() == [SELECT ID FROM Venue__c].size(), 'Not all venues were inserted');
	}

	// Test artists
	private static testMethod void test_Insert_Artists()
	{
		System.assert(TestInit.artists.size() == [SELECT ID FROM Artist__c].size(), 'Not all artists were inserted');
	}
	// Test performances
	private static testMethod void test_Insert_Performances()
	{
		List<Performance__c> performances = TestInit.performances;
		System.assert(TestInit.venues.size()*TestInit.artists.size()*5 == [SELECT ID FROM Performance__c].size());
	}
}