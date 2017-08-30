<%@ page language="java" session="false" import="org.hibernate.*,java.util.*,info.inetsolv.bean.*,info.inetsolv.tools.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.io.Serializable"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	Boolean isValid = new Boolean(request.getParameter("valid"));
	String msg = request.getParameter("msg");
	if(isValid){
		String name = request.getParameter("Name");
		String gender = request.getParameter("Gender");
		String age = request.getParameter("Age");
		String city = request.getParameter("City");
		String address = request.getParameter("Address");
		String contactNo1 = request.getParameter("ContactNo1");
		String contactNo2 = request.getParameter("ContactNo2");
		String relationType = request.getParameter("RelationType");
		String relativeName = request.getParameter("RelativeName");
		String registrationType = request.getParameter("RegistrationType");
		String consultant = request.getParameter("Consultant");
		String consultantName = request.getParameter("ConsultantName");
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
		String params = "";
		Long lvisitDate = null;
		OpBill bill = null;
		OpVisit visit = null;
		User user = null;
		Session hsession = BeanFactory.getSession();
		Transaction tx = hsession.beginTransaction();
		PatientInfo patient = new PatientInfo();
		patient.setRegddate(Calendar.getInstance().getTimeInMillis());
		patient.setName(name);
		patient.setGender(gender);
		patient.setAge(Long.parseLong(age));
		if((null != city)&&!("".equals(city)))
		  patient.setCity(city.trim());
		if((null != address)&&!("".equals(address)))
		  patient.setAddress(address.trim());
		if((null != contactNo1)&&!("".equals(contactNo1)))
		  patient.setContactno1(Long.parseLong(contactNo1));
		if((null != contactNo2)&&!("".equals(contactNo2)))
		  patient.setContactno2(Long.parseLong(contactNo2));
		if(null != relationType)
		  patient.setRelationType(relationType);
		if(null != relativeName)
		  patient.setRelativeName(relativeName);	
		if(null != registrationType){
		  patient.setRegType(registrationType);
		  if("LAB".equals(registrationType)){
			User doctor = new User();
			doctor.setName(consultantName);
			UserRole role = (UserRole)hsession.get(UserRole.class,3l);
			doctor.setUserRole(role);
			patient.setConsultant(doctor);
			hsession.save(doctor);
			hsession.save(patient);
		  }else if("OP".equals(registrationType)){
			bill = new OpBill();
			bill.setBillDate(Calendar.getInstance().getTimeInMillis());
			if((null!=visitDate)&&!("".equals(visitDate))){
			  lvisitDate = DateUtil.stringToLong(visitDate);
			  bill.setInitialvisitdate(lvisitDate);
			}
			bill.setPatientInfo(patient);
			if((null!=consultant)&&!("".equals(consultant))){
			  user = (User)hsession.get(User.class,Long.parseLong(consultant));
			  bill.setConsultant(user);
			  DoctorPreferences preferences = user.getPreferences();
			  bill.setValidtilldate(lvisitDate+preferences.getConsultationPeriod()-(24*60*60*1000));
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
			User user1 = (User)session.getAttribute("user");
			if(null != user1)
			  bill.setUser(user1);
			patient.setTotalVisits(1l);
			visit = new OpVisit();
			visit.setConsultant(user);
			visit.setOpBill(bill);
			visit.setBloodpressure(bloodPressure);
			visit.setSymptoms(symptoms);
			visit.setTemperature(temparature);
			visit.setWeight(weight);
			visit.setVisitdate(lvisitDate);
			if((null != daySerialNo) &&!("".equals(daySerialNo)))
			  visit.setDayserial(Long.parseLong(daySerialNo));
			patient.setConsultant(user);
			hsession.persist(patient);
			hsession.persist(bill);
			hsession.persist(visit);
			params = "&billId="+bill.getId()+"&visitId="+visit.getId();
			Criteria cr = hsession.createCriteria(City.class);
			cr.add(Restrictions.eq("name",city));
			List cities = cr.list();
			if((null!=cities)&&(cities.size()==0)){
				City newCity = new City();
				newCity.setName(city.trim());
				hsession.persist(newCity);
			}
		  }
		}
		try{
		  tx.commit();
		}catch(Exception e){
		  e.printStackTrace();
		}finally{
		  hsession.close();
		}
		response.sendRedirect("registerPatient?valid=false&regType="+registrationType+"&msg=Patient Registered Successfully"+params);
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
    function showDetails(){
	  var rt = document.getElementById("RegistrationType");
	  var cn1 = document.getElementById("cn1");
	  var cn2 = document.getElementById("cn2");
	  var cn3 = document.getElementById("cn3");
	  var s1 = document.getElementById("s1");
	  var s2 = document.getElementById("s2");
	  var w1 = document.getElementById("w1");
	  var w2 = document.getElementById("w2");
	  var t1 = document.getElementById("t1");
	  var t2 = document.getElementById("t2");
	  var b1 = document.getElementById("b1");
	  var b2 = document.getElementById("b2");
	  var v1 = document.getElementById("v1");
	  var v2 = document.getElementById("v2");
	  var d1 = document.getElementById("d1");
	  var d2 = document.getElementById("d2");
	  var a1 = document.getElementById("a1");
	  var a2 = document.getElementById("a2");
	  var di1 = document.getElementById("di1");
	  var di2 = document.getElementById("di2");
	  var dr1 = document.getElementById("dr1");
	  var dr2 = document.getElementById("dr2");
	  var na1 = document.getElementById("na1");
	  var na2 = document.getElementById("na2");
	  var pt1 = document.getElementById("pt1");
	  var pt2 = document.getElementById("pt2");
	  if(rt.value=="OP"){
		 cn1.style.display="block";
		 cn2.style.display="block";
		 cn3.style.display="none";
		 s1.style.display="block";
		 s2.style.display="block";
		 w1.style.display="block";
		 w2.style.display="block";
		 t1.style.display="block";
		 t2.style.display="block";
		 b1.style.display="block";
		 b2.style.display="block";
		 v1.style.display="block";
		 v2.style.display="block";
		 d1.style.display="block";
		 d2.style.display="block";
		 a1.style.display="block";
		 a2.style.display="block";
		 di1.style.display="block";
		 di2.style.display="block";
		 dr1.style.display="block";
		 dr2.style.display="block";
		 na1.style.display="block";
		 na2.style.display="block";
		 pt1.style.display="block";
		 pt2.style.display="block";
	  }else if(rt.value=="LAB"){
		 cn1.style.display="block";
		 cn2.style.display="none";
		 cn3.style.display="block";
		 s1.style.display="none";
		 s2.style.display="none";
		 w1.style.display="none";
		 w2.style.display="none";
		 t1.style.display="none";
		 t2.style.display="none";
		 b1.style.display="none";
		 b2.style.display="none";
		 v1.style.display="none";
		 v2.style.display="none";
		 d1.style.display="none";
		 d2.style.display="none";
		 a1.style.display="none";
		 a2.style.display="none";
		 di1.style.display="none";
		 di2.style.display="none";
		 dr1.style.display="none";
		 dr2.style.display="none";
		 na1.style.display="none";
		 na2.style.display="none";
		 pt1.style.display="none";
		 pt2.style.display="none";
	   }else{
		 cn1.style.display="none";
		 cn2.style.display="none";
		 cn3.style.display="none";
		 s1.style.display="none";
		 s2.style.display="none";
		 w1.style.display="none";
		 w2.style.display="none";
		 t1.style.display="none";
		 t2.style.display="none";
		 b1.style.display="none";
		 b2.style.display="none";
		 v1.style.display="none";
		 v2.style.display="none";
		 d1.style.display="none";
		 d2.style.display="none";
		 a1.style.display="none";
		 a2.style.display="none";
		 di1.style.display="none";
		 di2.style.display="none";
		 dr1.style.display="none";
		 dr2.style.display="none";
		 na1.style.display="none";
		 na2.style.display="none";
		 pt1.style.display="none";
		 pt2.style.display="none";
	   }
     }
     function clearForm(){
       var form1 = document.forms.item(0);
	   var cn1 = document.getElementById("cn1");
	   var cn2 = document.getElementById("cn2");
	   var cn3 = document.getElementById("cn3");
	   var s1 = document.getElementById("s1");
	   var s2 = document.getElementById("s2");
	   var w1 = document.getElementById("w1");
	   var w2 = document.getElementById("w2");
	   var t1 = document.getElementById("t1");
	   var t2 = document.getElementById("t2");
	   var b1 = document.getElementById("b1");
	   var b2 = document.getElementById("b2");
	   var v1 = document.getElementById("v1");
	   var v2 = document.getElementById("v2");
	   var d1 = document.getElementById("d1");
	   var d2 = document.getElementById("d2");
	   var a1 = document.getElementById("a1");
	   var a2 = document.getElementById("a2");
	   var di1 = document.getElementById("di1");
	   var di2 = document.getElementById("di2");
	   var dr1 = document.getElementById("dr1");
	   var dr2 = document.getElementById("dr2");
	   var na1 = document.getElementById("na1");
	   var na2 = document.getElementById("na2");
	   var pt1 = document.getElementById("pt1");
	   var pt2 = document.getElementById("pt2");
	   cn1.style.display="none";
	   cn2.style.display="none";
	   cn3.style.display="none";
	   s1.style.display="none";
	   s2.style.display="none";
	   w1.style.display="none";
	   w2.style.display="none";
	   t1.style.display="none";
	   t2.style.display="none";
	   b1.style.display="none";
	   b2.style.display="none";
	   v1.style.display="none";
	   v2.style.display="none";
	   d1.style.display="none";
	   d2.style.display="none";
	   a1.style.display="none";
	   a2.style.display="none";
	   di1.style.display="none";
	   di2.style.display="none";
	   dr1.style.display="none";
	   dr2.style.display="none";
	   na1.style.display="none";
	   na2.style.display="none";
	   pt1.style.display="none";
	   pt2.style.display="none";
       form1.reset();
     }
     function setAmount(a){
       var amt = document.getElementById("Amount");
       if("" != a.value)
       	amt.value = document.getElementById("amount"+a.value).value;
       else
    	amt.value = "";
     }
     function getNetAmount(a){
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
       var gender = document.getElementById("Gender");
       var age = document.getElementById("Age");
       var city = document.getElementById("City");
       var relativeName = document.getElementById("RelativeName");
       var relationType = document.getElementById("RelationType");
       var registrationType = document.getElementById("RegistrationType");
       var consultant = document.getElementById("Consultant");
       var consultantName = document.getElementById("ConsultantName");
       var visitDate = document.getElementById("VisitDate");
       var daySerialNo = document.getElementById("DaySerialNo");
       var discount = document.getElementById("Discount");
       var discountReason = document.getElementById("DiscountReason");
       var amount = document.getElementById("Amount");
       var netAmount = document.getElementById("NetAmount");
       var paymentType = document.getElementById("PaymentType");
       var valid = document.getElementById("valid");
       if(!isEmpty(nm))
    	if(!isEmpty(gender))
    	 if(!isEmpty(age))
    	  if(!isEmpty(city))
    	   if(!isEmpty(relationType))
    		if(!isEmpty(relativeName))
    		 if(!isEmpty(registrationType))
    		  if("OP" == registrationType.value){	 
    		   if(!isEmpty(consultant))
    		    if(!isEmpty(visitDate))
    		     if(!isEmpty(daySerialNo))
    		      if(!isEmpty(amount))
    		       if((null == discount.value)||("" == discount.value)){
    		    	if(!isEmpty(netAmount)&& (netAmount.value == amount.value - discount.value)){
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
    		  }else if("LAB" == registrationType.value){
    			  if(!isEmpty(consultantName)){
    				  valid.value = true;
    				  form1.submit();
    			  }
    		  }
     }
     $(document).ready(function(){
		//called when key is pressed in textbox
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
   <script type="text/javascript">
	function lookup1(inputString) {
	if(inputString.length == 0){
		$('#suggestions').hide();
	 }else{
		$.post("CitySuggest.jsp", {searchString: ""+inputString+""}, function(data){
			if(data.length >0) {
				$('#suggestions').show();
				$('#autoSuggestionsList').html(data);
			}
		});
	 }
	}
	function fill1(thisValue) {
	  $('#City').val(thisValue);
	  setTimeout("$('#suggestions').hide();", 100);
	}
	</script>
	<style type="text/css">
	.suggestionsBox {
		position: relative;
		margin: 0px 0px 0px 0px;
		width: 150px;
		background-color: #C58361;
		-moz-border-radius: 7px;
		-webkit-border-radius: 7px;
		border: 2px solid #000;
		color: #fff;
	}
	.suggestionList {
		margin: 0px;
		padding: 0px;
	}
	.suggestionList li {
		margin: 0px 0px 0px 0px;
		padding: 3px;
		cursor: pointer;
		list-style: none;
	}
	.suggestionList li:hover {
		background-color: #DD45CD;
		-moz-border-radius: 7px;
		-webkit-border-radius: 7px;
	}
	</style>
   
  </head>
  <body class="hd" onload="settime()">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main">
   	 <div align="center" class="header">Enter Patient Data</div>
     <form name="userdata" action="registerPatient" method="get">
     <table align="center" class="inputForm" width="860px"> 
 	   <tr>
 	 	<th colspan="4" align="center">
 	 	 <%
 	 	  if(null != msg){
			out.println("<span class='msg'>"+msg+"</span>");
			String regType = request.getParameter("regType");
			String billId = request.getParameter("billId");
			String visitId = request.getParameter("visitId");
			if((null!=regType)&&("OP".equals(regType))){
			 if((null==billId)||(null==visitId)){
			  Session hsession = BeanFactory.getSession();
			  Query query1 = hsession.createQuery("select max(id) from OpBill");
			  Query query2 = hsession.createQuery("select max(id) from OpVisit");
			  List bills = query1.list();
			  List visits = query2.list();
			  out.println("<a href=javascript:fnPopUp('PrintOPBill.jsp?billId="+bills.get(0)+"&visitId="+visits.get(0)+"',450,550);>Print Bill</a>");
			 }else{
			  out.println("<a href=javascript:fnPopUp('PrintOPBill.jsp?billId="+billId+"&visitId="+visitId+"',450,550);>Print Bill</a>"); 
			 }
			}
 	 	  }
 	 	 %>	
 	 	</th>
 	   </tr>
  	   <tr>
		<td align="right"><span class='error'>* </span>Name : </td>
		<td align="left"><input type="text" name="Name" id="Name"/></td>
		<td colspan="2"> </td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="NameError" class="error"></div></td>
		<td align="center" colspan="2"></td>
	   </tr>
	   <tr>
		<td align="right"><span class='error'>* </span>Gender :</td>
		<td align="left">
		 <select name="Gender" id="Gender">
		   <option value="">--Select--</option>
		   <option value="Male">Male</option>
		   <option value="Female">Female</option>
		 </select>
		</td>
		<td align="right"><span class='error'>* </span>Age : </td>
		<td align="left"><input type="text" name="Age" id="Age" onkeypress="return allowNumeric(event)"/></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="GenderError" class="error"></div></td>
		<td align="center" colspan="2"><div id="AgeError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right" valign="top"><span class='error'>* </span>City : </td>
		<td align="left" valign="top">
		  <input type="text" name="City" id="City" onkeyup="lookup1(this.value)" autocomplete="off" />
		  <div class="suggestionsBox" id="suggestions" style="display: none;">
		   <div class="suggestionList" id="autoSuggestionsList">
		   </div>
		  </div>
		</td>
		<td align="right">Address : </td>
		<td align="left"><textarea name="Address" id="Address" rows="3" cols="16"></textarea></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="CityError" class="error"></div></td>
		<td align="center" colspan="2"><div id="AddressError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right">Contact No1 : </td>
		<td align="left"><input type="text" name="ContactNo1" id="ContactNo1" onkeypress="return allowNumeric(event)"/></td>
		<td align="right">Contact No2 : </td>
		<td align="left"><input type="text" name="ContactNo2" id="ContactNo2" onkeypress="return allowNumeric(event)"/></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="ContactNo1Error" class="error"></div></td>
		<td align="center" colspan="2"><div id="ContactNo2Error" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span class='error'>* </span>Relation Type :</td>
		<td align="left">
		  <select name="RelationType" id="RelationType">
		    <option value="">--Select--</option>
		    <option value="Parent">Parent</option>
		    <option value="Spouse">Spouse</option>
		    <option value="Other">Other</option>
		  </select>
		</td>
		<td align="right"><span class='error'>* </span>Relative Name : </td>
		<td align="left"><input type="text" name="RelativeName" id="RelativeName"/></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="RelationTypeError" class="error"></div></td>
		<td align="center" colspan="2"><div id="RelativeNameError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span class='error'>* </span>Registration Type : </td>
		<td align="left">
		 <select name="RegistrationType" id="RegistrationType" onchange="showDetails();">
		  <option value="">--Select--</option>
		  <option value="OP">Out-Patient</option>
		  <option value="LAB">Lab</option>
		 </select>
		</td>
		<td align="right"><span id="cn1" style="display: none"><span class='error'>* </span>Consultant Name : </span></td>
		<td align="left">
		 <span id="cn2" style="display: none">
		  <select name="Consultant" id="Consultant" onchange="setAmount(this);">
		   <option value="">---SELECT---</option>
			<%
			  Session hsession = BeanFactory.getSession();
			  String queryString = "from User where status=1 and role=3 order by name";
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
		  <%Session hsession1 = BeanFactory.getSession();
			String queryString1 = "from User where status=1 and role=3 order by name";
			Query q2 = hsession.createQuery(queryString);
			List doctors1 = q1.list();
			if(null!=doctors && doctors.size()>0){
			  Iterator it = doctors.iterator();
			  while(it.hasNext()){
				User user = (User)it.next();
				DoctorPreferences preferences = user.getPreferences();
				if(null != preferences){%>
				 <input type="hidden" id="amount<%=preferences.getDoctorId()%>" name="amount<%=preferences.getDoctorId()%>" value="<%=preferences.getoPConsultationFee()%>" />
			  <%}}
		    }%>
		 </span>
		 <span id="cn3" style="display: none">
		 	<input type="text" name="ConsultantName" id="ConsultantName"  />
		 </span>
		</td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="RegistrationTypeError" class="error"></div></td>
		<td align="center" colspan="2"><div id="ConsultantNameError" class="error"></div><div id="ConsultantError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span id="v1" style="display: none"><span class="error">* </span>Visit Date : </span></td>
		<td align="left">
		 <span id="v2" style="display: none">
		 	<input type="text" readonly="readonly" name="VisitDate" id="VisitDate" value='<%=new SimpleDateFormat("dd-MM-yyyy").format(new Date())%>' />
		 	<img src="Images/CalDis.gif" alt="Select Date" onmouseover="this.src='Images/CalEn.gif';" onmouseout="this.src='Images/CalDis.gif';" onclick="displayDatePicker('VisitDate',this,'dmy','-');"/>
		 </span>
		</td>
		<td align="right"><span id="d1" style="display: none"><span class="error">* </span>Day Serial No : </span></td>
		<td align="left"><span id="d2" style="display: none"><input type="text" readonly="readonly" name="DaySerialNo" id="DaySerialNo" /></span></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="VisitDateError" class="error"></div></td>
		<td align="center" colspan="2"><div id="DaySerialNoError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span id="a1" style="display: none"><span class="error">* </span>Amount : </span></td>
		<td align="left"><span id="a2" style="display: none"><input type="text" readonly="readonly" name="Amount" id="Amount" /></span></td>
		<td align="right"><span id="di1" style="display: none">Discount : </span></td>
		<td align="left"><span id="di2" style="display: none"><input type="text" name="Discount" id="Discount" onkeypress="return allowNumeric(event)"/></span></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="AmountError" class="error"></div></td>
		<td align="center" colspan="2"><div id="DiscountError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span id="dr1" style="display: none">Discount Reason : </span></td>
		<td align="left"><span id="dr2" style="display: none"><input type="text" name="DiscountReason" id="DiscountReason" /></span></td>
		<td align="right"><span id="na1" style="display: none"><span class="error">* </span>Net Amount : </span></td>
		<td align="left"><span id="na2" style="display: none"><input type="text" readonly="readonly" name="NetAmount" id="NetAmount" onfocus="getNetAmount(this)"/></span></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="DiscountReasonError" class="error"></div></td>
		<td align="center" colspan="2"><div id="NetAmountError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span id="s1" style="display: none">Symptoms : </span></td>
		<td align="left"><span id="s2" style="display: none"><input type="text" name="Symptoms" id="Symptoms"/></span></td>
		<td align="right"><span id="w1" style="display: none">Weight : </span></td>
		<td align="left"><span id="w2" style="display: none"><input type="text" name="Weight" id="Weight"/></span></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="SymptomsError" class="error"></div></td>
		<td align="center" colspan="2"><div id="WeightError" class="error"></div></td>
	   </tr>
	   <tr>
		<td align="right"><span id="t1" style="display: none">Temparature : </span></td>
		<td align="left"><span id="t2" style="display: none"><input type="text" name="Temparature" id="Temparature"/></span></td>
		<td align="right"><span id="b1" style="display: none">Blood Pressure : </span></td>
		<td align="left"><span id="b2" style="display: none"><input type="text" name="BloodPressure" id="BloodPressure"/></span></td>
	   </tr>
	   <tr>
		<td align="center" colspan="2"><div id="TemparatureError" class="error"></div></td>
		<td align="center" colspan="2"><div id="BloodPressureError" class="error"></div></td>
	   </tr>
	   <tr>
	    <td align="right"><span id="pt1" style="display: none"><span class="error">* </span>Payment Type</span></td>
	    <td align="left">
	     <span id="pt2" style="display: none">
	      <select id="PaymentType" name="PaymentType">
	       <option value="">--SELECT--</option>
	       <option value="Cash">CASH</option>
	       <option value="Credit">CREDIT</option>
	      </select>
	     </span>
	    </td>
	    <td align="left" colspan="2"><div id="PaymentTypeError" class="error"></div></td>
	   </tr>
	   <tr>
		<td colspan="2" align="center"><input type="button" name="ok" id="ok" value="   REGISTER  " onclick="validateForm();" /></td>
		<td colspan="2" align="center"><input type="button" name="cancel" id="cancel" value="  CLEAR " onclick="clearForm();"/></td>
	   </tr>
	   <tr>
		<td colspan="4"></td>
	   </tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false"/>
     </form>
    </div>
  </body>
   <%}}else{
	 response.sendRedirect("validate");
  }%>
</html>
