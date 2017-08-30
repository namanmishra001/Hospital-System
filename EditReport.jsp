<%@page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Query"%>
<%@page import="java.util.*"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.Criteria"%>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
  String id = request.getParameter("id");
  String msg = request.getParameter("msg");
  if((null!=id)&&(!"".equals(id))){
   Session hsession = BeanFactory.getSession();	  
   LabTestReport report = (LabTestReport)hsession.get(LabTestReport.class, Long.parseLong(id));
   if(null!=report){
	Set<LabTestReportDetail> details = report.getLabTestReportDetails();
	if(details.size()!=0){
	 PatientInfo patient = report.getPatientInfo();
     Boolean isValid = new Boolean(request.getParameter("valid"));
     if(isValid){
 	  String testsCount = request.getParameter("testsCount");
 	  Transaction tx = hsession.beginTransaction();
	  if((null!=testsCount)&&!("".equals(testsCount))){
	   Long testsCountLong = Long.parseLong(testsCount);
	   while(testsCountLong>0l){
		 String testId = request.getParameter("testId"+testsCountLong);
		 String testResult = request.getParameter("result"+testsCountLong);
		 LabTest test = (LabTest)hsession.get(LabTest.class, Long.parseLong(testId));
		 Criteria cr = hsession.createCriteria(LabTestReportDetail.class);
		 Criterion cr1 = Restrictions.eq("labTestReport",report);
		 Criterion cr2 = Restrictions.eq("labTest",test);
		 cr.add(Restrictions.and(cr1,cr2));
		 LabTestReportDetail detail = (LabTestReportDetail)cr.uniqueResult();
		 Long testResultLong = Long.parseLong(testResult);
		 detail.setResult(testResultLong);
		 if(test.getRange()){
		  if(testResultLong<test.getMinValue())
		    detail.setRemarks("Low");
		  else
		  if(testResultLong>test.getMaxValue())  
			detail.setRemarks("High");
		  else
			detail.setRemarks("Normal");  
	     }else{
	      detail.setRemarks(" ");	 
	     }
		 hsession.saveOrUpdate(detail);
		 testsCountLong--;
	   }
	  }
	  try{
		tx.commit();
	  }catch(Exception e){
		e.printStackTrace();
		response.sendRedirect("editReport?id="+report.getId()+"&valid=false&msg=Report Updation Failed"+e.getMessage());
	  }finally {
		hsession.close();
	  }
	  response.sendRedirect("editReport?id="+report.getId()+"&valid=false&msg=Report Updated Successfully");  
     }else{
     %>
     <head>
	  <base href="<%=session.getAttribute("basePath")%>"/>
	  <meta http-equiv="pragma" content="no-cache" />
	  <meta http-equiv="cache-control" content="no-cache" />
	  <meta http-equiv="expires" content="0" />    
	  <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
	  <link type="text/css" href="CSS/menu.css" rel="stylesheet" />
	  <script language="Javascript" src="Scripts/validate.js"></script>
	  <script type="text/javascript">
	  function validateForm(){
		var form1 = document.forms.item(0);
		var testsCount = document.getElementById('testsCount');
		var flag = 0;
		for(var i=1;i<=testsCount.value;i++){
		  var element = document.getElementById('result'+i);
		  var errorspan = document.getElementById('required'+i);
		  if((element.value==null)||(element.value=="")){
		    element.setAttribute('style','border-color:red');
		    errorspan.style.display='block';
		    flag++;
		    break;
		  }else{
			element.removeAttribute('style');
			errorspan.style.display='none';
		  }
		}
		if(flag == 0){
			document.getElementById('valid').value=true;
			form1.submit();
		}
	  }
	  </script>
     </head>
     <body class="hd" onload="settime()">
	  <div class="main">
	   <jsp:include page="Head.jsp" />
	  </div>
	  <jsp:include page="Menu.jsp" />
      <div class="main" style="min-height: 550px;">
  	  <div align="center" class="header">Edit Lab Report Details</div>
  	   <form method="post" action="editReport">
        <table align="center" class="inputForm" width="800px;">
         <tr>
	      <td align="center" colspan="4">
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
		    <tr class="tr_header">
			 <td>S.No.</td>
			 <td>Test Name</td>
			 <td width="150px;">Normal</td>
			 <td width="150px;">Result</td>
			 <td style="background: #F5DDC4"></td>
		    </tr>
		    <%
			 Iterator<LabTestReportDetail> it = details.iterator();
		     int count = 0;
			 while(it.hasNext()){
			  LabTestReportDetail detail = it.next();
			  LabTest test = detail.getLabTest();
			 %>		
			 <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>">
				<td align="center">
				 <%=++count%>
				 <input type="hidden" id="testId<%=count%>" name="testId<%=count%>" value="<%=test.getId()%>" />
				</td>
				<td><%=test.getName()%></td>
				<td align="center">
				 <%
				  if(test.getRange()){
					out.println(ObjectUtil.formatValue(test.getMinValue())+"-"+ObjectUtil.formatValue(test.getMaxValue()));  
				  }else{
					out.println(ObjectUtil.formatValue((test.getNormalValue())?"POSITIVE":"NEGATIVE"));  
				  }
				 %>
				</td>
				<td align="center">
				 <%
				  if(test.getRange()){
					out.print("<input type=text id='result"+count+"' name='result"+count+"' value='"+detail.getResult()+"' />");  
				  }else{%>
					<select id="result<%=count%>" name="result<%=count%>">
					  <option value="">--SELECT--</option>
					  <option value="1" <%=(detail.getResult()==1l)?"selected":""%>>POSITIVE</option>
					  <option value="0" <%=(detail.getResult()==0l)?"selected":""%>>NEGATIVE</option>
					</select>  
				  <%}%>
				</td>
				<td style="background: #F5DDC4" valign="top">
				 <span style="display: none;color: #FF0000;position: absolute; text-align: center; padding: 5px;" id='required<%=count%>' >REQUIRED</span>
				</td>
			 </tr>
			 <%}%>
			 <tr><td colspan="5"><input type="hidden" id="testsCount" name="testsCount" value="<%=count%>" /></td></tr>
		   </table>
  	      </td>
  	     </tr>
  	     <tr><td colspan="4"></td></tr>
  	     <tr align = "center">
	      <td colspan="2">
	       <input type="button" name="ok" id="ok" value="  SAVE  " onclick="validateForm()" />
	      </td>
	      <td colspan="2">
	       <input type="reset" name="cancel" id="cancel" value="  CLEAR  " />
	      </td>
	     </tr>
        </table>
        <input type="hidden" id="valid" name="valid" value="false" />
        <input type="hidden" id="id" name="id" value="<%=report.getId()%>" />
       </form>
      </div>
     </body>
   <%}}else{
	   response.sendRedirect("addReport&id="+report.getId()+"&msg=no report is available");
   }}else{
	   response.sendRedirect("investigationSearchPatient");
   }}else{
	   response.sendRedirect("investigationSearchPatient");
   }}else{
	 response.sendRedirect("validate");
  }%>
</html>
