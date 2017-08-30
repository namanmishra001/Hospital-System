<%@ page language="java" session="false" import="info.inetsolv.bean.*,info.inetsolv.tools.*,org.hibernate.*,java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.criterion.Order"%>
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
   <div class="main">
    <div style='min-height:500px;'>
     <%
	  Session hsession = BeanFactory.getSession();
	  Criteria cr = hsession.createCriteria(RoomCategory.class);
	  cr.addOrder(Order.asc("id"));
	  List categoryList = cr.list();
	  if(null!=categoryList && categoryList.size()>0){	
	 %>
     <div align="center" class="header" style="margin-top: 20px;">Available Room Categories</div>	 
	   <table align="center" >				
		<tr class="tr_header">
		  <td>Id</td>
		  <td>Category Name</td>
		  <td>Charges Per Day</td>
		  <td>Edit?</td>
		</tr>
	   <%
		Iterator it = categoryList.iterator();
	    int count = 0;
		while(it.hasNext()){
		  RoomCategory roomCategory = (RoomCategory)it.next();
		  %>		
		  <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
			<td align="center"><%=roomCategory.getId()%></td>
			<td><%=roomCategory.getName()%></td>
			<td align="center"><%=roomCategory.getChargesperday()%></td>
			<td><a href="editRoomCategory?id=<%=roomCategory.getId()%>">Edit</a></td>
		  </tr>
		  <%
		  count++;
		}
		%>
	</table>
	<%hsession.close();
	}else{
	%>
	<div align="center" class="error" style="margin-top: 20px;">Room Categories Not Available</div>
	<%}%>
	<div align="center" class="header">
     <form action="addRoomCategory">
      <input type="submit" value="ADD NEW CATEGORY" />
     </form>
    </div>	
    </div> 
   </div>
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
