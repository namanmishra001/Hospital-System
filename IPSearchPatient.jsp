<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
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
	 <link type="text/css" href="CSS/styles.css" rel="stylesheet" media="screen" />
	 <link type="text/css" href="CSS/menu.css" rel="stylesheet" media="screen" />
	 <link type="text/css" href="CSS/tooltip.css" rel="stylesheet" media="screen" />
	 <script language="Javascript" src="Scripts/validate.js"></script>
	 <script language="Javascript" src="Scripts/jquery-1.7.2.js"></script>
	 <script type="text/javascript">
	  function lookup(inputString) {
		if(inputString.length > 0) {
		  $.post("IPSearchPatientResult.jsp",{searchString: ""+inputString+""},function(data){
			$('#searchPatientResult').html(data).show();
		  });
		}else{
			$('#searchPatientResult').html("").show();
			$('#searchInvestigationResult').html("").show();
		}
	  }
	 </script>
   </head>
   <body class="hd" onload="settime()">
	<div class="main">
	  <jsp:include page="Head.jsp" />
	</div>
	<jsp:include page="Menu.jsp" />
	<div class="main">
	  <div align="center" style="height: 100px;padding-top: 50px;">
	    Patient ID or Name of a Patient to Search:
	    <input id="searchString" type="text" onkeyup="lookup(this.value);"/>
	  </div>    
	  <div id="searchPatientResult" align='center' style='min-height:225px;'></div>
	  <div id="searchInvestigationResult" align='center' style='min-height:225px;'></div>
	</div>
   </body>
   <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
