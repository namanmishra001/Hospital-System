<%@page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Query"%>
<%@page import="java.util.*"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="info.inetsolv.tools.DateUtil"%>
<%@page import="java.util.Calendar"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
  Session hsession = null;
  try{
    String id = request.getParameter("id");
    String msg = request.getParameter("msg");
    if((null!=id)&&(!"".equals(id))){
     hsession = BeanFactory.getSession();	  
     LabTestReport report = (LabTestReport)hsession.get(LabTestReport.class, Long.parseLong(id));
     if(null!=report){
	Set<LabTestReportDetail> details = report.getLabTestReportDetails();
	if(details.size()!=0){
	 PatientInfo patient = report.getPatientInfo();
 	 %>
     <head>
       <base href="<%=session.getAttribute("basePath")%>"/>
       <meta http-equiv="pragma" content="no-cache" />
       <meta http-equiv="cache-control" content="no-cache" />
       <meta http-equiv="expires" content="0" />    
       <link type="text/css" href="CSS/styles.css" rel="stylesheet" media="screen" />
       <link type="text/css" href="CSS/menu.css" rel="stylesheet"  media="screen" />
       <style type="text/css" media="print">
        .print_hide{
            display: none;
         }
       </style>
       <style type="text/css" media="screen">
        .screen_hide{
            display: none;
            text-align: left;
        }
       </style>
     </head>
     <body class="hd" onload="settime()">
      <div class="print_hide">
	  <div class="main">
	   <jsp:include page="Head.jsp" />
	  </div>
	  <jsp:include page="Menu.jsp" />
	  </div>
      <div class="main" style="min-height: 550px;">
  	  <div align="center" class="header">Lab Report</div>
        <table align="center" class="inputForm" width="800px;">
         <tr>
          <td colspan="4">
           <%
            if(null != msg){
    	 	  out.println("<span class='msg'>" + msg + "</span>");
  	        }
           %>
          </td>
         </tr>
         <tr><td colspan="4" height="40px;"></td></tr>
	     <tr>
	      <td align="right">Patient Name: </td>
	      <td align="left"><%=ObjectUtil.formatValue(report.getPatientInfo().getName())%></td>
	      <td align="right">Age : <%=ObjectUtil.formatValue(patient.getAge())%> </td>
	      <td align="left">Gender : <%=ObjectUtil.formatValue(patient.getGender())%></td>
  	     </tr>
	     <tr>
	      <td align="right">
	      <%
    	   if(null != patient.getRelationType()){
    		if("Parent".equals(patient.getRelationType()))
    		  out.println(("Male".equals(patient.getGender()))?"S/O.":"D/O.");
    		else
    		if("Spouse".equals(patient.getRelationType()))	
   			  out.println(("Male".equals(patient.getGender()))?"H/O.":"W/O.");
    		else
    		if("Other".equals(patient.getRelationType()))
    		  out.println("C/O.");		
    	   }%>
	      </td>
	      <td align="left"><%=ObjectUtil.formatValue(patient.getRelativeName())%></td>
	      <td align="right">Consultant Name : </td>
	      <td align="left"><%=ObjectUtil.formatValue(report.getConsultant().getName())%></td>
  	     </tr>
  	     <tr><td colspan="4" height="40px;"></td></tr>
  	     <tr>
  	      <td colspan="4">
		   <table align="center" width="750Px;">
		    <tr class="screen_hide"><td colspan="5"><hr /></td></tr>				
		    <tr class="tr_header">
			 <td>S.No.</td>
			 <td>Test Name</td>
			 <td width="150px;">Normal</td>
			 <td width="150px;">Result</td>
			 <td width="150px;">Remarks</td>
		    </tr>
		    <tr class="screen_hide"><td colspan="5"><hr /></td></tr>
		    <%
			 Iterator<LabTestReportDetail> it = details.iterator();
		     int count = 0;
			 while(it.hasNext()){
			  LabTestReportDetail detail = it.next();
			  LabTest test = detail.getLabTest();
			 %>		
			 <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>">
				<td>
				 <%=++count%>
				</td>
				<td><%=test.getName()%></td>
				<td>
				 <%
				  if(test.getRange()){
					out.println(ObjectUtil.formatValue(detail.getLabTest().getMinValue())+"-"+ObjectUtil.formatValue(test.getMaxValue()));  
				  }else{
					out.println(ObjectUtil.formatValue((test.getNormalValue())?"POSITIVE":"NEGATIVE"));  
				  }
				 %>
				</td>
				<td>
				 <%
				 String result = null;
				 if(null!=detail.getResult()){
				   if(detail.getResult().longValue()==1l)
					   result = "Postive";
				   else
					if(detail.getResult().longValue()==0l)
						result = "Negative";
					else
						result = detail.getResult().toString();
				 }
				 %>
				 <%=ObjectUtil.formatValue(result)%>
				</td>
				<td><%=detail.getRemarks()%></td>
			 </tr>
			 <%}%>
		   </table>
  	      </td>
  	     </tr>
  	     <tr><td colspan="4"></td></tr>
  	     <tr align="center" class="print_hide">
	      <td colspan="2">
	       <input type="button" name="ok" id="ok" value="  Print  " onclick="javascript: window.print();" />
	      </td>
	      <td colspan="2">
	      </td>
	     </tr>
	     <tr>
	      <td colspan="3"></td>
  	      <td align="center" colspan="3" style="padding-top:120px;vertical-align: bottom;" class="tr_opBill_dis">Signature</td>
  	     </tr>
        </table>
      </div>
      <div id="div4" style="padding-top: 20px">
      <table width="100%">
       <tr align="left">
    	<td>
    	 <table class="screen_hide">
    	   <tr class="tr_opBill_extra"><td>Print User :</td><td align="left"><%=((User)session.getAttribute("user")).getName()%></td><td><%=DateUtil.formatDate("dd-MM-yyyy HH:mm:ss",Calendar.getInstance().getTimeInMillis())%></td></tr>
    	 </table>
        </td>
       </tr>
      </table>
      </div> 
     </body>
   <%}else{
	   response.sendRedirect("addReport&id="+report.getId()+"&msg=no report is available");
   }}else{
	   response.sendRedirect("investigationSearchPatient");
   }}else{
	   response.sendRedirect("investigationSearchPatient");
   }}catch(Exception e){}
   finally{if(null!=hsession)hsession.clear();hsession.close();}}else{
	 response.sendRedirect("validate");
  }%>
</html>
