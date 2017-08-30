<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){%>
 <head>
    <base href="<%=session.getAttribute("basePath")%>"/>
 	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="expires" content="0" />    
    <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
	<link type="text/css" href="CSS/menu.css" rel="stylesheet" />
    <script language="Javascript" src="Scripts/validate.js"></script>
 </head>
 <body class="hd" onload="settime()">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main" style="min-height: 520px;">
   <p style="text-indent:50px;line-height:40px;font-size:20px;text-align:justify;margin:20px 30px 0px;">
   	Welcome to HealthCare Management & Information Retrieval System. This software will make you to work efficiently. To know about any option in the menu please move your mouse pointer on to it.
   </p>
   </div>
 </body>
   <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
