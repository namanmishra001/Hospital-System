<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.regex.*"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  try {
	String searchString = request.getParameter("searchString");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(LabTest.class);
	if(null != searchString){
	  if(!"ALL".equals(searchString))
		cr.add(Restrictions.eq("labTestDepartment.id",Long.parseLong(searchString)));  
	}
	cr.addOrder(Order.asc("id"));
	List tests = cr.list();
	if(null != tests && tests.size()>0)
	{%>
	 <table align="center">				
	  <tr class="tr_header">
		<td>Id</td>
		<td>Name</td>
		<td>Department</td>
		<td>Range/Value</td>
		<td>Minimum Value</td>
		<td>Maximum Value</td>
		<td>Normal Value</td>
		<td>Test Cost</td>
		<td>Royality(in %)</td>
		<td>Edit?</td>
	  </tr>
	  <%
		Iterator it = tests.iterator();
	    int count = 0;
		while(it.hasNext()){
		  LabTest test = (LabTest)it.next();
		 %>		
		 <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>">
			<td><%=test.getId()%></td>
			<td><%=test.getName()%></td>
			<td><%=test.getLabTestDepartment().getName()%></td>
			<td><%=(null!=test.getRange())?(test.getRange()==true)?"Range":"Value":""%></td>
			<td align="center"><%=ObjectUtil.formatValue(test.getMinValue())%></td>
			<td align="center"><%=ObjectUtil.formatValue(test.getMaxValue())%></td>
			<td><%=(null!=test.getNormalValue())?(test.getNormalValue()==true)?"Positive":"Negative":""%></td>
			<td align="center"><%=ObjectUtil.formatValue(test.getCost())%></td>
			<td align="center"><%=ObjectUtil.formatValue(test.getPercentage())%></td>
			<td><a href="editTest?id=<%=test.getId()%>">Edit</a></td>
		 </tr>
		<%count++;
		}
		%>
	 </table>
	<%}else
	{
		out.println("<span class='error'>Tests are not avaiable in the selected department</span>");
	}
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>