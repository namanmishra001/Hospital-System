<%@ page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  try {
	String regddate = request.getParameter("regddate");
	String consultantId = request.getParameter("consultant");
	Long lowerLimitLong = DateUtil.stringToLong(regddate);
	Long upperLimitLong = DateUtil.ceilDate(lowerLimitLong);
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(OpVisit.class);
	Criterion c1 = Restrictions.between("visitdate",lowerLimitLong,upperLimitLong);
	cr.add(c1);
	if((null != consultantId)&&(!"".equals(consultantId))){
		User consultant = (User)hsession.get(User.class,Long.parseLong(consultantId));
		Criterion c2 = Restrictions.eq("consultant",consultant);
		cr.add(c2);
	}
	cr.addOrder(Order.asc("id"));
	List visists = cr.list();
	if((null != visists)&&(visists.size()>0))
	{%>
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
	  <th>Status</th>
	 </tr>
	<%
	 Iterator it = visists.iterator();
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
		   if((bill.getOpVisits().size()>1)&&(bill.getInitialvisitdate()!=visit.getVisitdate()))
				out.println("Renewal");
		   else
				out.println("New");
		 %>
		</td>
		<td align="center"><a href='javascript:fnPopUp("PrintOPBill.jsp?billId=<%=bill.getId()%>&visitId=<%=visit.getId()%>",450,550);'>Print</a></td>
		<td align="center">
		  <%
		   if(visit.getStatus())
			out.println("<input type='checkbox' id='status' name='status' value='"+visit.getId()+"' checked='checked' onchange=\"changeStatus(this.value)\"/>");
		   else
			out.println("<input type='checkbox' id='status' name='status' value='"+visit.getId()+"' onchange=\"changeStatus(this.value)\"/>");
		  %>
		</td>
	   </tr>
	   <%count++;}%>
	</table>
	<%}else{
	  out.println("<span class='error'>No Appointment is Fixed on selected Date</span>");
	 }
	hsession.clear();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>