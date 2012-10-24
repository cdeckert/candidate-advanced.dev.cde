public with sharing class PerformanceResultContainer
{
	
	public static String showId {get; set;}

	public boolean checked
	{
		get
		{
			if(checked == null)
			{
				if(performance.id <> null)
				{
					checked = true;
				}
				else
				{
					checked = false;
				}
				
			}
			return checked;
		}
		set;
	}

	public Performance__c performance
	{
		get
		{
			if(performance == null)
			{
				performance = new Performance__c(Show__c = showId, Artist__c = artist.id, Booking_Cost__c = artist.List_Cost__c);
			}
			if(performance.Booking_Cost__c == null)
			{
				performance.Booking_Cost__c = 0;
			}
			return performance;
			
		} 
		set;
	}
	public Artist__c artist {get; set;}

	public PerformanceResultContainer() {
		
	}


	public PerformanceResultContainer(Artist__c anArtist)
	{
		this();
		this.artist = anArtist;
	}
}
