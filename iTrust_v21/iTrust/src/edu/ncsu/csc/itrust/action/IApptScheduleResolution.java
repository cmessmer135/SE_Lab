package edu.ncsu.csc.itrust.action;

import java.sql.SQLException;
import java.text.SimpleDateFormat;

//import edu.ncsu.csc.itrust.beans.ApptBean;
import edu.ncsu.csc.itrust.beans.UWApptBean;
import edu.ncsu.csc.itrust.exception.DBException;

public interface IApptScheduleResolution {
	//public String suggestion(AddApptRequestAction action, ApptBean appt, long hcpid, SimpleDateFormat frmt, String apptType) throws SQLException, DBException;
	public String suggestion(AddApptRequestAction action, UWApptBean appt, long hcpid, SimpleDateFormat frmt, String apptType) throws SQLException, DBException;
}
