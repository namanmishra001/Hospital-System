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
	Criteria cr = hsession.createCriteria(IpBill.class);
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
	  <th>Bill No</th>
	  <th>Consultant</th>
	  <th>Patient</th>
	  <th>Bill Date</th>
	  <th>Prepared By</th>
	  <th>Amount</th>
	  <th>Discount</th>
	  <th>Discount Reason</th>
	  <th>Net Amount</th>
	  <th>Print</th>
	 </tr>
	<%
	 Iterator it = bills.iterator();
	 int count = 0;
	 float totalAmount = 0l;
	 while(it.hasNext()){
	   IpBill bill = (IpBill)it.next();
	   %>		
	   <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
		<td align="center"><%=bill.getId()%></td>
		<td><%=bill.getConsultant().getName()%></td>
		<td><%=bill.getPatientInfo().getName()%></td>
		<td align="center"><%=DateUtil.formatDate("dd-MM-yyyy",bill.getBillDate())%></td>
		<td><%=ObjectUtil.formatValue(bill.getUser().getName())%></td>
		<td align="center"><%=ObjectUtil.formatValue(bill.getAmount())%></td>
		<td align="center"><%=ObjectUtil.formatValue(bill.getDiscount())%></td>
		<td><%=ObjectUtil.formatValue(bill.getDiscountreason())%></td>
		<td align="center"><%=ObjectUtil.formatValue(bill.getNetamount())%></td>
		<td align="center"><a href="printIPBill?id=<%=bill.getId()%>">Print</a></td>
	   </tr>
	  <%count++;
	  if(null != bill.getNetamount())
		totalAmount += bill.getNetamount();
	  }%>
	  <tr><td colspan="8" align="right">Total Amount is</td><td align="center"><%=totalAmount%></td></tr>
	 </table>
	<%}else{
	  out.println("<span class='error'>No bills available with given filters</span>");
	 }
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>