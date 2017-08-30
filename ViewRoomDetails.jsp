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
   <div class="main">
    <div style='min-height:500px;'>
	  <%
	   Session hsession = BeanFactory.getSession();
	   Criteria cr = hsession.createCriteria(RoomDetails.class);
	   cr.addOrder(Order.asc("floorNumber"));
	   List detailsList = cr.list();
	   if(null!=detailsList && detailsList.size()>0){	
	   %>
	   <div align="center" class="header" style="margin-top: 20px;">Available Room Details</div>
	   <table align="center" >				
		<tr class="tr_header">
		  <td>Floor Number</td>
		  <td>Room Number</td>
		  <td>Category Name</td>
		  <td>Total Beds</td>
		  <td>Free Beds</td>
		  <td>Occupied Beds</td>
		  <td>Edit?</td>
		</tr>
	   <%
		Iterator it = detailsList.iterator();
	    int count = 0;
		while(it.hasNext()){
		  RoomDetails roomDetails = (RoomDetails)it.next();
		  %>		
		  <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
			<td align="center"><%=roomDetails.getFloorNumber()%></td>
			<td align="center"><%=roomDetails.getRoomnumber()%></td>
			<td><%=roomDetails.getRoomCategory().getName()%></td>
			<td align="center"><%=roomDetails.getTotalBedsCount()%></td>
			<td align="center"><%=ObjectUtil.formatValue(roomDetails.getFreeBeds())%></td>
			<td align="center"><%=ObjectUtil.formatValue(roomDetails.getOccupiedBeds())%></td>
			<td><a href="editRoomDetails?id=<%=roomDetails.getId()%>">Edit</a></td>
		  </tr>
		  <%
		  count++;
		}
		%>
	  <tr>
 	   <th colspan="7" align="center">
 	 	<%
 	 	 if(null != msg)
			out.println("<span class='msg'>"+msg+"</span>");
 	 	%>	
 	   </th>
 	  </tr>
	</table>
	<%hsession.close();
	}else{
	%>
	 <div align="center" class="error" style="margin-top: 20px;">Room Details Not Available</div>
	<%}
	   User loggedUser = (User)session.getAttribute("user");
	   if((null!=loggedUser)&&(loggedUser.getUserRole().getId()==2||loggedUser.getUserRole().getId()==1)){
	   %>
		<div align="center" class="header">
	      <form action="addRoomDetails">
	       <input type="submit" value="ADD NEW ROOM DETAILS" />
	      </form>
	     </div>			
	   </div>
	   <%}%>
   </div>
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
