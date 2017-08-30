<%@page language="java" import="java.util.*,info.inetsolv.bean.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="info.inetsolv.tools.DateUtil"%>
<%@page import="org.hibernate.criterion.Order"%>
<%@page import="info.inetsolv.tools.ObjectUtil"%>
<%response.setContentType("text/html");%>
<%
  try {
	String roomDetailsId = request.getParameter("roomDetailsId");
	Session hsession = BeanFactory.getSession();
	RoomDetails details = (RoomDetails)hsession.get(RoomDetails.class,Long.parseLong(roomDetailsId));
	List freeBeds = ObjectUtil.csvToList(details.getFreeBeds(),",");
	Collections.sort(freeBeds);
	%>
	<select name="BedNumber" id="BedNumber">
	 <option value="">--Select--</option>
	 <%
	  if(null != freeBeds && freeBeds.size()>0){
	    for(int i=0;i<freeBeds.size();i++){%>
		 <option value="<%=freeBeds.get(i)%>"><%=freeBeds.get(i)%></option>
	  <%}
	  }%>
	</select>
   <%hsession.close();
  }catch(Exception e){
	out.println("Exception is "+e);
  }
 %>