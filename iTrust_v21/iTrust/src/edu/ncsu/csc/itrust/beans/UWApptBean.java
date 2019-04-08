package edu.ncsu.csc.itrust.beans;
import edu.ncsu.csc.itrust.beans.ApptBean;

public class UWApptBean extends ApptBean {

	private static final long serialVersionUID = -3103619434528745590L;
	private int numSuggestions;
	
	public void setnumSuggestions(int num)
	{
		numSuggestions = num;
	}
	
	public int getnumSuggestions()
	{
		return numSuggestions;
	}
}
