<%@ page language="java" session="false" import="org.hibernate.*,java.util.*,info.inetsolv.bean.*,info.inetsolv.tools.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	String msg = request.getParameter("msg");
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
	function getTests() {
	  var TestDepartment = document.getElementById("TestDepartment").value;
	  if(TestDepartment.length > 0) {
		$.post("ViewTestsResult.jsp",{searchString: ""+TestDepartment+""},function(data){
		 $('#viewTestsResult').html(data).show();
		});
	  }else{
		$('#viewTestsResult').html("").show();
	  }
	}
   </script>
  </head>
  <body class="hd" onload="javascript: settime(); getTests();">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main">
   	<div align="center" style="height:100px;padding-top:50px;">
   	  List of Lab Tests of
   	  <select name="TestDepartment" id="TestDepartment" onchange="getTests();">
		  <option value="ALL">ALL</option>
		  <%
		  	Session hsession = BeanFactory.getSession();
		  	String queryString = "from LabTestDepartment order by name";
		  	Query q1 = hsession.createQuery(queryString);
		  	List departments = q1.list();
		  	if (null != departments && departments.size() > 0) {
		  	  Iterator it = departments.iterator();
		  	  while (it.hasNext()) {
		  		LabTestDepartment department = (LabTestDepartment) it.next();
		        %>
				<option value="<%=department.getId()%>"><%=department.getName()%></option>
			    <%
			  }
			}
		 %>
	  </select> 
   	  Department(s) 
   	</div>
   	<div align="center">
  	<%
 	  if (null != msg)
 	 	out.println("<span class='msg'>" + msg + "</span>");
 	%>
 	</div>
   	<div id="viewTestsResult" align='center' style='min-height:500px;'></div>
   </div>
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
