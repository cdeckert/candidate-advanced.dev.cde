public with sharing class ShowEditController {
	
	public Show__c currentRecord {get; set;}
	public List<PerformanceContainer>result
	{
		get
		{
			result = new List<PerformanceContainer>();
			List<Artist__c> aritsts = (List<Artist__c>)setCon.getRecords();
			Map<Id, Performance__c>performancesFromDb = getPerformancesFromDB(aritsts);

			for(Artist__c a : aritsts)
			{
				result.add(new PerformanceContainer(a, currentRecord.id,performancesFromDb));
			}
			return result;
		}		
		set;
	}
	public String filterType {get; set;}

	public List<SelectOption> filterSelectOptions
	{
		get
		{
			if(filterSelectOptions == null)
			{
				filterSelectOptions = new List<SelectOption>();
				filterSelectOptions.add(new SelectOption('', '—Select One—'));
				filterSelectOptions.addAll(Util.getSelectOptionsFromSObjectField(new Artist__c(), 'Type__c'));
			}
			return filterSelectOptions;
		}
		set;
	}

	public ApexPages.StandardSetController setCon
	{
		get
		{
			if(setCon == null)
			{
				String queryString = 'SELECT ID, Type__c, Expected_Draw__c, List_Cost__c FROM Artist__c';
				if(filterType <> null)
				{
					queryString += ' WHERE Type__c = \''+filterType+'\'';
				}
				queryString += ' order by Name';
				setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
				setCon.setPageSize(5);
				setCon.setPageNumber(1);
			}
			return setCon;
		}
		set;
	}



	public boolean hasNext
	{
		get
		{
			return setCon.getHasNext();
		}
		set;
	}
	public boolean hasPrev
	{
		get
		{
			return setCon.getHasPrevious();
		}
		set;
	}

	public void prev()
	{
		setCon.previous();
	}
	public void next()
	{
		setCon.next();
	}

    public ShowEditController(ApexPages.StandardController controller)
    {
    	currentRecord = (Show__c)controller.getRecord();
    }

    public void filter()
    {
    	setCon = null;
    }

    public void clearFilter()
    {
    	filterType = null;
    	filter();
    }


 
    private Map<Id, Performance__c>getPerformancesFromDB(List<Artist__c>artists)
    {
    	Map<Id, Performance__c> performancesFromDB = new Map<Id, Performance__c>();
    	for(Performance__c p : [SELECT ID, Artist__c, Booking_Cost__c FROM Performance__c WHERE Artist__c IN :artists AND Show__c = :currentRecord.id])
    	{
    		performancesFromDB.put(p.Artist__c, p);
    	}
    	return performancesFromDB;
    }

    public class PerformanceContainer
    {
    	public boolean checked {get; set;}
    	public Performance__c record {get; set;}
    	private String showId;
    	public PerformanceContainer(){}
    	

    	public PerformanceContainer(Artist__c anArtist, ID showId, Map<Id, Performance__c> existingPerformances)
    	{
    		
    		if(existingPerformances.containsKey(anArtist.id))
    		{
    			Performance__c existingPerformance = existingPerformances.get(anArtist.id);
    			record = new Performance__c(id = existingPerformance.id, Artist__c = anArtist.id, Booking_Cost__c = existingPerformance.Booking_Cost__c);
    		}
    		else
    		{
    			record = new Performance__c(Artist__c = anArtist.id);
    		}
    		record.Artist__r = anArtist;
    		this.showId = showId;
    		
    	}
    }
}