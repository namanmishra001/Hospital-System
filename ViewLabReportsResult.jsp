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
	Criteria cr = hsession.createCriteria(LabTestReport.class);
	Criterion c1 = Restrictions.between("reportGeneratedDate",lowerLimitLong,upperLimitLong);
	cr.add(c1);
	if((null != consultantId)&&(!"".equals(consultantId))){
		Criterion c2 = Restrictions.eq("consultant.id",Long.parseLong(consultantId));
		cr.add(c2);
	}
	cr.addOrder(Order.asc("id"));
	List reports = cr.list();
	if((null != reports)&&(reports.size()>0))
	{%>
	<table align="center" >				
	 <tr class="tr_header">
	  <th>Consultant</th>
	  <th>Patient</th>
	  <th>Generated On</th>
	  <th>Delivered On</th>
	  <th>Print</th>
	 </tr>
	<%
	 Iterator it = reports.iterator();
	 int count = 0;
	 while(it.hasNext()){
	   LabTestReport report = (LabTestReport)it.next();
	   %>		
	   <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
		<td><%=report.getConsultant().getName()%></td>
		<td><%=report.getPatientInfo().getName()%></td>
		<td align="center"><%=DateUtil.formatDate("dd-MM-yyyy",report.getReportGeneratedDate())%></td>
		<td align="center"><%=DateUtil.formatDate("dd-MM-yyyy",report.getReportGeneratedDate())%></td>
		<td align="center"><a href="ViewReport.jsp?id=<%=report.getId()%>">Print</a></td>
	   </tr>
	  <%}%>
	 </table>
	<%
         }else{
	  out.println("<span class='error'>No Reports generated on selected Date</span>");
	 }
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>