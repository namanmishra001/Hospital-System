<%@ page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<% response.setContentType("text/html");%>
<%
  try {
	String uname = request.getParameter("user");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(User.class);
	cr.add(Restrictions.eq("username",uname));
	List users = cr.list();
	if(null != users && users.size()>0)
		out.println("UserName already exists");
	else
		out.println("UserName is available");
	hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>