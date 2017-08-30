<%@page language="java" session="false" import="info.inetsolv.bean.*,info.inetsolv.tools.*,org.hibernate.*,java.util.*" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	String billId = request.getParameter("billId");
	String visitId = request.getParameter("visitId");
	Session hsession = BeanFactory.getSession();
	OpBill bill = (OpBill)hsession.load(OpBill.class,Long.parseLong(billId));
	PatientInfo patient = bill.getPatientInfo();
	OpVisit visit = (OpVisit)hsession.load(OpVisit.class,Long.parseLong(visitId));
  %>
  <head>
    <link rel="stylesheet" href="CSS/styles.css"/>
    <style type="text/css" media="print">
    .print_hide{
     display: none;
    }
    .print_textbox{
     border: 0px;
     font-size: 10px;
	 font-weight: normal;
    }
    </style>
    <style type="text/css" media="screen">
    .screen_hide{
     display: none;
     text-align: left;
    }
    </style>
  </head>
  <body>
   <div style="height: 400px;width: 500px;" align="center">
    <div id="opBillHeader" style="height: 135px;border-bottom: ridge 1px;">
    </div>
    <div id="oBillBody">
      <div id="div1">
    	<table width="100%">
    	 <tr>
    	   <td align="center" style="font-size:xx-small;font-weight: bold;"><U>OP CASH BILL</U></td>
    	 </tr>
    	</table>
      </div>
      <div id="div2" style="border: 1px ridge;">
        <table>
    	 <tr align="left">
    	  <td width="10px"></td><td width="100px" class="td_opBill_dis">Name :</td><td width="150px" class="td_opBill_data"><%=patient.getName()%></td><td width="100px" class="td_opBill_dis">Reg No :</td><td width="150px" class="td_opBill_data"><%=patient.getId()%></td>
    	 </tr>
    	 <tr align="left">
    	  <td width="10px"></td>
    	  <td width="100px" class="td_opBill_dis">
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
    	  <td width="150px" class="td_opBill_data">
    	    <%=ObjectUtil.formatValue(patient.getRelativeName())%>
    	  </td>
    	  <td width="100px" class="td_opBill_dis">Age/Gender:</td>
    	  <td width="150px" class="tr_opBill_data"><%=patient.getAge()%>/<%=patient.getGender()%></td>
    	 </tr>
    	 <tr align="left">
    	  <td width="10px"></td><td width="100px" class="td_opBill_dis">City :</td><td width="150px" class="td_opBill_data"><%=patient.getCity()%></td><td width="100px" class="td_opBill_dis">OP Bill No :</td><td width="150px" class="td_opBill_data"><%=billId%></td>
    	 </tr>
    	 <tr align="left">
    	  <td width="10px"></td><td width="100px" class="td_opBill_dis">Address :</td><td width="150px" class="td_opBill_data"><%=ObjectUtil.formatValue(patient.getAddress())%></td><td width="100px" class="td_opBill_dis">OP Day No :</td><td width="150px" class="td_opBill_data"><%=visit.getDayserial()%></td>
    	 </tr>
    	 <tr align="left">
    	  <td width="10px"></td><td width="100px" class="td_opBill_dis">Phone No :</td><td width="150px" class="td_opBill_data"><%=ObjectUtil.formatValue((null!=patient.getContactno1())?patient.getContactno1():patient.getContactno2())%></td><td width="100px" class="td_opBill_dis">Date :</td><td width="150px" class="td_opBill_data"><%=DateUtil.formatDate("dd-MM-yyyy",bill.getBillDate())%></td>
    	 </tr>
    	 <tr align="left">
    	  <td width="10px"></td><td width="100px" class="td_opBill_dis"></td><td width="150px" class="td_opBill_data"></td><td width="100px" class="td_opBill_dis">Valid :</td><td width="150px" class="td_opBill_data"><%=DateUtil.formatDate("dd-MM-yyyy",bill.getValidtilldate())%></td>
    	 </tr>
    	 <tr align="left">
    	  <td width="10px"></td><td width="100px" class="td_opBill_dis">Consultant :</td><td width="150px" class="td_opBill_data"><%=bill.getConsultant().getName()%></td><td width="100px" class="td_opBill_dis"></td><td width="150px"></td>
    	 </tr>    		    		    		    		    		
    	</table>
      </div>
      <div id="div3">
    	<table>
    	  <tr class="tr_opBill_dis"><td width="10px"></td><td width="220px">Particulars</td><td width="80px">Amount</td><td width="80px">Discount</td><td>Discount Reason</td><td width="160px"><u>NET</u></td></tr>
    	  <tr class="tr_opBill_data"><td></td><td><input type="text" class="print_textbox" value="Consultation"/></td><td><%=ObjectUtil.formatValue(bill.getAmount())%></td><td><%=ObjectUtil.formatValue(bill.getDiscount())%></td><td><%=ObjectUtil.formatValue(bill.getDiscountreason())%></td><td><%=bill.getNetamount() %> Rupees only</td></tr>
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
    		<td align="right" style="vertical-align: bottom;" class="tr_opBill_dis">Signature</td>
    	  </tr>
    	</table>
      </div>
     </div>
    </div>
    <input type="button" value="PRINT" class="print_hide" onclick="window.print();" />
  </body>
  <%}else{
	 response.sendRedirect("validate");
 }%>
</html>
