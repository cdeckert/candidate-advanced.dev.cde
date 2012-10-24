public class PagingTable {

	private static final Integer STANDARD_PAGE_SIZE = 5;
	
	public List<Observer>pageFlipObservers
	{
		get
		{
			if(pageFlipObservers == null)
			{
				pageFlipObservers = new List<Observer>();
			}
			return pageFlipObservers;
		}	
		set;
	}

	public ApexPages.StandardSetController setCon
	{
		get;
		set
		{
			setCon = value;
			setCon.setPageSize(STANDARD_PAGE_SIZE);
			setCon.setPageNumber(1);
		}
	}
	public Integer pageSize
	{
		get
		{
			if(pageSize == null)
			{
				pageSize = 5;
			}
			return pageSize;
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
		notify(pageFlipObservers);
	}
	public void next()
	{
		setCon.next();
		notify(pageFlipObservers);
	}

	private void notify(List<Observer> observers)
	{
		for(Observer o : observers)
		{
			o.notify();
		}
	}

	public PagingTable() 
	{
		
	}

	public PagingTable(ApexPages.StandardSetController setCon)
	{
		this();
		this.setCon = setCon;
	}

	public List<sObject> getRecords()
	{
		return this.setCon.getRecords();
	}
}