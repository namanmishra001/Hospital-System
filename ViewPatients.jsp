<%@ page language="java" session="false" import="org.hibernate.*,java.util.*,info.inetsolv.bean.*,info.inetsolv.tools.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
  %>
  <head>
   <base href="<%=session.getAttribute("basePath")%>"/>
   <meta http-equiv="pragma" content="no-cache" />
   <meta http-equiv="cache-control" content="no-cache" />
   <meta http-equiv="expires" content="0" />
   <meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
   <meta http-equiv="description" content="This is my page" />
   <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
   <link type="text/css" href="CSS/menu.css" rel="stylesheet" />
   <link type="text/css" href="CSS/DatePicker.css" rel="stylesheet" />
   <script language="Javascript" src="Scripts/validate.js"></script>
   <script language="Javascript" src="Scripts/jquery-1.7.2.js"></script>
   <script language="Javascript" src="Scripts/DatePicker.js"></script>
   <script type="text/javascript">
	function getPatients() {
	  var inputString = document.getElementById("regddate").value;
	  if(inputString.length > 0) {
		$.post("ViewPatientsResult.jsp",{searchString: ""+inputString+""},function(data){
		 $('#viewPatientsResult').html(data).show();
		});
	  }else{
		$('#viewPatientsResult').html("").hide();
		alert("Select a Date to Display Patient Info");
	  }
	}
	function getData(){
		$("#getData").click();
	} 
   </script>
  </head>
  <body class="hd" onload="javascript: settime(); getData();">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main">
   	<div align="center" style="height:100px;padding-top:50px;">
   	  List of Patients Registered on 
   	  <input type="text" readonly="readonly" id="regddate" name="regddate" value='<%=new SimpleDateFormat("dd-MM-yyyy").format(new Date())%>' size="9" class="timer"/>
   	  <img src="Images/CalDis.gif" alt="Select Date" onmouseover="this.src='Images/CalEn.gif';" onmouseout="this.src='Images/CalDis.gif';" onclick="displayDatePicker('regddate',false,'dmy','-');"/>
   	  <input type="button" id="getData" value="Get Patients" onclick="getPatients();" />
   	</div>
   	<div id="viewPatientsResult" align='center' style='min-height:550px;'></div>
   </div>
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
