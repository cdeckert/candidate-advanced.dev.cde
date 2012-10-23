public class TestInit {
	// list of test artists
	public static List<Artist__c>artists
	{
		get
		{
			if(artists == null)
			{
				artists = new List<Artist__c>();
				artists.add(new Artist__c(name = 'Psy', Expected_Draw__c = '45654', List_Cost__c = 13548, Type__c = 'Pop'));
				artists.add(new Artist__c(name = 'Rihanna', Expected_Draw__c = '1371', List_Cost__c = 4574, Type__c = 'Pop'));
				artists.add(new Artist__c(name = 'Ke$ha', Expected_Draw__c = '4874', List_Cost__c = 45641, Type__c = 'Pop'));
				
				artists.add(new Artist__c(name = 'Linkin Park', Expected_Draw__c = '654312', List_Cost__c = 86741, Type__c = 'Rock'));
				artists.add(new Artist__c(name = 'Green Day', Expected_Draw__c = '65641', List_Cost__c = 85641, Type__c = 'Rock; Alternative'));
				artists.add(new Artist__c(name = 'The Killers', Expected_Draw__c = '45341', List_Cost__c = 65413, Type__c = 'Rock; Alternative'));
				
				artists.add(new Artist__c(name = 'Taylor Swift', Expected_Draw__c = '452324', List_Cost__c = 108023, Type__c = 'Country'));
				artists.add(new Artist__c(name = 'Jason Aldean', Expected_Draw__c = '7987', List_Cost__c = 72012, Type__c = 'Country'));
				artists.add(new Artist__c(name = 'Alan Jackson', Expected_Draw__c = '45667', List_Cost__c = 556874, Type__c = 'Country'));
				
				insert artists;
			}
			return artists;
		}
		set;
	}

	public static List<Show__c> shows
	{
		get
		{
			if(shows == null)
			{
				shows = new List<Show__c>();
				for(Venue__c v : venues)
				{
					shows.add(new Show__c(venue__c = v.id, Status__c = 'Proposed'));
					shows.add(new Show__c(venue__c = v.id, Status__c = 'On Sale'));
					shows.add(new Show__c(venue__c = v.id, Status__c = 'Sold out'));
					shows.add(new Show__c(venue__c = v.id, Status__c = 'Cancelled'));
					shows.add(new Show__c(venue__c = v.id, Status__c = 'Done'));
				}
				insert shows;
			}
			return shows;
		}
		set;
	}

	public static List<Performance__c> performances
	{
		get
		{
			if(performances == null)
			{
				performances = new List<Performance__c>();
				for(Show__c s : shows)
				{
					for(Artist__c a : artists)
					{
						performances.add(new Performance__c(Show__c = s.id, Artist__c = a.id));
					}
				}
				insert performances;
			}
			return performances;
		}
		set;
	}
	
	public static List<Consumer__c> customers
	{
		get
		{
			if(customers == null)
			{
				customers = new List<Consumer__c>();
				customers.add(new Consumer__c(First_Name__c = 'Arthur', Last_Name__c = 'Dent'));
				customers.add(new Consumer__c(First_Name__c = 'Ford', Last_Name__c = 'Prefect'));
				customers.add(new Consumer__c(First_Name__c = 'Zaphod', Last_Name__c = 'Beeblebrox'));
				insert customers;
			}
			return customers;
		}
		set;
	}
	
	public static List<Venue__c> venues
	{
		get
		{
			if(venues == null)
			{
				venues = new List<Venue__c>();
				venues.add(new Venue__c(Name = 'Bar Comida'));
				venues.add(new Venue__c(Name = 'Elbow Room'));
				venues.add(new Venue__c(Name = 'Pats Garage'));
				insert venues;
			}
			return venues;
		}
		set;
	}
}