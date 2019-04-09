package com.tjaglcs.plugins;

public class Volume {
	private long[] articleIds;
	private Article[] articles;
	private int volumeNumber;
	private QueryString queryString; 
	
	
	public Volume(QueryString queryString) {
		this.articleIds = queryString.getArticleIds();
		setArticles(articleIds);
		this.volumeNumber = queryString.getVolumeNumber();
		this.queryString = queryString;
	}

	public Volume(long[] articleIds) {
		this.articleIds = articleIds;
		setArticles(articleIds);
	}


	public Article[] getArticles() {
		return articles;
	}


	public QueryString getQueryString() {
		return queryString;
	}

	public void setArticles(long[] articleIds) {
		
		Article[] articles = new Article[articleIds.length];
		
		for(int i = 0; i<articleIds.length; i++) {
			articles[i] = new Article(articleIds[i], this.volumeNumber);
		}
		
		this.articles = articles;
		
	}



	public int getVolumeNumber() {
		return volumeNumber;
	}



	public void setVolumeNumber(int volumeNumber) {
		this.volumeNumber = volumeNumber;
	}
	
	
	
	
	
	
}