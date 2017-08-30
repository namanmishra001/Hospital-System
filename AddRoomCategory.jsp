<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Transaction"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
	Boolean isValid = new Boolean(request.getParameter("valid"));
	String msg = request.getParameter("msg");
	if(isValid){
	  String CategoryName = request.getParameter("CategoryName");
	  String ChargesPerDay = request.getParameter("ChargesPerDay");
	  Session hsession = BeanFactory.getSession();
	  Transaction tx = hsession.beginTransaction();
	  RoomCategory rc = new RoomCategory();
	  if(null != CategoryName)
	  	rc.setName(CategoryName.toUpperCase());
	  if(null != ChargesPerDay)
	    rc.setChargesperday(Long.parseLong(ChargesPerDay));
	  hsession.save(rc);
	  try{
		 tx.commit();
	  }catch(Exception e){
		 e.printStackTrace();
	  }finally{
	     hsession.close();
	  }
	  response.sendRedirect("addRoomCategory?valid=false&msg=Room Category Saved Successfully");
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
       var categoryName = document.getElementById("CategoryName");
       var chargesPerDay = document.getElementById("ChargesPerDay");
       var categoryNameMsg = document.getElementById("CategoryNameMsg");
       if(!isEmpty(categoryName))
    	if(categoryNameMsg.value=='Category Name is available')
    	 if(!isEmpty(chargesPerDay))
    	  if(chargesPerDay.value!=0){
    	   document.getElementById("valid").value = true;
    	   form1.submit();
    	  }else{
    	   alert("Charges cannot be 0");	 
    	  }
     }
     function lookup(inputString) {
		if(inputString.length >0 ) {
			$.post("ValidateRoomCategory.jsp",{categoryName: ""+inputString+""},function(data){
				//$('#CategoryNameMsg').html(data).show();
				document.getElementById('CategoryNameMsg').value = data;
			});
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
  	<div align="center" class="header">Enter Room Category Information</div>
  	<form method="post" name="CategoryData" action="addRoomCategory">
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
	   <td align="right"><span class='error'>* </span>Category Name</td>
	   <td align="left"><input type="text" name="CategoryName" id="CategoryName" onkeyup="lookup(this.value);"/></td>
  	  </tr>
  	  <tr>
  	   <td align="right" colspan="2"><input type="text" id="CategoryNameMsg" class="msg" value="" /></td>
  	  </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="CategoryNameError" class='error'></div></td>
  	  </tr>
	  <tr>
       <td align="right"><span class='error'>* </span>Charges Per Day</td>
       <td align="left"><input type="text" name="ChargesPerDay" id="ChargesPerDay" onkeypress="return allowNumeric(event)" /></td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="ChargesPerDayError" class='error'></div></td>
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
