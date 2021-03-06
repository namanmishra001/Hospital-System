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
	function getLabReports() {
	  var regddate = document.getElementById("regddate").value;
	  var consultant = document.getElementById("Consultant").value;
	  if(regddate.length > 0) {
		$.post("ViewLabReportsResult.jsp",{searchString: ""+regddate+"",consultant: ""+consultant+""},function(data){
		 $('#viewLabReportsResult').html(data).show();
		});
	  }else{
		$('#viewLabReportsResult').html("").show();
		alert("Select a Date to Display Lab Reports");
	  }
	}
	function showHideFilter(){
		var filter = document.getElementById("filter");
		if(filter.style.display=='none')
			filter.style.display='block';
		else
		  if(filter.style.display=='block'){
			document.getElementById("Consultant").value="";
			filter.style.display='none';
		  }
	}
	function getData(){
		$("#getData").click();
	} 
   </script>
  </head>
  <body class="hd" onload="javascript:settime(); getData();">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main">
    <table align="center" border="0">
    <tr align="center" style="height:100px;padding-top:50px;">
      <td width="350px" align="right" colspan="2">List of all Lab Reports on
       <input type="text" readonly="readonly" id="regddate" name="regddate" value='<%=new SimpleDateFormat("dd-MM-yyyy").format(new Date())%>' size="9" class="timer"/>
       <img src="Images/CalDis.gif" alt="Select Date" onmouseover="this.src='Images/CalEn.gif';" onmouseout="this.src='Images/CalDis.gif';" onclick="displayDatePicker('regddate',false,'dmy','-');"/>
      </td>
      <td><input type="button" id="getData" value="Get Lab Reports" onclick="getLabReports()" /></td>
    </tr>
    <tr align="center" style="height:100px;padding-top:50px;">
      <td colspan="2">
      <span id="filter" style="display: none; text-align: center;">
       Select Doctor/Consultant Name:
       <select name="Consultant" id="Consultant" onchange="getLabBills()">
		 <option value="">ALL</option>
		 <%
		  Session hsession = BeanFactory.getSession();
		  String queryString = "from User where role=3 order by name";
		  Query q1 = hsession.createQuery(queryString);
		  List doctors = q1.list();
		  if(null!=doctors && doctors.size()>0){
			Iterator it = doctors.iterator();
			while(it.hasNext()){
			 User user = (User)it.next();
		     %>
			  <option value="<%=user.getId()%>"><%=user.getName()%></option>
		   <%}
		  }%>
		</select>
		</span>
      </td>
      <td><a href="javascript:showHideFilter()">Show/Hide Filter</a></td> 
    </tr>
   	</table>
   	<div id="viewLabReportsResult" align='center' style='min-height:550px;'></div>
   </div>
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
