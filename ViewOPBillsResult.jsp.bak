<%@ page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  try {
	String searchString = request.getParameter("searchString");
	String consultantId = request.getParameter("consultant");
	Long lowerLimitLong = DateUtil.stringToLong(searchString);
	Long upperLimitLong = DateUtil.ceilDate(lowerLimitLong);
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(OpBill.class);
	Criterion c1 = Restrictions.between("billDate",lowerLimitLong,upperLimitLong);
	cr.add(c1);
	if((null != consultantId)&&(!"".equals(consultantId))){
		Criterion c2 = Restrictions.eq("consultant.id",Long.parseLong(consultantId));
		cr.add(c2);
	}
	cr.addOrder(Order.asc("id"));
	List bills = cr.list();
	if((null != bills)&&(bills.size()>0))
	{%>
	<table align="center" >				
	 <tr class="tr_header">
	  <th nowrap="nowrap">S. No.</th>
	  <th>Consultant</th>
	  <th>Patient</th>
	  <th>Bill Date</th>
	  <th>Initial Visit Date</th>
	  <th>Valid Up To</th>
	  <th>Maximum Visits</th>
	  <th>Amount</th>
	  <th>Discount</th>
	  <th>Discount Reason</th>
	  <th>Net Amount</th>
	  <th>Prepared By</th>
	  <th>Edit?</th>
	 </tr>
	<%
	 Iterator it = bills.iterator();
	 int count = 0;
	 Long totalAmount = 0l;
	 while(it.hasNext()){
	   OpBill bill = (OpBill)it.next();
	   %>		
	   <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
		<td align="center"><%=++count%></td>
		<td nowrap="nowrap"><%=bill.getConsultant().getName()%></td>
		<td nowrap="nowrap"><%=bill.getPatientInfo().getName()%></td>
		<td align="center" nowrap="nowrap"><%=DateUtil.formatDate("dd-MM-yyyy",bill.getBillDate())%></td>
		<td align="center" nowrap="nowrap"><%=DateUtil.formatDate("dd-MM-yyyy",bill.getInitialvisitdate())%></td>
		<td align="center" nowrap="nowrap"><%=DateUtil.formatDate("dd-MM-yyyy",bill.getValidtilldate())%></td>
		<td align="center"><%=bill.getVisitscount()%></td>
		<td align="center"><%=ObjectUtil.formatValue(bill.getAmount())%></td>
		<td align="center"><%=ObjectUtil.formatValue(bill.getDiscount())%></td>
		<td><%=ObjectUtil.formatValue(bill.getDiscountreason())%></td>
		<td align="center"><%=ObjectUtil.formatValue(bill.getNetamount())%></td>
		<td><%=ObjectUtil.formatValue(bill.getUser().getName())%></td>
		<td><a href="editOpBill?id=<%=bill.getId()%>">EDIT</a></td>
	   </tr>
	  <%
	  if(null != bill.getNetamount())
		  totalAmount += bill.getNetamount();
	  }%>
	  <tr><td colspan="10" align="right">Total Amount is</td><td align="center"><%=totalAmount%></td></tr>
	 </table>
	<%}else{
	  out.println("<span class='error'>No Bills available on selected Date</span>");
	 }
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>