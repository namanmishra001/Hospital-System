<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.Criteria"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.criterion.Order"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
	Boolean isValid = new Boolean(request.getParameter("valid"));
	String msg = request.getParameter("msg");
	if(isValid){
	  String category = request.getParameter("Category");
	  String roomNumber = request.getParameter("RoomNumber");
	  String floorNumber = request.getParameter("FloorNumber");
	  String totalBeds = request.getParameter("TotalBeds");
	  Session hsession = BeanFactory.getSession();
	  Transaction tx = hsession.beginTransaction();
	  RoomDetails details = new RoomDetails();
	  if(null != category){
		RoomCategory roomCategory = (RoomCategory)hsession.get(RoomCategory.class, Long.parseLong(category));
		if(null != roomCategory)
	  	  details.setRoomCategory(roomCategory);
	  }
	  if(null != roomNumber)
	    details.setRoomnumber(Long.parseLong(roomNumber));
	  if(null != floorNumber)
		details.setFloorNumber(Long.parseLong(floorNumber));
	  if(null != totalBeds){
		Long totalBedsLong = Long.parseLong(totalBeds);
		details.setTotalBedsCount(totalBedsLong);
		ArrayList<Long> freeBedsList = new ArrayList<Long>();
		for(Long i=1l;i<=totalBedsLong;i++){
		  freeBedsList.add(i);
		}
		details.setFreeBeds(ObjectUtil.listToCsv(freeBedsList,","));
		details.setOccupiedBeds("");
	  }
	  hsession.save(details);
	  try{
		 tx.commit();
	  }catch(Exception e){
		 e.printStackTrace();
	  }finally{
	     hsession.close();
	  }
	  response.sendRedirect("addRoomDetails?valid=false&msg=Room Details Saved Successfully");
	}else{
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
   <script type="text/javascript">
     function validateForm(){
       var form1 = document.forms.item(0);
       var category = document.getElementById("Category");
       var roomNumber = document.getElementById("RoomNumber");
       var floorNumber = document.getElementById("FloorNumber");
       var totalBeds = document.getElementById("TotalBeds");
       if(!isEmpty(category))
    	if(!isEmpty(roomNumber))
    	 if(!isEmpty(floorNumber))
    	  if(!isEmpty(totalBeds))
    	   if(totalBeds.value!=0){
    	    document.getElementById("valid").value = true;
    	    form1.submit();
    	   }else{
    	    alert("Total Beds cannot be 0");	 
    	   }
     }
   </script>
  </head>
  <body class="hd" onload="settime()">
  <div class="main">
   <jsp:include page="Head.jsp" />
  </div>
  <jsp:include page="Menu.jsp" />
  <div class="main" style="min-height: 500px;">
  	<div align="center" class="header">Enter Room Details</div>
  	<form method="post" name="CategoryData" action="addRoomDetails">
     <table align="center" class="inputForm">
      <tr>
 	   <th colspan="4" align="center">
 	 	<%
 	 	 if(null != msg)
			out.println("<span class='msg'>"+msg+"</span>");
 	 	%>	
 	   </th>
 	  </tr>
	  <tr>
	   <td align="right"><span class='error'>* </span>Category</td>
	   <td align="left">
	     <select name="Category" id="Category">
	      <option value="">--Select--</option>
	     <%
	       Session hsession1 = BeanFactory.getSession();
	       Criteria cr = hsession1.createCriteria(RoomCategory.class);
	       cr.addOrder(Order.asc("id"));
		   List categories = cr.list();
		   if(null!=categories && categories.size()>0){
			Iterator it = categories.iterator();
			while(it.hasNext()){
			 RoomCategory category = (RoomCategory)it.next();
			 %>
				<option value="<%=category.getId()%>"><%=category.getName()%></option>
			 <%}
			}hsession1.close();%>
	     </select>
	   </td>
  	  </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="CategoryError" class='error'></div></td>
  	  </tr>
	  <tr>
       <td align="right"><span class='error'>* </span>Room Number</td>
       <td align="left"><input type="text" name="RoomNumber" id="RoomNumber" onkeypress="return allowNumeric(event)"/>(Only Numbers)</td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="RoomNumberError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Floor Number</td>
       <td align="left"><input type="text" name="FloorNumber" id="FloorNumber" onkeypress="return allowNumeric(event)"/>(Only Numbers)</td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="FloorNumberError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Total Beds</td>
       <td align="left"><input type="text" name="TotalBeds" id="TotalBeds" onkeypress="return allowNumeric(event)"/>(Only Numbers)</td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="TotalBedsError" class='error'></div></td>
  	  </tr>
	  <tr align = "center">
	   <td>
	    <input type="button" name="ok" id="ok" value="  SAVE  " onclick="validateForm()" />
	   </td>
	   <td>
	    <input type="reset" name="cancel" id="cancel" value="  CLEAR  " />
	   </td>
	  </tr>
	  <tr><td colspan="2"></td></tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false"/>
    </form>
   </div>
  </body>
  <%}}else{
	 response.sendRedirect("validate");
  }%>
</html>
