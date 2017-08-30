<%@ page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<% response.setContentType("text/html");%>
<%
  try {
	String profileName = request.getParameter("profileName");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(LabTestProfile.class);
	cr.add(Restrictions.eq("name",profileName.toUpperCase()));
	List testsList = cr.list();
	if(null != testsList && testsList.size()>0)
		out.println("Test Profile already exists");
	else
		out.println("Test Profile is available");
	hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>