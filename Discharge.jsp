<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.regex.*"%>
<%@page import="org.hibernate.criterion.Order"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){
  Boolean isValid = new Boolean(request.getParameter("valid"));
  String msg = request.getParameter("msg");
  String seqNo = request.getParameter("seqno");
  if((null != seqNo)&&(!"".equals(seqNo))){
	Session hsession = BeanFactory.getSession();
	RoomOccupancy occupancy = (RoomOccupancy)hsession.get(RoomOccupancy.class,Long.parseLong(seqNo));
	if(null!=occupancy){
	 IpBill bill = occupancy.getIpBill();
         User consultant = occupancy.getConsultant();
         PatientInfo patient = occupancy.getPatient();
         RoomDetails details = occupancy.getRoomDetails();
         Long today = Calendar.getInstance().getTimeInMillis();
         if(null==occupancy.getDatetimeout()){
            Transaction tx = hsession.beginTransaction();
            List<Long> occupiedBeds = ObjectUtil.csvToList(details.getOccupiedBeds(),",");
            occupiedBeds.remove(occupancy.getBedNumber());
            Collections.sort(occupiedBeds);
            details.setOccupiedBeds(ObjectUtil.listToCsv(occupiedBeds,","));
            List<Long> freeBeds = ObjectUtil.csvToList(details.getFreeBeds(),",");
            freeBeds.add(occupancy.getBedNumber());
            Collections.sort(freeBeds);
            details.setFreeBeds(ObjectUtil.listToCsv(freeBeds,","));
            occupancy.setDatetimeout(today);
            hsession.saveOrUpdate(occupancy);
            hsession.saveOrUpdate(details);
            tx.commit();
         }
	 if(isValid){
            String amount = request.getParameter("TotalCharges");
            String discount = request.getParameter("Discount");
            String discountReason = request.getParameter("DiscountReason");
            String netAmount = request.getParameter("NetAmount");
            String paymentType = request.getParameter("PaymentType");
	    Transaction tx = hsession.beginTransaction();
            User user1 = (User)session.getAttribute("user");
            if(null != user1)
             bill.setUser(user1);
            if((null!=amount)&&!("".equals(amount)))
             bill.setAmount(Float.parseFloat(amount));
            if((null!=discount)&&!("".equals(discount)))
             bill.setDiscount(Float.parseFloat(discount));
            if((null!=discountReason)&&!("".equals(discountReason)))
             bill.setDiscountreason(discountReason);
            if((null!=netAmount)&&!("".equals(netAmount)))
             bill.setNetamount(Float.parseFloat(netAmount));
            if((null!=paymentType)&&!("".equals(paymentType))){
             bill.setPaymentType(paymentType);
            if("Credit".equals(paymentType))
             bill.setPaymentStatus(false);
            else
             bill.setPaymentStatus(true);
            }
            bill.setDischargedDate(today);
            bill.setBillDate(today);
            hsession.persist(bill);
            try{
		tx.commit();
            }catch(Exception e){
                  e.printStackTrace();
                  response.sendRedirect("discharge?valid=false&msg=Discharge Failed Because of "+e+"&seqno="+occupancy.getSeqNo());		 
            }finally{
               hsession.close();
            }
            response.sendRedirect("printIPBill?msg=Patient discharged Successfully&id="+bill.getId());
	}else{
         Set<RoomOccupancy> occupancies = bill.getRoomOccupancies();
         double roomCharges = 0;
         double doctorCharges = 0;
         double totalCharges = 0;
         if(null!=occupancies){
            for(RoomOccupancy occupancy1:occupancies){
                Float timeSpent = (float) (occupancy1.getDatetimeout() - occupancy1.getDatetimein());
                RoomCategory category = occupancy1.getRoomDetails().getRoomCategory();
                Long charges = category.getChargesperday();
                double timeSpentInDays = timeSpent/86400000;
				System.out.println(timeSpentInDays);
				timeSpentInDays=Math.ceil(timeSpentInDays);
                roomCharges = roomCharges + timeSpentInDays * charges;
				roomCharges=Math.ceil(roomCharges);
                String categoryName = category.getName();
                if("AC".equals(categoryName)){
                    doctorCharges = doctorCharges + consultant.getPreferences().getaCConsultationFee();
                }else if("ICU".equals(categoryName)){
                    doctorCharges = doctorCharges + consultant.getPreferences().getiCUConsultationFee();
                }else if("Non AC".equals(categoryName)){
                    doctorCharges = doctorCharges + consultant.getPreferences().getNonACConsultationFee();
                }else if("General Ward".equals(categoryName)){
                    doctorCharges = doctorCharges + consultant.getPreferences().getgWConsultationFee();
                }
            }
         }
         totalCharges = doctorCharges + roomCharges;
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
    function getNetAmount(a){
    	var totalCharges = document.getElementById("TotalCharges");
    	var discount = document.getElementById("Discount");
    	if(("" != totalCharges.value)&&("" != discount.value))
    	  a.value = totalCharges.value - discount.value;
    	else if(("" != totalCharges.value)&&("" == discount.value))
    	  a.value = totalCharges.value;
    	else
    	  a.value = "";
    }
    function validateForm(){
      var form1 = document.forms.item(0);
      var patientName = document.getElementById("PatientName");
      var doctorName = document.getElementById("DoctorName");
      var roomCharges = document.getElementById("RoomCharges");
      var doctorCharges = document.getElementById("DoctorCharges");
      var totalCharges = document.getElementById("TotalCharges");
      var discount = document.getElementById('Discount');
      var discountReason = document.getElementById('DiscountReason');
      var netAmount = document.getElementById("NetAmount");
      var paymentType = document.getElementById("PaymentType");
      var valid = document.getElementById("valid");
      if(!isEmpty(patientName))
        if(!isEmpty(doctorName))
         if(!isEmpty(roomCharges))
          if(!isEmpty(doctorCharges))
           if(!isEmpty(totalCharges)){
            if((null == discount.value)||("" == discount.value)){
                if(!isEmpty(netAmount)&&(netAmount.value == totalCharges.value - discount.value)){
                 if(!isEmpty(paymentType)){
                      valid.value = true;
                      form1.submit();
                 }    
                }else{
                    alert("Please check the net amount once");  
                }
            }else{
                if(!isEmpty(discountReason))
                 if(!isEmpty(netAmount)&& (netAmount.value == totalCharges.value - discount.value)){
                      if(!isEmpty(paymentType)){	 
                        valid.value = true;
                        form1.submit();
                      }
                 }else{
                   alert("Please check the net amount once");
                 }
            }
           }
    }
    
   </script>
  </head>
  <body class="hd" onload="settime()">
  <div class="main">
   <jsp:include page="Head.jsp" />
  </div>
  <jsp:include page="Menu.jsp" />
  <div class="main" style="min-height:520px;">
    <div align="center" class="header">Patient IP Bill Info</div>
    <form method="post" name="IPDetailsForm" id="IPDetailsForm" action="discharge">
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
         <td align="left"><input type="text" name="PatientName" id="PatientName" value="<%=patient.getName()%>" readonly/></td>
         <td align="right"><span class='error'>* </span>Doctor Name</td>
         <td align="left"><input type="text" name="DoctorName" id="DoctorName" value="<%=consultant.getName()%>" readonly/></td>
      </tr>
      <tr>
         <td align="right" colspan="2"><div id="PatientNameError" class='error'></div></td>
         <td align="right" colspan="2"><div id="DoctorNameError" class='error'></div></td>
      </tr>
      <tr>
         <td align="right">Date of admission</td>
         <td align="left"><input type="text" name="DOA" id="DOA" value="<%=DateUtil.formatDate("dd-MM-yyyy", bill.getAdmittedDate())%>" readonly/></td>
         <td align="right">Date of discharge</td>
         <td align="left"><input type="text" name="DOD" id="DOD" value="<%=DateUtil.formatDate("dd-MM-yyyy",today)%>" readonly/></td>
      </tr>
      <tr>
         <td align="right" colspan="2"></td>
         <td align="right" colspan="2"></td>
      </tr>
      <tr>
         <td align="right"><span class='error'>* </span>Room Charges:</td>
         <td align="left"><input type="text" name="RoomCharges" id="RoomCharges" value="<%=roomCharges%>" readonly/></td>
         <td colspan="2"></td>
      </tr>
      <tr>
         <td align="right" colspan="2"><div id="RoomChargesError" class='error'></div></td>
         <td colspan="2"></td>
      </tr>
      <tr>
         <td align="right"><span class='error'>* </span>Doctor Charges</td>
         <td align="left"><input type="text" name="DoctorCharges" id="DoctorCharges" value="<%=doctorCharges%>" readonly/></td>
         <td colspan="2"></td>
      </tr>
      <tr>
         <td align="right" colspan="2"><div id="DoctorChargesError" class='error'></div></td>
         <td colspan="2"></td>
      </tr> 
      <tr>
         <td align="right"><span class='error'>* </span>Total Charges</td>
         <td align="left"><input type="text" name="TotalCharges" id="TotalCharges" value="<%=totalCharges%>" readonly/></td>
         <td colspan="2"></td>
      </tr>
      <tr>
         <td align="right" colspan="2"><div id="TotalChargesError" class='error'></div></td>
         <td colspan="2"></td>
      </tr> 
      <tr>
         <td align="right">Discount </td>
         <td align="left"><input type="text" id="Discount" name="Discount" onkeypress="return allowNumeric(event)"/></td>
         <td align="right">Discount Reason:</td>
         <td align="left"><input type="text" id="DiscountReason" name="DiscountReason" /></td>
      </tr>
      <tr>
         <td align="right" colspan="2"><div id="DiscountError" class='error'></div></td>
	 <td align="right" colspan="2"><div id="DiscountReasonError" class="error"></div></td>
      </tr>
      <tr>
         <td align="right">Net Amount:</td>
         <td align="left"><input type="text" id="NetAmount" name="NetAmount" readonly="readonly" onfocus="getNetAmount(this)" /></td>
         <td colspan="2"></td>
      </tr>
      <tr>
	 <td align="right" colspan="2"><div id="NetAmountError" class="error"></div></td>
         <td colspan="2"></td>
      </tr>
      <tr>
         <td align="right"><span class='error'>* </span>Payment Type :</td>
         <td>
           <select id="PaymentType" name="PaymentType">
             <option value="">--SELECT--</option>
             <option value="Cash">CASH</option>
             <option value="Credit">CREDIT</option>
            </select>
         </td>
         <td colspan="2"></td>
     </tr>
     <tr>
          <td colspan="2"><div id="PaymentTypeError" class="error"></div></td>
          <td colspan="2"></td>
     </tr>
      <tr align = "center">
         <td colspan="2">
	    <input type="button" name="ok" id="ok" value="  SAVE  " onclick="validateForm()" />
	 </td>
         <td colspan="2">
	    <input type="reset" name="cancel" id="cancel" value="  CLEAR  " />
	 </td>
      </tr>
      <tr><td colspan="4"><input type="hidden" id="valid" name="valid" value="false"/>
     <input type="hidden" id="seqno" name="seqno" value="<%=occupancy.getSeqNo()%>"/></td></tr>
     </table>
    </form>
   </div>
  </body>
  <%}}else{
	  response.sendRedirect("ipSearchPatient"); 
    }
   }else{
	 response.sendRedirect("ipSearchPatient");	
  }}else{
	 response.sendRedirect("validate");
  }%>
</html>
