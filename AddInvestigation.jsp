<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Query"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="java.util.Calendar"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%try{
 HttpSession session = request.getSession(false);
 if(null != session){
  String id = request.getParameter("id");
  String msg = request.getParameter("msg");
  if(null!=id){
   Session hsession = BeanFactory.getSession();
   PatientInfo patient = (PatientInfo)hsession.get(PatientInfo.class,id);
   if(null!=patient){
    Boolean isValid = new Boolean(request.getParameter("valid"));
    if(isValid){
     String patientId = request.getParameter("PatientId");
     String doctorId = request.getParameter("Consultant");
     String tests = request.getParameter("tests");
     String cost = request.getParameter("cost");
	 Transaction tx = hsession.beginTransaction();  
	 LabTestReport report = new LabTestReport();
	 if(null!=patient){
		report.setPatientInfo(patient);
	 }
	 if(null!=doctorId){
		User consultant = (User)hsession.get(User.class,Long.parseLong(doctorId));
		report.setConsultant(consultant); 
	 }
	 if(null!=tests){
		report.settests(tests);
	 }
	 if(null!=cost){
		report.setTotalCost(Long.parseLong(cost)); 
	 }
	 report.setReportPrescribedDate(Calendar.getInstance().getTimeInMillis());
	 hsession.persist(report);
	 try{
		tx.commit();
		session.removeAttribute("tests");
	 }catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect("addInvestigation?id="+patient.getId()+"&valid=false&msg=Investigation Saving Failed"+e.getMessage());
	 }finally {
		hsession.close();
	 }
	response.sendRedirect("generateLabBill?id="+report.getId()+"&valid=false&msg=Investigation Saved Successfully");
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
	 <script language="Javascript" src="Scripts/jquery-1.7.2.js"></script>
	 <script type="text/javascript">
	  function add(elementId, type){
		var element = document.getElementById(elementId);
		if(element.value != '') {
		  $.post("UpdateTestToInvestigation.jsp",{id: ""+element.value+"",type: ""+type+"",operation: "Add"},function(data){
			$('#selectedTests').html(data).show();
		  });
		}else{
			$('#selectedTests').html("No Tests Selected").show();
		}
	  }
	  function remove(id, type){
		if(id != '') {
		  $.post("UpdateTestToInvestigation.jsp",{id: ""+id+"",type: ""+type+"",operation: "Remove"},function(data){
			$('#selectedTests').html(data).show();
		  });
		}else{
			$('#selectedTests').html("No Tests Selected").show();
		}
	  }
	  function removeProfile(elementId){
		var element = document.getElementById(elementId);
		if(element.value != '') {
		  $.post("UpdateTestToInvestigation.jsp",{id: ""+element.value+"",type: "Profile",operation: "Remove"},function(data){
			$('#selectedTests').html(data).show();
		  });
		}else{
			$('#selectedTests').html("No Tests Selected").show();
		}
	  }
	  function clearForm(){
		var form1 = document.forms.item(0);
		$.post("UpdateTestToInvestigation.jsp",{operation: "Clear"},function(data){
			$('#selectedTests').html(data).show();
		});
		form1.reset();
	  }
	  function validateForm(){
		var form1 = document.forms.item(0);  
		var PatientName = document.getElementById('PatientName');
		var Consultant = document.getElementById('Consultant');
		var tests = document.getElementById('tests');
		if(!isEmpty(PatientName))
		 if(!isEmpty(Consultant))
		  if(tests!=null && tests.value!=''){ 
		    document.getElementById("valid").value = true;
			form1.submit();
		  }
		  else
		   alert("add tests to investigation and then save");
	  }
	 </script>
   </head>
   <body class="hd" onload="settime()" onunload="clearForm()">
	<div class="main">
	  <jsp:include page="Head.jsp" />
	</div>
	<jsp:include page="Menu.jsp" />
    <div class="main" style="min-height: 550px;">
  	<div align="center" class="header">Enter Investigation Information</div>
  	<form method="post" action="addInvestigation">
     <table align="center" class="inputForm">
      <tr>
	   <td align="center" colspan="2">
	   <%
 	    if (null != msg){
 	 	 out.println("<span class='msg'>" + msg + "</span>");
 	 	 String reportid = request.getParameter("reportid");
 	 	 if(null == reportid){
 	 	   hsession = BeanFactory.getSession();
		   Query query1 = hsession.createQuery("select max(id) from LabTestReport");
		   List reports = query1.list();
		   out.println("<a href='generateLabBill?id="+reports.get(0)+"'>Generate Bill</a>"); 
 	 	 }else{
 	 	   out.println("<a href='generateLabBill?id="+reportid+"'>Generate Bill</a>"); 
 	 	 }
 	    }
 	   %>
	   </td>
  	  </tr>
	  <tr>
	   <td align="right"><span class='error'>* </span>Patient Name</td>
	   <td align="left">
	     <input type="text" readonly="readonly" name="PatientName" id="PatientName" value="<%=patient.getName()%>" />
	   </td>
  	  </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="PatientNameError" class='error'></div></td>
  	  </tr>
  	  <tr>
  	   <td align="right"><span class='error'>* </span>Consultant Name </td>
	   <td align="left">
	    <%
	     User consultant = patient.getConsultant();
	     %>
		 <select name="Consultant" id="Consultant">
		  <option value="">---SELECT---</option>
		  <%
		   Session hsession1 = BeanFactory.getSession();
		   String queryString = "from User where role=3 order by name";
		   Query q1 = hsession1.createQuery(queryString);
		   List doctors = q1.list();
		   if(null!=doctors && doctors.size()>0){
		 	 Iterator it = doctors.iterator();
			 while(it.hasNext()){
				 User user1 = (User)it.next();
			 %>
			  <option value="<%=user1.getId()%>" <%=consultant.getId().equals(user1.getId())?"selected":""%>><%=user1.getName()%></option>
		    <%}
		   }%>
		 </select>
	   </td>
	  </tr>
	  <tr>
	   <td align="right" colspan="2"><div id="ConsultantError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Select Tests</td>
       <td align="left">
       	 <select name="SelectedTests" id="SelectedTests">
		  <option value="">---SELECT---</option>
		  <%
		  	hsession = BeanFactory.getSession();
		    queryString = "from LabTest order by name";
		    q1 = hsession.createQuery(queryString);
		  	List tests = q1.list();
		  	if (null != tests && tests.size() > 0) {
		  	  Iterator it = tests.iterator();
		  	  while (it.hasNext()) {
		  		LabTest test = (LabTest) it.next();
		        %>
				<option value="<%=test.getId()%>"><%=test.getName()%></option>
			    <%
			  }
			}
		 %>
		 </select>
		 <input type="button" value="Add Test" onclick="add('SelectedTests','Test')"/>
       </td>
      </tr>
 	  <tr>
	   <td align="right" colspan="2"><div id="SelectedTestsError" class='error'></div></td>
  	  </tr>     
	  <tr>
       <td align="right"><span class='error'>* </span>Select Profiles</td>
       <td align="left">
       	 <select name="SelectedProfiles" id="SelectedProfiles">
		  <option value="">---SELECT---</option>
		  <%
		  	hsession = BeanFactory.getSession();
		    queryString = "from LabTestProfile order by name";
		  	q1 = hsession.createQuery(queryString);
		  	List testProfiles = q1.list();
		  	if (null != testProfiles && testProfiles.size() > 0) {
		  	  Iterator it = testProfiles.iterator();
		  	  while (it.hasNext()) {
		  		LabTestProfile profile = (LabTestProfile) it.next();
		        %>
				<option value="<%=profile.getId()%>"><%=profile.getName()%></option>
			    <%
			  }
			}
		 %>
		 </select>
		 <input type="button" value="Add Profile" onclick="add('SelectedProfiles','Profile')"/>
		 <input type="button" value="Remove Profile" onclick="removeProfile('SelectedProfiles')"/>
       </td>
      </tr>
      <tr>
       <td colspan="2"><div id="selectedTests" align="center">No Tests Selected</div></td>
      </tr>
	  <tr align = "center">
	   <td>
	    <input type="button" name="ok" id="ok" value="  SAVE  " onclick="validateForm()" />
	   </td>
	   <td>
	    <input type="button" name="cancel" id="cancel" value="  CLEAR  "  onclick="clearForm()"/>
	   </td>
	  </tr>
	  <tr><td colspan="2"></td></tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false" />
     <input type="hidden" id="id" name="id" value="<%=patient.getId()%>" />
    </form>
   </div>
   </body>
   <%}}else{
	   response.sendRedirect("addInvestigationSearchPatient");
   }}else{
	   response.sendRedirect("addInvestigationSearchPatient");
	   }
   }else{
	 response.sendRedirect("validate");
  }}catch(Exception e){}
   finally{
	   HttpSession session = request.getSession(false);
	   if(null!=session)
		   session.removeAttribute("tests");
   }%>
</html>
