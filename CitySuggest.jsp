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
	Criteria cr = hsession.createCriteria(City.class);
    Criterion c1 = Restrictions.ilike("name",searchString+"%");
    cr.add(c1);
	cr.addOrder(Order.asc("id"));
	List cities = cr.list();
	if(null != cities && cities.size()>0)
	{
	 Iterator it = cities.iterator();
	 int count = 0;
	 while(it.hasNext()){
	  City city = (City)it.next();
	  %>	
	   <li onclick="fill1('<%=city.getName()%>')"><%=city.getName()%></li>	
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