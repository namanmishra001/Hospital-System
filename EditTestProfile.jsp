<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.BeanFactory"%>
<%@page import="org.hibernate.Query"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="info.inetsolv.bean.LabTest"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="info.inetsolv.bean.LabTestProfile"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
  Boolean isValid = new Boolean(request.getParameter("valid"));
  String id = request.getParameter("id");
  if(null!=id){
   Session hsession = BeanFactory.getSession();
   LabTestProfile testProfile = (LabTestProfile)hsession.get(LabTestProfile.class, Long.parseLong(id));
   if(null!=testProfile){
   session.setAttribute("tests",ObjectUtil.csvToList(testProfile.getTests(),","));
   if(isValid){
	String testProfileName = request.getParameter("TestProfileName");
	String tests = request.getParameter("tests");
	Transaction tx = hsession.beginTransaction();
	if(null!=testProfileName)
	  testProfile.setName(testProfileName.toUpperCase());
	if(null!=tests)
	  testProfile.setTests(tests);
	hsession.saveOrUpdate(testProfile);
	try{
		tx.commit();
		session.removeAttribute("tests");
	}catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect("viewTestProfiles?msg=Test Profile Updation Failed"+e.getMessage());
	}finally {
		hsession.close();
	}
	response.sendRedirect("viewTestProfiles?msg=Test Profile updated Successfully");  
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
	  function lookup(inputString) {
		var oldName = document.getElementById("OldTestProfileName");
		if((inputString.length > 0)&&(inputString.value != oldName.value)) {
		  $.post("ValidateTestProfileName.jsp",{profileName: ""+inputString+""},function(data){
			document.getElementById('TestProfileNameMsg').value = data;
		  });
		}else{
			document.getElementById('TestProfileNameMsg').value = "";
		}
	  } 
	  function addTest(elementId){
		var element = document.getElementById(elementId);
		if(element.value != '') {
		  $.post("UpdateTestToProfile.jsp",{testId: ""+element.value+"",operation: "Add"},function(data){
			$('#selectedTests').html(data).show();
		  });
		}else{
			$('#selectedTests').html("").show();
		}
	  }
	  function removeTest(testId){
		if(testId != '') {
		  $.post("UpdateTestToProfile.jsp",{testId: ""+testId+"",operation: "Remove"},function(data){
			$('#selectedTests').html(data).show();
		  });
		}else{
			$('#selectedTests').html("").show();
		}
	  }
	  function clearForm(){
		var form1 = document.forms.item(0);
		$.post("UpdateTestToProfile.jsp",{operation: "Clear"},function(data){
			$('#selectedTests').html(data).show();
		});
		form1.reset();
	  }
	  function validateForm(){
		var form1 = document.forms.item(0);  
		var TestProfileName = document.getElementById('TestProfileName');
		var TestProfileNameMsg = document.getElementById('TestProfileNameMsg');
		var tests = document.getElementById('tests');
		if(!isEmpty(TestProfileName))
		 if(TestProfileNameMsg.value==''||TestProfileNameMsg.value == 'Test Profile is available')
		  if(tests!=null && tests.value!=''){ 
		    document.getElementById("valid").value = true;
			form1.submit();
		  }
		  else
		   alert("add tests to profile and then save");
	  }
	  $(document).ready(function(){
		$.post("UpdateTestToProfile.jsp",{},function(data){
			$('#selectedTests').html(data).show();
		});
	  });
	 </script>
   </head>
   <body class="hd" onload="settime()">
	<div class="main">
	  <jsp:include page="Head.jsp" />
	</div>
	<jsp:include page="Menu.jsp" />
    <div class="main" style="min-height: 550px;">
  	<div align="center" class="header">Enter Test Profile Information</div>
  	<form method="post" action="editTestProfile">
     <table align="center" class="inputForm">
	  <tr>
	   <td align="right"><span class='error'>* </span>Test Profile Name</td>
	   <td align="left">
	    <input type="text" name="TestProfileName" id="TestProfileName" value="<%=testProfile.getName()%>" onkeyup="lookup(this.value);"/>
	    <input type="hidden" name="OldTestProfileName" id="OldTestProfileName" value="<%=testProfile.getName()%>" />
	   </td>
  	  </tr>
  	  <tr>
  	   <td align="right" colspan="2"><input type="text" id="TestProfileNameMsg" class="msg" value="" readonly="readonly"/></td>
  	  </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="TestProfileNameError" class='error'></div></td>
  	  </tr>
	  <tr>
       <td align="right"><span class='error'>* </span>Select Tests</td>
       <td align="left">
       	 <select name="SelectTests" id="SelectTests">
		  <option value="">---SELECT---</option>
		  <%
		  	Session hsession1 = BeanFactory.getSession();
		  	String queryString = "from LabTest order by name";
		  	Query q1 = hsession.createQuery(queryString);
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
		 <input type="button" value="Add Test" onclick="addTest('SelectTests')"/>
       </td>
      </tr>
      <tr>
       <td colspan="2"></td>
      </tr>
	  <tr align = "center">
	   <td>
	    <input type="button" name="ok" id="ok" value="  UPDATE  " onclick="validateForm()" />
	   </td>
	   <td>
	    <input type="button" name="cancel" id="cancel" value="  CLEAR  "  onclick="clearForm()"/>
	   </td>
	  </tr>
	  <tr><td colspan="2"></td></tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false"/>
     <input type="hidden" id="id" name="id" value="<%=testProfile.getId()%>"/>
     <div id="selectedTests"></div>
    </form>
   </div>
   </body>
   <%}}else{
		 response.sendRedirect("viewTestProfiles");
	 }}else{
		 response.sendRedirect("viewTestProfiles");
	 }
   }else{
	 response.sendRedirect("validate");
  }%>
</html>