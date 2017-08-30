<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.regex.*"%>
<%@page import="org.hibernate.criterion.Order"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
 HttpSession session = request.getSession(false);
 if(null != session){%>
 <head>
   <base href="<%=session.getAttribute("basePath")%>"/>
   <meta http-equiv="pragma" content="no-cache" />
   <meta http-equiv="cache-control" content="no-cache" />
   <meta http-equiv="expires" content="0" />
   <meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
   <meta http-equiv="description" content="This is my page" />
   <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
   <link type="text/css" href="CSS/menu.css" rel="stylesheet" />
   <script language="Javascript" src="Scripts/validate.js"></script>
 </head>
  <body class="hd" onload="settime()">
  <div class="main">
   <jsp:include page="Head.jsp" />
  </div>
  <jsp:include page="Menu.jsp" />
  <div class="main" style="min-height: 500px;">
   <div align="center" class="header">
    In-Patient Details on <%=new SimpleDateFormat("dd-MM-yyyy").format(new Date())%>
   </div>
  <% 
   Session hsession = null;
   try {
	hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(IpBill.class);
	Criterion c1 = Restrictions.isNotNull("admittedDate");
	cr.add(c1);
	Criterion c2 = Restrictions.isNull("dischargedDate");
	cr.add(c2);
	cr.add(Restrictions.and(c1,c2));
	cr.addOrder(Order.asc("admittedDate"));
	List bills = cr.list();
	if(null != bills && bills.size()>0)
	{%>
	 <table align="center">				
	  <tr class="tr_header">
		<td>Id</td>
		<td>Name</td>
		<td>Gender</td>
		<td>Age</td>
		<td>City</td>
		<td>Address</td>
		<td>Contact No</td>
		<td>Relation Type</td>
		<td>Relative Name</td>
		<td>Consultant</td>
		<td>IP Details</td>
	  </tr>
	  <%
	   Iterator it = bills.iterator();
	   int count = 0;
	   while(it.hasNext()){
		IpBill bill = (IpBill)it.next();
	    PatientInfo patient = bill.getPatientInfo();
	    %>		
	    <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
		  <td align="center"><%=patient.getId()%></td>
		  <td nowrap="nowrap"><%=patient.getName()%></td>
		  <td><%=patient.getGender()%></td>
		  <td align="center"><%=patient.getAge()%></td>
		  <td><%=patient.getCity()%></td>
		  <td><%=ObjectUtil.formatValue(patient.getAddress())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getContactno1())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getRelationType())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getRelativeName())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getConsultant().getName())%></td>
		  <td align="center" nowrap="nowrap">
		   <%
		    RoomOccupancy occupancy = null;
		    cr = hsession.createCriteria(RoomOccupancy.class);
			c1 = Restrictions.eq("ipBill",bill);
			c2 = Restrictions.eq("patient",patient);
			cr.add(Restrictions.and(c1,c2));
			cr.addOrder(Order.asc("seqNo"));
		    List occupancies = cr.list();
		    RoomDetails details = null;
		    if((null != occupancies)&&(!occupancies.isEmpty())){
		      for(Iterator it1 = occupancies.iterator();it1.hasNext();){
		    	occupancy = (RoomOccupancy)it1.next();
		      }
		      if(null != occupancy)
		        details = occupancy.getRoomDetails();
		   }
		   if(null != details)
		   	out.println(details.getRoomCategory().getName()+" "+details.getRoomnumber()+" "+occupancy.getBedNumber());
		   %>
		  </td>
	    </tr>
	  <%count++;
	 }
	 %>
	</table>
	<%}else
	{
	 out.println("<div class='error' align='center'>No patient is admitted yet</div>");
	}
  }catch(Exception e){
	out.println("Exception is "+e);
  }finally{
	  hsession.clear();
  }%>
  </div>
  </body>
  <%
 }else{
	 response.sendRedirect("validate");
 }
%>
</html>