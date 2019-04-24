package edu.ncsu.csc.itrust.action;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

import edu.ncsu.csc.itrust.beans.ApptBean;
import edu.ncsu.csc.itrust.beans.UWApptBean;
import edu.ncsu.csc.itrust.exception.DBException;

public class StandardSuggest implements IApptScheduleResolution {
	public StandardSuggest() {}
	
	public String suggestion(AddApptRequestAction action, UWApptBean appt, long hcpid, SimpleDateFormat frmt, String apptType) throws SQLException, DBException {
		String comment = appt.getComment();
		String oldDate = frmt.format(appt.getDate());
		List<ApptBean> open = action.getNextAvailableAppts(3, appt);
		
		return PromptBuilder.BuildPrompt(comment, oldDate, open, action, apptType, frmt, hcpid);
	}
}
