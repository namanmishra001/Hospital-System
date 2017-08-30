<%@ page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<% response.setContentType("text/html");%>
<%
  try {
	String testName = request.getParameter("testName");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(LabTest.class);
	cr.add(Restrictions.eq("name",testName.toUpperCase()));
	List testsList = cr.list();
	if(null != testsList && testsList.size()>0)
		out.println("Test Name already exists");
	else
		out.println("Test Name is available");
	hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>