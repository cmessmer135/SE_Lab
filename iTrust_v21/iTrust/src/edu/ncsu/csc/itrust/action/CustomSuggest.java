package edu.ncsu.csc.itrust.action;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

import edu.ncsu.csc.itrust.beans.ApptBean;
import edu.ncsu.csc.itrust.beans.UWApptBean;
import edu.ncsu.csc.itrust.exception.DBException;

public class CustomSuggest implements IApptScheduleResolution {
	public CustomSuggest(){}
	
	public String suggestion(AddApptRequestAction action, UWApptBean appt, long hcpid, SimpleDateFormat frmt, String apptType) throws SQLException, DBException {
		String prompt = "";
		String comment = appt.getComment();
		String oldDate = frmt.format(appt.getDate());

		List<ApptBean> open = action.getNextAvailableAppts(appt.getnumSuggestions(), appt);
		prompt="<br/>The following nearby time slots are available:<br/>";
		int index = 0;
		for(ApptBean possible : open) {
			index++;
			String newDate = frmt.format(possible.getDate());
			prompt +="<div style='padding:5px;margin:5px;float:left;border:1px solid black;'><b>Option " + index+ "</b><br/>"+ frmt.format(possible.getDate()); 
			prompt +="<form action='appointmentRequests.jsp' method='post'>"
					+"<input type='hidden' name='lhcp' value='"+hcpid+"'/>"
					+"<input type='hidden' name='apptType' value='"+apptType+"'/>	"
					+"<input type='hidden' name='startDate' value='"+newDate.substring(0,10)+"'/>"
					+"<input type='hidden' name='time1' value='"+newDate.substring(11,13)+"'/>"
					+"<input type='hidden' name='time2' value='"+newDate.substring(14,16)+"'/>"
					+"<input type='hidden' name='time3' value='"+newDate.substring(17)+"'/>"
					+"<input type='hidden' name='comment' value='"+comment+"'/>"
					+"<input type='submit' name='request' value='Select this time'/>"
					+"</form></div>";
		}
		

		prompt +="<form action='appointmentRequests.jsp' method='post'>"
				+"<input type='hidden' name='lhcp' value='"+hcpid+"'/>"
				+"<input type='hidden' name='apptType' value='"+apptType+"'/>	"
				+"<input type='hidden' name='startDate' value='"+oldDate.substring(0,10)+"'/>"
				+"<input type='hidden' name='time1' value='"+oldDate.substring(11,13)+"'/>"
				+"<input type='hidden' name='time2' value='"+oldDate.substring(14,16)+"'/>"
				+"<input type='hidden' name='time3' value='"+oldDate.substring(17)+"'/>"
				+"<input type='hidden' name='comment' value='"+comment+"'/>"
				+"<div style='clear:both;'><br/></div>";
		
		prompt +="<div>Want more options?"
				+"<br>Enter how many: <input type='number' name='slots' min='1' max='100' style='width: 60px'>"
				+"<br><input type='submit' name='request' value='Submit' />"
				+"</div><br>";
		
		return prompt;
	}
	
	//public String suggestion(AddApptRequestAction action, ApptBean appt, long hcpid, SimpleDateFormat frmt, String apptType) {
	//	return "";
	//}
}
