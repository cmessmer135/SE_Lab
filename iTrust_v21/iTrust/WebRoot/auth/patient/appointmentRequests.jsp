<%@page import="java.text.ParseException"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.beans.ApptBean"%>
<%@page import="edu.ncsu.csc.itrust.beans.ApptTypeBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.ApptTypeDAO"%>
<%@page import="edu.ncsu.csc.itrust.beans.HCPVisitBean"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewVisitedHCPsAction"%>
<%@page import="edu.ncsu.csc.itrust.beans.PersonnelBean"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>
<%@page import="edu.ncsu.csc.itrust.action.AddApptRequestAction"%>
<%@page import="edu.ncsu.csc.itrust.beans.ApptRequestBean"%>
<%@page import="java.util.List"%>
<%@page import="edu.ncsu.csc.itrust.action.StandardSuggest"%>
<%@page import="edu.ncsu.csc.itrust.action.CustomSuggest"%>
<%@page import="edu.ncsu.csc.itrust.action.IApptScheduleResolution"%>
<%@page import="edu.ncsu.csc.itrust.beans.UWApptBean"%>

<%@include file="/global.jsp"%>

<%
	pageTitle = "iTrust - Appointment Requests";
%>
<%@include file="/header.jsp"%>
<%
	AddApptRequestAction action = new AddApptRequestAction(prodDAO); //ViewAppt in HCP
	ViewVisitedHCPsAction hcpAction = new ViewVisitedHCPsAction(
			prodDAO, loggedInMID.longValue()); //ViewAppt in HCP

	List<HCPVisitBean> visits = hcpAction.getVisitedHCPs();

	ApptTypeDAO apptTypeDAO = prodDAO.getApptTypeDAO();
	List<ApptTypeBean> apptTypes = apptTypeDAO.getApptTypes();
	String msg = "";
	long hcpid = 0L;
	String comment = "";
	String date = "";
	String hourI = "";
	String minuteI = "";
	String tod = "";
	String apptType = "";
	String prompt = "";
	if (request.getParameter("request") != null) {
		UWApptBean appt = new UWApptBean();
		appt.setPatient(loggedInMID);
		hcpid = Long.parseLong(request.getParameter("lhcp"));
		appt.setHcp(hcpid);
		comment = request.getParameter("comment");
		appt.setComment(comment);
		SimpleDateFormat frmt = new SimpleDateFormat(
				"MM/dd/yyyy hh:mm a");
		date = request.getParameter("startDate");
		date = date.trim();
		hourI = request.getParameter("time1");
		minuteI = request.getParameter("time2");
		tod = request.getParameter("time3");
		apptType = request.getParameter("apptType");
		appt.setApptType(apptType);
		try {
			if(date.length() == 10){
				Date d = frmt.parse(date + " " + hourI + ":" + minuteI
						+ " " + tod);
				appt.setDate(new Timestamp(d.getTime()));
				ApptRequestBean req = new ApptRequestBean();
				req.setRequestedAppt(appt);
				msg = action.addApptRequest(req);
				if (msg.contains("conflicts")) {
					msg = "ERROR: " + msg;
					frmt = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
					if(request.getParameter("slots") != null) {
						String slots = request.getParameter("slots");
						appt.setnumSuggestions(Integer.parseInt(slots));
						IApptScheduleResolution customSuggestions = new CustomSuggest();
						prompt = customSuggestions.suggestion(action, appt, hcpid, frmt, apptType);
					} else {
						IApptScheduleResolution standardSuggestions = new StandardSuggest();
						prompt = standardSuggestions.suggestion(action, appt, hcpid, frmt, apptType);
					}
				} else {
					loggingAction.logEvent(
							TransactionType.APPOINTMENT_REQUEST_SUBMITTED,
							loggedInMID, hcpid, "");
				}
			}else{
				msg = "ERROR: Date must by in the format: MM/dd/yyyy";
			}
		} catch (ParseException e) {
			msg = "ERROR: Date must by in the format: MM/dd/yyyy";
		}
	}
%>
<h1>Request an Appointment</h1>
<%
	if (msg.contains("ERROR")) {
%>
<span class="iTrustError"><%=msg%></span>
<%
	} else {
%>
<span class="iTrustMessage"><%=msg%></span>
<%
	}
%>
<%=prompt%>
<form action="appointmentRequests.jsp" method="post">
	<p>HCP:</p>
	<select name="lhcp">
		<%
			for (HCPVisitBean visit : visits) {
		%><option
			<%if (visit.getHCPMID() == hcpid)
					out.println("selected");%>
			value="<%=visit.getHCPMID()%>"><%=visit.getHCPName()%></option>
		<%
			}
		%>
	</select>
	<p>Appointment Type:</p>
	<select name="apptType">
		<%
			for (ApptTypeBean appt : apptTypes) {
		%><option
			<%if (appt.getName().equals(apptType))
					out.print("selected='selected'");%>
			value="<%=appt.getName()%>"><%=appt.getName()%></option>
		<%
			}
			String startDate = "";
		%>
	</select>
	<p>Date:</p>
	<input name="startDate"
		value="<%=StringEscapeUtils.escapeHtml("" + (date))%>" size="10">
	<input type=button value="Select Date"
		onclick="displayDatePicker('startDate');">
	<p>Time:</p>
	<select name="time1">
		<%
			String hour = "";
			for (int i = 1; i <= 12; i++) {
				if (i < 10)
					hour = "0" + i;
				else
					hour = i + "";
		%>
		<option <%if (hour.equals(hourI))
					out.print("selected");%>
			value="<%=hour%>"><%=StringEscapeUtils.escapeHtml("" + (hour))%></option>
		<%
			}
		%>
	</select>:<select name="time2">
		<%
			String min = "";
			for (int i = 0; i < 60; i += 5) {
				if (i < 10)
					min = "0" + i;
				else
					min = i + "";
		%>
		<option <%if (min.equals(minuteI))
					out.print("selected");%>
			value="<%=min%>"><%=StringEscapeUtils.escapeHtml("" + (min))%></option>
		<%
			}
		%>
	</select> <select name="time3">
		<option <%if ("AM".equals(tod))
				out.print("selected");%> value="AM">AM</option>
		<option <%if ("PM".equals(tod))
				out.print("selected");%> value="PM">PM</option>
	</select>
	<p>Comment:</p>
	<textarea name="comment" cols="100" rows="10"><%=StringEscapeUtils.escapeHtml("" + (comment))%></textarea>
	<br /> <br /> <input type="submit" name="request" value="Request" />
</form>
<%
	
%>

<%@include file="/footer.jsp"%>
