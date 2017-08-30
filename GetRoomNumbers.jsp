<%@page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="info.inetsolv.tools.DateUtil"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  try {
	String categoryId = request.getParameter("roomCategory");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(RoomDetails.class);
	Criterion c1 = Restrictions.eq("roomCategory.id",Long.parseLong(categoryId));
	cr.add(c1);
	cr.addOrder(Order.asc("floorNumber"));
	List details = cr.list();%>
	<select name="RoomNumber" id="RoomNumber">
	 <option value="">--Select--</option>
	 <%
	  if(null != details && details.size()>0){
	   Iterator it = details.iterator(); 
	   while(it.hasNext()){
		 RoomDetails detail = (RoomDetails)it.next();%>
		 <option value="<%=detail.getId()%>"><%=detail.getRoomnumber()%></option>
	  <%}
	  }%>
	</select>
   <%hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
 %>