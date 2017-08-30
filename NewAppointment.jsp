<%@ page language="java" session="false" import="org.hibernate.*,java.util.*,info.inetsolv.bean.*,info.inetsolv.tools.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	Boolean isValid = new Boolean(request.getParameter("valid"));
	String billId = request.getParameter("billId");
	String patientId = request.getParameter("id");
	String operationType = request.getParameter("OperationType");
    if((null != billId)&&(null != operationType)){
   	  Session hsession = BeanFactory.getSession();
   	  OpBill bill = null;
   	  User consultant = null;
   	  PatientInfo patientInfo = null;
   	  if(!"0".equals(billId)){
	    bill = (OpBill)hsession.get(OpBill.class,Long.parseLong(billId));
	    consultant = bill.getConsultant();
	    patientInfo = bill.getPatientInfo();
   	  }else{
   		patientInfo = (PatientInfo)hsession.get(PatientInfo.class,patientId);   		  
   	  }
	  if(isValid){
		String name = request.getParameter("Name");
		String consultant1 = request.getParameter("Consultant");
		String visitDate = request.getParameter("VisitDate");
		String daySerialNo = request.getParameter("DaySerialNo");
		String amount = request.getParameter("Amount");
		String discount = request.getParameter("Discount");
		String discountReason = request.getParameter("DiscountReason");
		String netAmount = request.getParameter("NetAmount");
		String symptoms = request.getParameter("Symptoms");
		String weight = request.getParameter("Weight");
		String temparature = request.getParameter("Temparature");
		String bloodPressure = request.getParameter("BloodPressure");
		String paymentType = request.getParameter("PaymentType");
		Long visitDateLong = DateUtil.stringToLong(visitDate);
		Transaction tx = hsession.beginTransaction();
		if("New".equals(operationType)){
		  bill = new OpBill();
		  bill.setBillDate(Calendar.getInstance().getTimeInMillis());
		  if((null!=visitDate)&&!("".equals(visitDate))){
			bill.setInitialvisitdate(visitDateLong);
		  }
		  bill.setPatientInfo(patientInfo);
		  if(!(null==consultant1)&&!("".equals(consultant1))){
			consultant = (User)hsession.get(User.class,Long.parseLong(consultant1));
			bill.setConsultant(consultant);
			patientInfo.setConsultant(consultant);
			DoctorPreferences preferences = consultant.getPreferences();
			bill.setValidtilldate(visitDateLong+preferences.getConsultationPeriod()-(24*60*60*1000));
			bill.setVisitscount(preferences.getMaxvisits());
		  }
		  if((null!=amount)&&!("".equals(amount)))
			bill.setAmount(Long.parseLong(amount));
		  if((null!=discount)&&!("".equals(discount)))
			bill.setDiscount(Long.parseLong(discount));
		  if((null!=discountReason)&&!("".equals(discountReason)))
			bill.setDiscountreason(discountReason);
		  if((null!=netAmount)&&!("".equals(netAmount)))
			bill.setNetamount(Long.parseLong(netAmount));
		  if((null!=paymentType)&&!("".equals(paymentType))){
			bill.setPaymentType(paymentType);
			if("Credit".equals(paymentType))
				bill.setPaymentStatus(false);
			else
				bill.setPaymentStatus(true);
		  }
		  User user = (User)session.getAttribute("user");
		  if(null != user)
			bill.setUser(user);
		  hsession.save(bill);
		}
		OpVisit visit = new OpVisit();
		visit.setConsultant(consultant);
		visit.setOpBill(bill);
		visit.setBloodpressure(bloodPressure);
		visit.setSymptoms(symptoms);
		visit.setTemperature(temparature);
		visit.setWeight(weight);
		visit.setVisitdate(visitDateLong);
		if((null != daySerialNo) &&!("".equals(daySerialNo)))
		  visit.setDayserial(Long.parseLong(daySerialNo));
		hsession.save(visit);
		if(null != patientInfo.getTotalVisits())
		 patientInfo.setTotalVisits(patientInfo.getTotalVisits()+1l);
		else
		 patientInfo.setTotalVisits(1l);
		hsession.saveOrUpdate(patientInfo);
		try{
		  tx.commit();
		}catch(Exception e){
		  e.printStackTrace();
		}finally{
		  hsession.close();
		}
		response.sendRedirect("ViewVisitsInfo.jsp?id="+patientInfo.getId()+"&msg=Appointment fixed successfully");
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
   <script language="Javascript" src="Scripts/DatePicker.js"></script>
   <script type="text/javascript">
     function setAmount(a){
       var amt = document.getElementById("Amount");
       if("" != a.value)
       	amt.value = document.getElementById("amount"+a.value).value;
       else
    	amt.value = "";
     }
     function setNetAmount(a){
    	var amt = document.getElementById("Amount");
    	var dis = document.getElementById("Discount");
    	if(("" != amt.value)&&("" != dis.value))
    	  a.value = amt.value - dis.value;
    	else if(("" != amt.value)&&("" == dis.value))
    	  a.value = amt.value;
    	else
    	  a.value = "";
     }
     function datePickerClosed(dateField){
  		var dateObj = getFieldDate(dateField.value);
  		var today = new Date();
  		today = new Date(today.getFullYear(), today.getMonth(), today.getDate());
 		if (dateField.name == "VisitDate") {
    	  if (dateObj < today) {
      		// if the date is before today, alert the user and display the datepicker again
      		alert("Please enter a date that is today or later");
      		dateField.value = "";
    	  }
  	    }
     }
     function validateForm(){
       var form1 = document.forms.item(0);
       var nm = document.getElementById("Name");
       var consultant = document.getElementById("Consultant");
       var visitDate = document.getElementById("VisitDate");
       var daySerialNo = document.getElementById("DaySerialNo");
       var operationType = document.getElementById("OperationType");
       var amount = document.getElementById("Amount");
       var discount = document.getElementById("Discount");
       var discountReason = document.getElementById("DiscountReason");
       var netAmount = document.getElementById("NetAmount");
       var paymentType = document.getElementById("PaymentType");
       var valid = document.getElementById("valid");
       if(!isEmpty(nm))
    	if(!isEmpty(consultant))
       	 if(!isEmpty(visitDate))
      	  if(!isEmpty(daySerialNo))       		 
    	   if("New" == operationType.value){	 
	        if(!isEmpty(amount))
    		 if((null == discount.value)||("" == discount.value)){
    		  if(!isEmpty(netAmount)){
    		   if(!isEmpty(paymentType)){
    		     valid.value = true;
    			 form1.submit();
    		   }
    		  }
    		 }else{
    		  if(!isEmpty(discountReason))
    		   if(!isEmpty(netAmount)&& (netAmount.value == amount.value - discount.value)){
    		    if(!isEmpty(paymentType)){	 
    		      valid.value = true;
    			  form1.submit();
    			}
    		   }else{
    			 alert("Please check the net amount once");
    		   }
    		 }
    	   }
    	   else
    		if("Renewal" == operationType.value){
   			  valid.value = true;
   			  form1.submit();
   			}
     }
     $(document).ready(function(){
		//called when the DaySerialNo text field is focused
		$("#DaySerialNo").focus(function (e){
			var Consultant = document.getElementById("Consultant").value;
			var VisitDate = document.getElementById("VisitDate").value;
			if((null != Consultant)&&("" != Consultant)&&(null != VisitDate)&&("" != VisitDate)){
			 $.post("GenerateDaySerialNo.jsp",{cname: ""+Consultant+"",vdate: ""+VisitDate+""},function(data){
				document.getElementById('DaySerialNo').value = data;
			 });
			}
		});
	 }); 
   </script>
  </head>
  <body class="hd">
     <div class="main"><br /><br />
   	 <div align="center" class="header">Enter Appointment Details</div>
     <form name="userdata" action="NewAppointment.jsp">
     <table align="center" class="inputForm" width="860px"> 
 	   <tr>
 	 	<th colspan="4" align="center">
 	 	 <input type="hidden" name="OperationType" id="OperationType" value="<%=operationType%>" />
 	 	 <input type="hidden" name="billId" id="billId" value="<%=billId%>" />
 	 	 <input type="hidden" name="id" id="id" value="<%=patientInfo.getId()%>" />
 	 	</th>
 	   </tr>
  	   <tr>
		<td align="right"><span class='error'>* </span>Name : </td>
		<td align="left"><input type="text" name="Name" id="Name" readonly="readonly" value="<%=patientInfo.getName()%>"/></td>
		<td align="right"><span class='error'>* </span>Consultant Name : </td>
		<td align="left">
		  <%if("Renewal".equals(operationType)){%>
		   <input type="text" readonly="readonly" value="<%=consultant.getName()%>"/>
		   <input name="Consultant" id="Consultant" type="hidden" value="<%=consultant.getId()%>"/>
		  <%}else{%>
		  <select name="Consultant" id="Consultant" onchange="setAmount(this);">
		   <option value="">---SELECT---</option>
			<%
			  Session hsession1 = BeanFactory.getSession();
			  String queryString = "from User where status=1 and role=3 order by name";
			  Query q1 = hsession1.createQuery(queryString);
			  List doctors = q1.list();
			  if(null!=doctors && doctors.size()>0){
				Iterator it = doctors.iterator();
				while(it.hasNext()){
				 User user1 = (User)it.next();
			     %>
				  <option value="<%=user1.getId()%>"><%=user1.getName()%></option>
			   <%}
			  }%>
		  </select>
		  <%Session hsession2 = BeanFactory.getSession();
			String queryString1 = "from User where status=1 and role=3 order by name";
			Query q2 = hsession2.createQuery(queryString);
			List doctors1 = q1.list();
			if(null!=doctors && doctors.size()>0){
			  Iterator it = doctors.iterator();
			  while(it.hasNext()){
				User user2 = (User)it.next();
				DoctorPreferences preferences = user2.getPreferences();
				if(null != preferences){%>
				 <input type="hidden" id="amount<%=preferences.getDoctorId()%>" name="amount<%=preferences.getDoctorId()%>" value="<%=preferences.getoPConsultationFee()%>" />
			  <%}}
		    }}%>
		</td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="NameError" class="error"></div></td>
		<td align="center" colspan="2"><div id="ConsultantNameError" class="error"></div><div id="ConsultantError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span class="error">* </span>Visit Date : </td>
		<td align="left">
	 	 <input type="text" readonly="readonly" name="VisitDate" id="VisitDate" value='<%=new SimpleDateFormat("dd-MM-yyyy").format(new Date())%>' />
		 <img src="Images/CalDis.gif" alt="Select Date" onmouseover="this.src='Images/CalEn.gif';" onmouseout="this.src='Images/CalDis.gif';" onclick="displayDatePicker('VisitDate',this,'dmy','-');"/>
		</td>
		<td align="right"><span class="error">* </span>Day Serial No : </td>
		<td align="left"><input type="text" readonly="readonly" name="DaySerialNo" id="DaySerialNo" /></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="VisitDateError" class="error"></div></td>
		<td align="center" colspan="2"><div id="DaySerialNoError" class="error"></div></td>
	   </tr>
	   <%if("New".equals(operationType)){%>
	   <tr>
		<td align="right"><span class="error">* </span>Amount : </td>
		<td align="left"><input type="text" readonly="readonly" name="Amount" id="Amount" /></td>
		<td align="right">Discount : </td>
		<td align="left"><input type="text" name="Discount" id="Discount" value="<%=(!"0".equals(billId))?"20":""%>" onkeypress="return allowNumeric(event)"/></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="AmountError" class="error"></div></td>
		<td align="center" colspan="2"><div id="DiscountError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right">Discount Reason : </td>
		<td align="left"><input type="text" name="DiscountReason" id="DiscountReason" value="<%=(!"0".equals(billId))?"Renewal":""%>" /></td>
		<td align="right"><span class="error">* </span>Net Amount : </td>
		<td align="left"><input type="text" readonly="readonly" name="NetAmount" id="NetAmount" onfocus="setNetAmount(this)"/></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="DiscountReasonError" class="error"></div></td>
		<td align="center" colspan="2"><div id="NetAmountError" class="error"></div></td>
	   </tr>
	   <%}%>
	   <tr>
		<td align="right">Symptoms : </td>
		<td align="left"><input type="text" name="Symptoms" id="Symptoms"/></td>
		<td align="right">Weight : </td>
		<td align="left"><input type="text" name="Weight" id="Weight"/></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="SymptomsError" class="error"></div></td>
		<td align="center" colspan="2"><div id="WeightError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right">Temparature : </td>
		<td align="left"><input type="text" name="Temparature" id="Temparature"/></td>
		<td align="right">Blood Pressure : </td>
		<td align="left"><input type="text" name="BloodPressure" id="BloodPressure"/></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="TemparatureError" class="error"></div></td>
		<td align="center" colspan="2"><div id="BloodPressureError" class="error"></div></td>
	   </tr>
	   <%if("New".equals(operationType)){%>
	   <tr>
	    <td align="right">Payment Type</td>
	    <td align="left">
	      <select id="PaymentType" name="PaymentType">
	       <option value="">--SELECT--</option>
	       <option value="Cash">CASH</option>
	       <option value="Credit">CREDIT</option>
	      </select>
	    </td>
	    <td align="left" colspan="2"><div id="PaymentTypeError" class="error"></div></td>
	   </tr>
	   <%}%>
	   <tr>
		<td colspan="2" align="center"><input type="button" name="ok" id="ok" value="   SAVE  " onclick="validateForm();" /></td>
		<td colspan="2" align="center"><input type="reset" name="cancel" id="cancel" value="  CLEAR " /></td>
	   </tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false"/>
     </form>
    </div>
  </body>
  <%}}else{%>
     <head>
       <title>..:::Sravani Hospital:::..</title>
   	   <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
   	   <script language="Javascript" src="Scripts/validate.js"></script>
   	 </head>
     <body class="hd">
     <div class="main" align="center">
	  <%out.println("<span class='error'>You cannot access this page</span>");
	    out.println("<br><a href=javascript:window.close();>Close this window</a>");
	  %>
	  </div>
	 </body><%
	 }
  }else{
	 response.sendRedirect("validate");
  }%>
</html>
