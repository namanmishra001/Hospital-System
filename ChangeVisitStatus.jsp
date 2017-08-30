<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%
  try {
	String visitId = request.getParameter("visitId");
	Session hsession = BeanFactory.getSession();
	if(null != visitId){
	  Transaction tx = hsession.beginTransaction();	
	  OpVisit visit1 = (OpVisit)hsession.load(OpVisit.class, Long.parseLong(visitId));
	  if(null != visit1)
	   if(visit1.getStatus())  
		visit1.setStatus(false);
	   else
		visit1.setStatus(true);   
	  hsession.persist(visit1);
	  tx.commit();
	}
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>