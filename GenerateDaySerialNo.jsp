<%@page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="info.inetsolv.tools.DateUtil"%>
<% response.setContentType("text/html");%>
<%
  try {
	String cname = request.getParameter("cname");
	String vdate = request.getParameter("vdate");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(OpVisit.class);
	Criterion c1 = Restrictions.eq("consultant.id",Long.parseLong(cname));
	Criterion c2 = Restrictions.eq("visitdate",DateUtil.stringToLong(vdate));
	Criterion c3 = Restrictions.and(c1,c2);
	cr.add(c3);
	List users = cr.list();
	if(null != users && users.size()>0)
		out.println(users.size()+1);
	else
		out.println("1");
	hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>