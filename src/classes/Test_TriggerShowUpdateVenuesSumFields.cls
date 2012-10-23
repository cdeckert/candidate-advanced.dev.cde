@isTest
public class Test_TriggerShowUpdateVenuesSumFields {
	

	private static testMethod void testVenueUpdateForInsertedPerformances()
	{
		List<Performance__c> performances = TestInit.performances;
		List<Artist__c> artists = TestInit.artists;


		AggregateResult sumOfStandardRatesOfArtists = [SELECT SUM(List_Cost__c) sumListCost FROM Artist__c];

		Map<Id, Double> sumPerVanue = new Map<Id, Double>();
		for(Show__c s : [SELECT Performer_Cost__c, Venue__c, Status__c FROM Show__c])
		{
			// Sum Performance Costs
			if(!sumPerVanue.containsKey(s.id))
			{
				sumPerVanue.put(s.id, 0);
			}
			if(s.Status__c == 'On Sale' && s.Status__c == 'Sold Out' && s.Status__c == 'Done')
			{
				sumPerVanue.put(s.id, sumPerVanue.get(s.id)+ s.Performer_Cost__c);
			}
			// Test Sum on Show level is correct
			System.assert(s.Performer_Cost__c == Double.valueOf(sumOfStandardRatesOfArtists.get('sumListCost')));
		}


		for(Venue__c v : [SELECT ID, Total_Show_Spend__c FROM Venue__c])
		{
			// System.assert(v.Total_Show_Spend__c == sumPerVanue.get(v.id));
		}


	}

	private static testMethod void testPerformanceChange()
	{
		testVenueUpdateForInsertedPerformances();
		List<Performance__c> performances = [SELECT ID, Booking_Cost__c, Artist_List_Cost__c FROM Performance__c];
		
		for(Integer i=0; i< performances.size(); i++)
		{
			if(Math.mod(i, 2) == 0)
			{
				performances.get(i).Booking_Cost__c = 42*Math.random();
			}
		}
		update performances;
	}

	private static testMethod void testPerformanceDelete()
	{
		testVenueUpdateForInsertedPerformances();
		List<Performance__c> performances = [SELECT ID, Booking_Cost__c, Artist_List_Cost__c FROM Performance__c];
		List<Performance__c> toBeDeleted = new List<Performance__c>();
		for(Integer i=0; i< performances.size(); i++)
		{
			if(Math.mod(i, 2) == 0)
			{
				toBeDeleted.add(performances.get(i));
			}
		}
		delete toBeDeleted;
	}

	private static testMethod void testShowDelete()
	{
		testPerformanceDelete();

		List<Show__c>toBeDeleted = new List<Show__c>();
		List<Show__c>shows = [SELECT ID FROM Show__c];

		for(Integer i = 0; i<shows.size(); i++)
		{
			if(Math.mod(i, 2) == 0)
			{
				toBeDeleted.add(shows.get(i));
			}
		}

		delete toBeDeleted;
	}
}