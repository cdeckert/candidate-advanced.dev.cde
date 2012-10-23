public class PagingTable {
	
	public ApexPages.StandardSetController setCon
	{
		get; set;
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
	}
	public void next()
	{
		setCon.next();
	}

	public PagingTable() 
	{
		
	}

}