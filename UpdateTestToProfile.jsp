<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.regex.*"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  HttpSession session = request.getSession(false);
  if(null != session){
   ArrayList<Long> tests = null;
   if(null == session.getAttribute("tests"))
	   tests = new ArrayList<Long>();
   else
	   tests = (ArrayList<Long>)session.getAttribute("tests");
   try {
	String testId = request.getParameter("testId");
	String operation = request.getParameter("operation");
	Session hsession = BeanFactory.getSession();
	if((null!=testId)&&(!"".equals(testId))){
	 LabTest test1 = (LabTest)hsession.get(LabTest.class, Long.parseLong(testId));
	 if((null!=test1)&&(null!=operation)){
	  if("Add".equals(operation)){
	   if(!tests.contains(test1.getId()))
	    tests.add(test1.getId());
	   session.setAttribute("tests",tests);
	  }
	  else
	   if("Remove".equals(operation)){
		if(tests.contains(test1.getId()))		   
		 tests.remove(test1.getId());
		session.setAttribute("tests",tests);
	   }
	 }
	}else{
		if((null!=operation)&&("Clear".equals(operation)))
			session.removeAttribute("tests");
	}
	tests = (ArrayList<Long>)session.getAttribute("tests");
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
			<td>Remove?</td>
		  </tr>
		  <%
			Iterator<Long> it = tests.iterator();
		    int count = 0;
			while(it.hasNext()){
			  LabTest test = (LabTest)hsession.get(LabTest.class,it.next());
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
				<td><a href="javascript:removeTest('<%=test.getId()%>')">Remove</a></td>
			 </tr>
			<%count++;
			}
			%>
			<tr><td colspan="10"><input type="hidden" id="tests" name="tests" value="<%=ObjectUtil.listToCsv((ArrayList<Long>)session.getAttribute("tests"),",")%>" /></td></td></tr>
		 </table>
	  <%}	
  }catch(Exception e){
	out.println("Exception is "+e);
  }}
%>