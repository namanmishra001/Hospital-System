<%@page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.*"%>
<%@page import="java.util.*"%>
<%@page import="org.hibernate.criterion.*"%>
<%@page import="info.inetsolv.tools.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
	Boolean isValid = new Boolean(request.getParameter("valid"));
	String msg = request.getParameter("msg");
	String id = request.getParameter("id");
	if(null != id){
	 Session hsession = BeanFactory.getSession();
	 PatientInfo patient = (PatientInfo)hsession.get(PatientInfo.class,id);
	 if(isValid){
	  String doctor = request.getParameter("DoctorName");
	  String roomNumber = request.getParameter("RoomNumber");
	  String bedNumber = request.getParameter("BedNumber");
	  String subCategory = request.getParameter("SubCategory");
	  hsession = BeanFactory.getSession();
	  Transaction tx = hsession.beginTransaction();
	  RoomOccupancy occupancy = new RoomOccupancy();
	  IpBill bill = new IpBill();
	  RoomDetails details = null;
	  if(null != doctor){
		User user = (User)hsession.get(User.class,Long.parseLong(doctor));  
	  	occupancy.setConsultant(user);
	  	bill.setConsultant(user);
	  }
	  if(null != patient){
		bill.setPatientInfo(patient);
		occupancy.setPatient(patient);
	  }
	  if(null != roomNumber){
		details = (RoomDetails)hsession.get(RoomDetails.class,Long.parseLong(roomNumber));
                occupancy.setRoomDetails(details); 
	  }
	  if((null != bedNumber)&&(!"".equals(bedNumber))){
                occupancy.setBedNumber(Long.parseLong(bedNumber));
                List freeBeds = ObjectUtil.csvToList(details.getFreeBeds(),",");
                freeBeds.remove(Long.parseLong(bedNumber));
                Collections.sort(freeBeds);
                details.setFreeBeds(ObjectUtil.listToCsv(freeBeds,","));
                List occupiedBeds = ObjectUtil.csvToList(details.getOccupiedBeds(),",");
                occupiedBeds.add(Long.parseLong(bedNumber));
                Collections.sort(occupiedBeds);
                details.setOccupiedBeds(ObjectUtil.listToCsv(occupiedBeds,","));
	  }
	  occupancy.setIpBill(bill);
	  User user1 = (User)session.getAttribute("user");
	  if(null != user1)
		occupancy.setGivenBy(user1);
	  Long inTime = Calendar.getInstance().getTimeInMillis();
	  bill.setAdmittedDate(DateUtil.baseLineDate(inTime));
	  occupancy.setDatetimein(inTime);
	  hsession.save(bill);
	  hsession.save(occupancy);
	  hsession.saveOrUpdate(details);
	  try{
		 tx.commit();
	  }catch(Exception e){
		 e.printStackTrace();
		 response.sendRedirect("addIPDetails?valid=false&msg=Adding IP Details Failed Because of "+e+"&id="+patient.getId());		 
	  }finally{
	     hsession.close();
	  }
	  response.sendRedirect("addIPDetails?valid=false&msg=IP Details Saved Successfully&id="+patient.getId());
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
       var patientName = document.getElementById("PatientName");
       var doctorName = document.getElementById("DoctorName");
       var roomCategory = document.getElementById("RoomCategory");
       var roomNumber = document.getElementById("RoomNumber");
       var bedNumber = document.getElementById("BedNumber");
       if(!isEmpty(patientName))
    	if(!isEmpty(doctorName))
    	 if(!isEmpty(roomCategory))
    	  if(!isEmpty(roomNumber))
    	   if(!isEmpty(bedNumber)){
    	     document.getElementById("valid").value = true;
    	     form1.submit();
    	   }
     }
     $(document).ready(function(){
		//called when a room category is changed
		$("#RoomCategory").change(function (e){
			var roomCategory = document.getElementById("RoomCategory").value;
			var chargesPerDay = document.getElementById("ChargesPerDay");
			if((null != roomCategory)&&("" != roomCategory)){
			 chargesPerDay.value = document.getElementById('amount'+roomCategory).value;
			 $.post("GetRoomNumbers.jsp",{roomCategory: ""+roomCategory+""},function(data){
                            $("#RoomNumberDiv").html(data).show();
                            $("#RoomNumber").change(function (e){
			    var roomNumber = document.getElementById("RoomNumber").value;
			    if((null != roomNumber)&&("" != roomNumber)){
			       $.post("GetBedNumbers.jsp",{roomDetailsId: ""+roomNumber+""},function(data){
				     $("#BedNumberDiv").html(data).show();
			       });
			    }else{
			       var data = "<select disabled='disabled'><option value=''>--Select--</option></select>"
			       $("#BedNumberDiv").html(data).show();
			    }
		        });
			 });
		    }else{
				var data = "<select disabled='disabled'><option value=''>--Select--</option></select>"
				$("#RoomNumberDiv").html(data).show();
				chargesPerDay.value="";
			}
		});
     }); 
   </script>
  </head>
  <body class="hd" onload="settime()">
  <div class="main">
   <jsp:include page="Head.jsp" />
  </div>
  <jsp:include page="Menu.jsp" />
  <div class="main" style="min-height: 500px;">
  	<div align="center" class="header">Enter In-Patient Details</div>
  	<form method="post" name="IPDetailsForm" id="IPDetailsForm" action="addIPDetails">
     <table align="center" class="inputForm" width="860px">
      <tr>
 	   <th colspan="4" align="center">
 	 	<%
 	 	 if(null != msg)
			out.println("<span class='msg'>"+msg+"</span>");
 	 	%>	
 	   </th>
 	  </tr>
	  <tr>
	   <td align="right"><span class='error'>* </span>Patient Name</td>
	   <td align="left"><input type="text" name="PatientName" id="PatientName" value="<%=patient.getName()%>"/></td>
	   <td align="right"><span class='error'>* </span>Doctor Name</td>
	   <td align="left">
	    <select id="DoctorName" name="DoctorName">
	    <option value="">--Select--</option>
	     <%
		  hsession = BeanFactory.getSession();
		  String queryString = "from User where status=1 and role=3 order by id";
		  Query q1 = hsession.createQuery(queryString);
		  List doctors = q1.list();
		  if(null!=doctors && doctors.size()>0){
			Iterator it = doctors.iterator();
			while(it.hasNext()){
			 User user = (User)it.next();
		     %>
			  <option value="<%=user.getId()%>"><%=user.getName()%></option>
		   <%}
		  }
	     %>
	    </select>
	   </td>
  	  </tr>
  	  <tr>
  	   <td align="right" colspan="2"><div id="PatientNameError" class='error'></div></td>
  	   <td align="right" colspan="2"><div id="DoctorNameError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>*</span>Room Category</td>
       <td align="left">
        <select name="RoomCategory" id="RoomCategory">
         <option value="">--Select--</option>
	     <%
	       hsession = BeanFactory.getSession();
	       Criteria cr = hsession.createCriteria(RoomCategory.class);
	       cr.addOrder(Order.asc("id"));
		   List categories = cr.list();
		   if(null!=categories && categories.size()>0){
			Iterator it = categories.iterator();
			while(it.hasNext()){
			 RoomCategory category = (RoomCategory)it.next();
			 %>
				<option value="<%=category.getId()%>"><%=category.getName()%></option>
			 <%}
		   }
		  %>
        </select>
        <%
           hsession = BeanFactory.getSession();
           Criteria cr1 = hsession.createCriteria(RoomCategory.class);
           cr1.addOrder(Order.asc("id"));
           List categories1 = cr1.list();
            if(null!=categories1 && categories1.size()>0){
                   Iterator it = categories1.iterator();
                   while(it.hasNext()){
                         RoomCategory category = (RoomCategory)it.next();
                         if(null != category){%>
                          <input type="hidden" id="amount<%=category.getId()%>" name="amount<%=category.getId()%>" value="<%=category.getChargesperday()%>" />
                    <%}
                   }
            }%>
       </td>
       <td align="right">Charges Per Day</td> 
       <td align="left">
        <input type="text" name="ChargesPerDay" id="ChargesPerDay" readonly="readonly" value="" />
       </td>
      </tr>
      <tr>
	   <td align="right" colspan="2"><div id="RoomCategoryError" class='error'></div></td>
	   <td align="right" colspan="2"><div id="ChargesPerDayError" class='error'></div></td>
      </tr>
      <tr>
       <td align="right"><span class='error'>* </span>Room Number</td>
       <td align="left">
        <div id="RoomNumberDiv">
            <select disabled="disabled">
	      <option value="">--Select--</option>
	    </select>
	</div>
       </td>
       <td align="right"><span class='error'>* </span>Bed Number</td>
       <td align="left">
        <div id="BedNumberDiv">
            <select disabled="disabled">
	      <option value="">--Select--</option>
	    </select>
	</div>
       </td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="RoomNumberError" class='error'></div></td>
	   <td align="right" colspan="2"><div id="BedNumberError" class='error'></div></td>
  	  </tr>
	  <tr align = "center">
	   <td colspan="2">
	    <input type="button" name="ok" id="ok" value="  SAVE  " onclick="validateForm()" />
	   </td>
	   <td colspan="2">
	    <input type="reset" name="cancel" id="cancel" value="  CLEAR  " />
	   </td>
	  </tr>
	  <tr><td colspan="2"></td></tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false"/>
     <input type="hidden" id="id" name="id" value="<%=patient.getId()%>"/>
    </form>
   </div>
  </body>
  <%}
	}else{
	 response.sendRedirect("ipSearchPatient");	
  }}else{
	 response.sendRedirect("validate");
  }%>
</html>
