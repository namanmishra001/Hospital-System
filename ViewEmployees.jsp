<%@ page language="java" session="false" import="info.inetsolv.bean.*,info.inetsolv.tools.*,org.hibernate.*,java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.criterion.Order"%>
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
     <div align="center" class="header">Employee Details</div>	 
	   <%
		 Session hsession = BeanFactory.getSession();
	     Criteria cr = hsession.createCriteria(User.class);
	     cr.addOrder(Order.asc("id"));
		 List users = cr.list();
		 if(null!=users && users.size()>0){	
	   %>
	    <table align="center" >				
		<tr class="tr_header">
			<td>Id</td>
			<td>Name</td>
			<td>Role</td>
			<td>Phone No</td>
			<td>Email</td>
			<td>Qualification</td>
			<td>Speciality</td>
			<td>Date Of Join</td>
			<td>Date Of Left</td>
			<td>Status</td>
			<td>Edit?</td>
		</tr>
	   <%
		Iterator it = users.iterator();
	    int count = 0;
		while(it.hasNext()){
		  User user = (User)it.next();
		  %>		
		  <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
			<td><%=user.getId()%></td><td><%=user.getName()%></td><td><%=user.getUserRole().getRole()%></td>
			<td><%=ObjectUtil.formatValue(user.getPhonenumber())%></td>
			<td><%=ObjectUtil.formatValue(user.getEmail())%></td>
			<td><%=ObjectUtil.formatValue(user.getQualification())%></td>
			<td><%=ObjectUtil.formatValue(user.getSpeciality())%></td>
			<td><%=(null != user.getDoj())?DateUtil.formatDate("dd-MM-yyyy",user.getDoj()):""%></td>
			<td><%=(null != user.getDol() && user.getDol() != 0l)?DateUtil.formatDate("dd-MM-yyyy",user.getDol()):""%></td>
			<td><%=((null!=user.getStatus())&&(user.getStatus()==true))?"Active":"Inactive"%></td>
			<td><a href="editEmployee?id=<%=user.getId()%>">Edit</a></td>
		  </tr>
		  <%
		  count++;
		}%>
		<tr>
 	 	  <th colspan="11" align="center">
 	 	   	 <%
 	 	   	  if(null != msg)
				out.println("<span class='msg'>"+msg+"</span>");
 	 		 %>	
 	 	  </th>
 	 	</tr>
		</table><%
	}else{
	%>
	<div class="error">Employee Information Not Available</div>
	<%}%>		
   </div>
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
