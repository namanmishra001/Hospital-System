<%@ page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<% response.setContentType("text/html");%>
<%
  try {
	String deptName = request.getParameter("deptName");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(LabTestDepartment.class);
	cr.add(Restrictions.eq("name",deptName.toUpperCase()));
	List deptList = cr.list();
	if(null != deptList && deptList.size()>0)
		out.println("Department Name already exists");
	else
		out.println("Department Name is available");
	hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>