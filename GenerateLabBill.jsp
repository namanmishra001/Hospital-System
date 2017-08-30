<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Query"%>
<%@page import="java.util.*"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%try{
 HttpSession session = request.getSession(false);
 if(null != session){
  String id = request.getParameter("id");
  String msg = request.getParameter("msg");
  if((null!=id)&&(!"".equals(id))){
   Session hsession = BeanFactory.getSession();
   LabTestReport report = (LabTestReport)hsession.get(LabTestReport.class,Long.parseLong(id));
   if(null!=report){
	LabBill bill = (report.getLabBills().size()!=0)?report.getLabBills().iterator().next():null;
	if(null==bill){
	PatientInfo patient = report.getPatientInfo();
    Boolean isValid = new Boolean(request.getParameter("valid"));
    if(isValid){
     String amount = request.getParameter("Amount");
     String discount = request.getParameter("Discount");
     String discountReason = request.getParameter("DiscountReason");
     String netAmount = request.getParameter("NetAmount");
     String paymentType = request.getParameter("PaymentType");
	 Transaction tx = hsession.beginTransaction();
	 bill = new LabBill();
	 bill.setConsultant(report.getConsultant());
	 bill.setPatientInfo(report.getPatientInfo());
	 bill.setLabTestReport(report);
	 bill.setBilldate(Calendar.getInstance().getTimeInMillis());
	 User user1 = (User)session.getAttribute("user");
	 if(null != user1)
	  bill.setUser(user1);
	 if((null!=amount)&&!("".equals(amount)))
	  bill.setAmount(Long.parseLong(amount));
	 if((null!=discount)&&!("".equals(discount)))
	  bill.setDiscount(Long.parseLong(discount));
	 if((null!=discountReason)&&!("".equals(discountReason)))
	  bill.setDiscountreason(discountReason);
	 if((null!=netAmount)&&!("".equals(netAmount)))
	  bill.setNetAmount(Long.parseLong(netAmount));
	 if((null!=paymentType)&&!("".equals(paymentType))){
	  bill.setPaymenttype(paymentType);
	 if("Credit".equals(paymentType))
	  bill.setPaymentstatus(false);
	 else
	  bill.setPaymentstatus(true);
	 }
	 hsession.persist(bill);
	 try{
		tx.commit();
	 }catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect("generateLabBill?id="+report.getId()+"&valid=false&msg=Lab Bill Saving Failed"+e.getMessage());
	 }finally {
		hsession.close();
	 }
	response.sendRedirect("printLabBill?id="+bill.getId()+"&msg=Lab Bill Saved Successfully");
  }else{
  %>
   <head>
        <base href="<%=session.getAttribute("basePath")%>"/>
        <meta http-equiv="pragma" content="no-cache" />
        <meta http-equiv="cache-control" content="no-cache" />
        <meta http-equiv="expires" content="0" />    
        <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
        <link type="text/css" href="CSS/menu.css" rel="stylesheet" />
        <script language="Javascript" src="Scripts/validate.js"></script>
        <script type="text/javascript">
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
	  function validateForm(){
		var form1 = document.forms.item(0);  
		var amount = document.getElementById('Amount');
		var discount = document.getElementById('Discount');
		var discountReason = document.getElementById('DiscountReason');
		var netAmount = document.getElementById("NetAmount");
                var paymentType = document.getElementById("PaymentType");
                var valid = document.getElementById("valid");
		if(!isEmpty(amount))
                 if((null == discount.value)||("" == discount.value)){
                    if(!isEmpty(netAmount)&&(netAmount.value == amount.value - discount.value)){
                     if(!isEmpty(paymentType)){
                          valid.value = true;
                          form1.submit();
                     }    
                    }else{
                        alert("Please check the net amount once");  
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
	 </script>
   </head>
   <body class="hd" onload="settime()" onunload="clearForm()">
	<div class="main">
	  <jsp:include page="Head.jsp" />
	</div>
	<jsp:include page="Menu.jsp" />
    <div class="main" style="min-height: 550px;">
  	<div align="center" class="header">Lab Bill</div>
  	<form method="post" action="generateLabBill">
     <table align="center" class="inputForm" width="800px;">
      <tr>
	   <td align="center" colspan="4">
	   <%
 	    if (null != msg){
 	 	 out.println("<span class='msg'>" + msg + "</span>");
 	    }
 	   %>
	   </td>
  	  </tr>
	  <tr>
	   <td align="right">Patient Name: </td>
	   <td align="left"><%=ObjectUtil.formatValue(report.getPatientInfo().getName())%></td>
	   <td align="right">Age : <%=ObjectUtil.formatValue(patient.getAge())%> </td>
	   <td align="left">Gender : <%=ObjectUtil.formatValue(patient.getGender())%></td>
  	  </tr>
	  <tr>
	   <td align="right">
	    <%
    	   if(null != patient.getRelationType()){
    		if("Parent".equals(patient.getRelationType()))
    		  out.println(("Male".equals(patient.getGender()))?"S/O.":"D/O.");
    		else
    		if("Spouse".equals(patient.getRelationType()))	
   			  out.println(("Male".equals(patient.getGender()))?"H/O.":"W/O.");
    		else
    		if("Other".equals(patient.getRelationType()))
    		  out.println("C/O.");		
    	   }
    	%>
	   </td>
	   <td align="left"><%=ObjectUtil.formatValue(patient.getRelativeName())%></td>
	   <td align="right">Consultant Name : </td>
	   <td align="left"><%=ObjectUtil.formatValue(report.getConsultant().getName())%></td>
  	  </tr>
  	  <tr>
  	   <td colspan="4">
  	   <%
  	    List<Long> tests = ObjectUtil.csvToList(report.gettests(),",");
	    if(null != tests && tests.size()>0)
		{%>
		 <table align="center" width="750Px;">				
		  <tr class="tr_header">
			<td width="100px;">S.No.</td>
			<td>Test Name</td>
			<td width="150px;">Cost</td>
		  </tr>
		  <%
			Iterator<Long> it = tests.iterator();
		    int count = 0;
			while(it.hasNext()){
			  LabTest test = (LabTest)hsession.get(LabTest.class,it.next());
			 %>		
			 <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>">
				<td align="center"><%=++count%></td>
				<td><%=test.getName()%></td>
				<td align="center"><%=ObjectUtil.formatValue(test.getCost())%></td>
			 </tr>
			 <%}%>
			 <tr>
			  <td colspan="2" align="right">Total Cost</td>
			  <td align="center"><%=ObjectUtil.formatValue(report.getTotalCost())%></td>
			 </tr>
		 </table>
	    <%}%>	
  	   </td>
  	  </tr>
  	  <tr>
		<td colspan="2"><input type="hidden" id="Amount" name="Amount" value="<%=ObjectUtil.formatValue(report.getTotalCost())%>" /></td>
  	    <td><span class="error">&nbsp;&nbsp;</span>Discount : </td>
  	    <td><input type="text" id="Discount" name="Discount" style="text-align: right;" onkeypress="return allowNumeric(event)"/></td>
  	  </tr>
  	  <tr>
		<td colspan="2"><div id="AmountError" class="error"></div></td>
  	    <td colspan="2"><div id="DiscountError" class="error"></div></td>
  	  </tr>
  	  <tr>
  	    <td>Discount Reason:</td>
  	    <td><input type="text" id="DiscountReason" name="DiscountReason" /></td>
  	    <td><span class="error">* </span>Net Amount :</td>
  	    <td><input type="text" id="NetAmount" name="NetAmount" readonly="readonly" onfocus="getNetAmount(this)" style="text-align: right;" /></td>
  	  </tr>
  	  <tr>
	    <td colspan="2"><div id="DiscountReasonError" class="error"></div></td>
  	    <td colspan="2"><div id="NetAmountError" class="error"></div></td>
  	  </tr>
  	  <tr>
  	    <td colspan="2"></td>
  	    <td><span class="error">* </span>Payment Type :</td>
  	    <td>
  	      <select id="PaymentType" name="PaymentType">
	       <option value="">--SELECT--</option>
	       <option value="Cash">CASH</option>
	       <option value="Credit">CREDIT</option>
	      </select>
	    </td>
  	  </tr>
  	  <tr>
		<td colspan="2"></td>
  	    <td colspan="2"><div id="PaymentTypeError" class="error"></div></td>
  	  </tr>
	  <tr align = "center">
	   <td colspan="2">
	    <input type="button" name="ok" id="ok" value="  SAVE  " onclick="validateForm()" />
	   </td>
	   <td colspan="2">
	    <input type="reset" name="cancel" id="cancel" value="  CLEAR  " />
	   </td>
	  </tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false" />
     <input type="hidden" id="id" name="id" value="<%=report.getId()%>" />
    </form>
   </div>
   </body>
   <%}}else{
	   response.sendRedirect("printLabBill?id="+bill.getId()+"&msg=Lab Bill already saved");
   }}else{
	   response.sendRedirect("investigationSearchPatient");
   }}else{
	   response.sendRedirect("investigationSearchPatient");
	   }
   }else{
	 response.sendRedirect("validate");
  }}catch(Exception e){}
   finally{
	   HttpSession session = request.getSession(false);
	   if(null!=session)
		   session.removeAttribute("tests");
   }%>
</html>
