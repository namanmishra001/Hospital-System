<%@ page language="java" session="false" import="info.inetsolv.bean.*,info.inetsolv.tools.*,org.hibernate.*,java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="javax.persistence.OrderBy"%>
<%@page import="org.hibernate.criterion.Order"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	String idString = request.getParameter("id");
	String msg = request.getParameter("msg");
	Session hsession = BeanFactory.getSession();
	PatientInfo patient = (PatientInfo)hsession.get(PatientInfo.class,idString);
	Set<OpBill> opBills = patient.getOpBills();
	Criteria cr = hsession.createCriteria(OpVisit.class);
	Criterion c1 = Restrictions.in("opBill",opBills);
	cr.add(c1);
	cr.addOrder(Order.asc("id"));
  %>
  <head>
    <base href="<%=session.getAttribute("basePath")%>"/>
 	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="expires" content="0" />    
    <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
	<link type="text/css" href="CSS/menu.css" rel="stylesheet" />
	<link type="text/css" href="CSS/tooltip.css" rel="stylesheet" />
    <script language="Javascript" src="Scripts/validate.js"></script>
    <script language="javascript" src="Scripts/jquery-1.7.2.js"></script>
    <script language="Javascript">
     function showForm(a,b){
      window.location.href="NewAppointment.jsp?billId="+a+"&OperationType="+b;
     }
    </script>
  </head>
  <body class="hd">
   <div class="main">
   <div align="center" class="header">Visit Information</div>	 
	<%
	  List opVisitsList = cr.list();
	  if(null!=opVisitsList && opVisitsList.size()>0){	
	%>
	<table align="center" >				
	 <tr class="tr_header">
	  <th>Bill No</th>
	  <th>Consultant</th>
	  <th>Symptoms</th>
	  <th>Weight</th>
	  <th>Temperature</th>
	  <th>Blood Pressure</th>
	  <th>Visit Date</th>
	  <th>Day Serial No</th>
	  <th>New/Renewal</th>
	  <th>Print Bill</th>
	 </tr>
	<%
	 Iterator it = opVisitsList.iterator();
	 int count = 0;
	 while(it.hasNext()){
	   OpVisit visit = (OpVisit)it.next();
	   OpBill bill = visit.getOpBill();
	   %>		
	   <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
		<td align="center">
		 <span class="link">
		  <a href="javascript:void(0);">
		   <%=bill.getId()%>
		   <span>
		    <p align="center" style="text-transform:capitalize;font-weight:bold">Bill Details</p>
		    Consultant Name : <%=bill.getConsultant().getName()%><br/><br/>
		    Patient Name : <%=bill.getPatientInfo().getName()%><br/><br/>
		    Bill Date : <%=DateUtil.formatDate("dd-MM-yyyy HH:mm:ss",bill.getBillDate())%><br/><br/>
		    Initial Visit Date: <%=DateUtil.formatDate("dd-MM-yyyy",bill.getInitialvisitdate())%><br/><br/>
		    Valid Up To: <%=DateUtil.formatDate("dd-MM-yyyy",bill.getValidtilldate())%><br/><br/>
		    Maximum Visits: <%=bill.getVisitscount()%><br/><br/>
		    Amount: <%=ObjectUtil.formatValue(bill.getAmount())%><br/><br/>
		    Discount: <%=ObjectUtil.formatValue(bill.getDiscount())%><br/><br/>
		    Discount Reason: <%=ObjectUtil.formatValue(bill.getDiscountreason())%><br/><br/>
		    Net Amount: <%=ObjectUtil.formatValue(bill.getNetamount())%><br/><br/>
		    Prepared By: <%=ObjectUtil.formatValue(bill.getUser().getName())%><br/><br/>
		   </span>
		  </a>
		 </span>
		</td>
		<td><%=visit.getConsultant().getName()%></td>
		<td><%=ObjectUtil.formatValue(visit.getSymptoms())%></td>
		<td align="center"><%=ObjectUtil.formatValue(visit.getWeight())%></td>
		<td align="center"><%=ObjectUtil.formatValue(visit.getTemperature())%></td>
		<td align="center"><%=ObjectUtil.formatValue(visit.getBloodpressure())%></td>
		<td><%=(null != visit.getVisitdate())?DateUtil.formatDate("dd-MM-yyyy",visit.getVisitdate()):""%></td>
		<td align="center"><%=ObjectUtil.formatValue(visit.getDayserial())%></td>
		<td>
		 <%
		   Long billId = bill.getId();
		   if(!it.hasNext()){
			 if(DateUtil.isTodayLessThan(bill.getValidtilldate())&&(bill.getOpVisits().size()<bill.getVisitscount()))
				out.println("<a href=javascript:showForm("+billId+",'Renewal')>Renewal</a>");
			 else
				out.println("<a href=javascript:showForm("+billId+",'New')>New Bill</a>");
		   }else{
			 out.println("Completed");
		   }
		 %>
		</td>
		<td align="center"><a href='javascript:fnPopUp("PrintOPBill.jsp?billId=<%=billId%>&visitId=<%=visit.getId()%>",450,550);'>Print</a></td>
	   </tr>
	   <%count++;}%>
	</table>
	<div align="center">
	<%if(null != msg)
		 out.println("<span class='msg'>"+msg+"</span>");
	}else{%>
	<span class="error">Visits Information Not Available.Please try after some time.</span>
	<%}%>
	<a href=javascript:window.close();>Close this window</a>
	</div>
   </div>		
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
