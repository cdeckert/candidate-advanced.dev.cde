/**
* @author Christian Deckert
* @date 24/12/2012
* @description Class controls visualforce page. Takes care of fiters and uses pagingTable to generate a result table. 
*/
public with sharing class ShowEditController implements Observer{
	
	
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

	public PagingTable table
	{
		get
		{
			if(table == null)
			{
				table = new PagingTable();
			}
			
			return table;
		} 
		set;
	}

	public List<PerformanceResultContainer>resultContainer
	{
		get
		{
			PerformanceResultContainer.showId = stdcontroller.getRecord().id;
			return resultContainer;
		}
	 	set;
	 }




	private String getQueryStringForTable()
	{
		String queryString = 'SELECT ID, Type__c, Expected_Draw__c, List_Cost__c FROM Artist__c';
		if(filterType <> null)
		{
			queryString += ' WHERE Type__c includes (\''+filterType+'\')';
			//System.assert(false, queryString);
		}
		queryString += ' order by Name';
		return queryString;
	}

	

	private ApexPages.StandardController stdcontroller;
    public ShowEditController(ApexPages.StandardController stdcontroller)
    {
    	this.stdcontroller = stdcontroller;
    	this.filter();
    	this.table.pageFlipObservers.add(this);

    }

    public void filter()
    {
    	this.table.setCon = new ApexPages.StandardSetController(Database.getQueryLocator(getQueryStringForTable()));
    	this.buildResultContainer();
     }

    private void buildResultContainer()
    {
    	resultContainer = new List<PerformanceResultContainer>();
    	Map<Id, PerformanceResultContainer> resultContainerMap = new Map<Id, PerformanceResultContainer>();
    	for(Artist__c a : (List<Artist__c>) this.table.getRecords())
    	{
    		resultContainerMap.put(a.id, new PerformanceResultContainer(a));
    		resultContainer.add(resultContainerMap.get(a.id));
    	}
    	if(!resultContainerMap.isEmpty())
    	{
    		for(Performance__c p : [SELECT ID, Show__c, Artist__c, Booking_Cost__c FROM Performance__c WHERE Artist__c IN :resultContainerMap.keySet() AND Show__c = :stdcontroller.getRecord().id])
    		{
    			resultContainerMap.get(p.Artist__c).performance = p;
    		}
    	}
    }

    public void clearFilter()
    {
    	this.filterType = null;
    	this.filter();
    }

    public PageReference save()
    {

    	quickSave();
    	return stdcontroller.view();
    }

    public void quickSave()
    {
    	stdcontroller.save();
    	List<Performance__c>upsertPerformance = new List<Performance__c>();
    	List<Performance__c>deletePerformance = new List<Performance__c>();
    	for(PerformanceResultContainer r : resultContainer)
    	{
    		if(r.checked)
    		{
    			upsertPerformance.add(r.performance);
    		}
    		else if(r.performance.id <> null)
    		{
    			deletePerformance.add(r.performance);
    		}
    	}

    	if(!upsertPerformance.isEmpty())
    	{
    		upsert upsertPerformance;
    	}

    	if(!deletePerformance.isEmpty())
    	{
    		delete deletePerformance;
    	}
    	buildResultContainer();
    	stdcontroller.reset();
    }


    public void notify()
    {
    	buildResultContainer();
    }

    /*
 
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
    }*/
}