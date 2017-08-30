<%@ page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<% response.setContentType("text/html");%>
<%
  try {
	String categoryName = request.getParameter("categoryName");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(RoomCategory.class);
	cr.add(Restrictions.eq("name",categoryName.toUpperCase()));
	List categoriesList = cr.list();
	if(null != categoriesList && categoriesList.size()>0)
		out.println("Category Name already exists");
	else
		out.println("Category Name is available");
	hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>