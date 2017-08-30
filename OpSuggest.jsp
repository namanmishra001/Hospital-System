<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.regex.*"%>
<%@page import="org.hibernate.criterion.Order"%>
<% 
  response.setContentType("text/html");
  Session hsession = null;
  try {
	String searchString = request.getParameter("searchString");
	hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(PatientInfo.class);
    Criterion c1 = Restrictions.ilike("id",searchString+"%");
    cr.add(c1);
	cr.addOrder(Order.asc("regddate"));
	List patients = cr.list();
	if(null != patients && patients.size()>0)
	{
	 Iterator it = patients.iterator();
	 int count = 0;
	 while(it.hasNext()){
	  PatientInfo patient = (PatientInfo)it.next();
	  %>	
	   <li onclick="fill('<%=patient.getId()%>')"><%=patient.getId()%></li>	
	<%}%>
  <%}else{%>
	   <li>No Suggestions</li>
  <%}
  }catch(Exception e){
	out.println("Exception is "+e);
  }finally{
	hsession.clear();
  }
%>