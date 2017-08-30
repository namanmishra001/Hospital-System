<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Query"%>
<%@page import="java.util.*"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<%@page import="info.inetsolv.tools.DateUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
try{
 HttpSession session = request.getSession(false);
 if(null != session){
  String id = request.getParameter("id");
  String msg = request.getParameter("msg");
  if((null!=id)&&(!"".equals(id))){
   Session hsession = BeanFactory.getSession();
   LabBill bill = (LabBill)hsession.get(LabBill.class,Long.parseLong(id));
   if(null!=bill){
    PatientInfo patient = bill.getPatientInfo();
   %>
    <head>
	 <base href="<%=session.getAttribute("basePath")%>"/>
	 <meta http-equiv="pragma" content="no-cache" />
	 <meta http-equiv="cache-control" content="no-cache" />
	 <meta http-equiv="expires" content="0" />    
	 <link type="text/css" href="CSS/styles.css" rel="stylesheet" media="screen" />
	 <link type="text/css" href="CSS/menu.css" rel="stylesheet" media="screen" />
	 <style type="text/css" media="print">
      .print_hide{
       display: none;
      }
     </style>
     <style type="text/css" media="screen">
      .screen_hide{
       display: none;
       text-align: left;
      }
     </style>
   </head>
   <body class="hd" onload="settime()">
   <div class="print_hide">
	<div class="main">
	  <jsp:include page="Head.jsp" />
	</div>
	<jsp:include page="Menu.jsp" />
   </div>
    <div class="main" style="min-height: 550px;">
  	<div align="center" class="header">Lab Bill</div>
     <table align="center" class="inputForm" width="800px;">
      <tr class="print_hide">
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
	   <td align="left"><%=ObjectUtil.formatValue(patient.getName())%></td>
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
	   <td align="left"><%=ObjectUtil.formatValue(bill.getConsultant().getName())%></td>
  	  </tr>
  	  <tr><td colspan="4" height="40px;"></td></tr>
  	  <tr>
  	   <td colspan="4">
  	   <%
  	    List<Long> tests = ObjectUtil.csvToList(bill.getLabTestReport().gettests(),",");
	    if(null != tests && tests.size()>0)
		{%>
		 <table align="center" width="700Px;">	
		  <tr class="screen_hide"><td colspan="3"><hr /></td></tr>			
		  <tr class="tr_header" align="center">
			<td width="100px;">S.No.</td>
			<td>Test Name</td>
			<td width="150px;">Cost</td>
		  </tr>
		  <tr class="screen_hide"><td colspan="3"><hr /></td></tr>
		  <%
			Iterator<Long> it = tests.iterator();
		    int count = 0;
			while(it.hasNext()){
			  LabTest test = (LabTest)hsession.get(LabTest.class,it.next());
			 %>		
			 <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>" align="center">
				<td><%=++count%></td>
				<td><%=test.getName()%></td>
				<td><%=ObjectUtil.formatValue(test.getCost())%></td>
			 </tr>
			 <%}%>
		   <tr class="screen_hide"><td colspan="3"><hr /></td></tr>
		 </table>
	    <%}%>	
  	   </td>
  	  </tr>
  	  <tr>
		<td colspan="2"></td>
  	    <td align="right">Total Cost : </td>
  	    <td align="left"><%=ObjectUtil.formatValue(bill.getLabTestReport().getTotalCost())%></td>
  	  </tr>
  	  <tr>
		<td colspan="2"><div id="AmountError" class="error"></div></td>
  	    <td colspan="2"><div id="DiscountError" class="error"></div></td>
  	  </tr>
  	  <tr>
		<td colspan="2"></td>
  	    <td align="right">Discount : </td>
  	    <td align="left"><%=ObjectUtil.formatValue(bill.getDiscount())%></td>
  	  </tr>
  	  <tr>
		<td colspan="2"><div id="AmountError" class="error"></div></td>
  	    <td colspan="2"><div id="DiscountError" class="error"></div></td>
  	  </tr>
  	  <tr>
  	    <td align="right">Discount Reason:</td>
  	    <td align="left"><%=ObjectUtil.formatValue(bill.getDiscountreason())%></td>
  	    <td align="right">Net Amount :</td>
  	    <td align="left"><%=ObjectUtil.formatValue(bill.getNetAmount())%></td>
  	  </tr>
  	  <tr>
		<td colspan="2"><div id="DiscountReasonError" class="error"></div></td>
  	    <td colspan="2"><div id="NetAmountError" class="error"></div></td>
  	  </tr>
  	  <tr class="print_hide">
  	    <td colspan="2" align="center"><input type="button" name="ok" id="ok" value="  Print  " onclick="window.print();" /></td>
  	    <td align="right">Payment Type :</td>
  	    <td align="left"><%=bill.getPaymenttype()%></td>
  	  </tr>
  	  <tr><td colspan="4" height="40px;"></td></tr>
  	  <tr>
  	   <td align="right" colspan="3" style="padding-top:120px;vertical-align: bottom;" class="tr_opBill_dis">Signature</td>
  	   <td></td>
  	  </tr>
     </table>
   </div>
   <div id="div4" style="padding-top: 20px">
     <table width="100%">
      <tr align="left">
    	<td>
    	 <table class="screen_hide">
    	   <tr class="tr_opBill_extra"><td>Print User :</td><td align="left"><%=((User)session.getAttribute("user")).getName()%></td><td><%=DateUtil.formatDate("dd-MM-yyyy HH:mm:ss",Calendar.getInstance().getTimeInMillis())%></td></tr>
    	 </table>
        </td>
      </tr>
    </table>
   </div>
   </body>
   <%}}
   }else{
	 response.sendRedirect("validate");
  }
 }catch(Exception e){
 }finally{
	HttpSession session = request.getSession(false);
	if(null!=session)
	   session.removeAttribute("tests");
 }%>
</html>