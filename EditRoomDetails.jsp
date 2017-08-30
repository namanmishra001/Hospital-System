<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<%@page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
   Boolean isValid = new Boolean(request.getParameter("valid"));
   String id = request.getParameter("id");
   if(null != id){
	Session hsession = BeanFactory.getSession();
	RoomDetails details = (RoomDetails)hsession.get(RoomDetails.class,Long.parseLong(id));
	if(isValid){
	  String category = request.getParameter("Category");
	  String roomNumber = request.getParameter("RoomNumber");
	  String floorNumber = request.getParameter("FloorNumber");
	  String totalBeds = request.getParameter("TotalBeds");
	  Transaction tx = hsession.beginTransaction();
	  if(null != floorNumber)
		details.setFloorNumber(Long.parseLong(floorNumber));
	  if(null != totalBeds){
		Long oldTotalBeds = details.getTotalBedsCount();
		Long totalBedsLong = Long.parseLong(totalBeds);
		if(totalBedsLong>oldTotalBeds){
		  List<Long> beds = ObjectUtil.csvToList(details.getFreeBeds(),",");
		  System.out.println("Beds"+beds);
		  for(Long i=oldTotalBeds+1;i<=totalBedsLong;i++){
			 beds.add(i); 
		  }
		  details.setTotalBedsCount(totalBedsLong);
		  details.setFreeBeds(ObjectUtil.listToCsv(beds,","));
		  hsession.saveOrUpdate(details);
		}else if(totalBedsLong<oldTotalBeds){
			System.out.println("totalBedsLong<oldTotalBeds");
		}else{
			hsession.saveOrUpdate(details);
		}
	  }
	  try{
		 tx.commit();
	  }catch(Exception e){
		 e.printStackTrace();
	  }finally{
	     hsession.close();
	  }
	  response.sendRedirect("viewRoomDetails?valid=false&msg=Room Details Updated Successfully&id="+details.getId());
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
  <div class="main">
   <div style="min-height: 500px;">
  	<div align="center" class="header">Enter Room Details</div>
  	<form method="post" name="detailsData" action="editRoomDetails">
     <table align="center" class="inputForm">
	  <tr>
	   <td align="right"><span class='error'>* </span>Category</td>
	   <td align="left">
	     <input type="text" readonly="readonly" value="<%=details.getRoomCategory().getName()%>" />
	     <input name="Category" id="Category" type="hidden" value="<%=details.getRoomCategory().getId()%>" />
	   </td>
  	  </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="CategoryError" class='error'></div></td>
  	  </tr>
	  <tr>
       <td align="right"><span class='error'>* </span>Room Number</td>
       <td align="left"><input type="text" name="RoomNumber" id="RoomNumber" readonly="readonly" value="<%=details.getRoomnumber()%>"/></td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="RoomNumberError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Floor Number</td>
       <td align="left"><input type="text" name="FloorNumber" id="FloorNumber" value="<%=details.getFloorNumber()%>" onkeypress="return allowNumeric(event)"/>(Only Numbers)</td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="FloorNumberError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Total Beds</td>
       <td align="left"><input type="text" name="TotalBeds" id="TotalBeds" value="<%=details.getTotalBedsCount()%>" onkeypress="return allowNumeric(event)"/>(Only Numbers)</td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="TotalBedsError" class='error'></div></td>
  	  </tr>
	  <tr align = "center">
	   <td>
	    <input type="button" name="ok" id="ok" value="  UPDATE  " onclick="validateForm()" />
	   </td>
	   <td>
	    <input type="reset" name="cancel" id="cancel" value="  CLEAR  " />
	   </td>
	  </tr>
	  <tr><td colspan="2"></td></tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false"/>
     <input type="hidden" id="id" name="id" value="<%=details.getId()%>" />
    </form>
    </div>
   </div>
  </body>
  <%}}else{
		 response.sendRedirect("viewCategories");
	 }
	}else{
	 response.sendRedirect("validate");
  }%>
</html>
