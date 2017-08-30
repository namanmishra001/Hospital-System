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
        Criterion c2 = Restrictions.ilike("name","%"+searchString+"%");
	cr.add(Restrictions.or(c1,c2));
	cr.addOrder(Order.asc("regddate"));
	List patients = cr.list();
	if(null != patients && patients.size()>0)
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
		<td>Edit</td>
	  </tr>
	<%
	 Iterator it = patients.iterator();
	 int count = 0;
	 while(it.hasNext()){
	   PatientInfo patient = (PatientInfo)it.next();
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
		<td>
		  <%=ObjectUtil.formatValue(patient.getConsultant().getName())%>
		</td>
		<td align="center" nowrap="nowrap">
		  <%
		   cr = hsession.createCriteria(IpBill.class);
		   c1 = Restrictions.eq("patientInfo",patient);
		   cr.add(c1);
		   c2 = Restrictions.isNotNull("admittedDate");
		   cr.add(c2);
		   Criterion c3 = Restrictions.isNull("dischargedDate");
		   cr.add(c3);
		   IpBill ipBill = (IpBill)cr.uniqueResult();
		   RoomOccupancy occupancy = null;
		   if(null==ipBill){
		    %>
		     <a href='addIPDetails?id=<%=patient.getId()%>'>Add Details</a>
		    <%
		   }else{
			 cr = hsession.createCriteria(RoomOccupancy.class);
			 c1 = Restrictions.eq("ipBill",ipBill);
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
		    	out.println(details.getRoomCategory().getName()+" "+details.getRoomnumber());
		    }%>
		</td>
		<td align="center">
		<%if(null!=occupancy){%>
		  <a href="editIPDetails?seqno=<%=occupancy.getSeqNo()%>">Change</a>
		  <%
		   HttpSession session = request.getSession(false);
		   User loggedUser = (User)session.getAttribute("user");
		   if((null!=loggedUser)&&(loggedUser.getUserRole().getId()==2))
		     out.println("<br/><a href='discharge?seqno="+occupancy.getSeqNo()+"'> Discharge</a>");
		 }%>
		</td>
	  </tr>
	  <%count++;
	 }
	 %>
	</table>
	<%}else
	{
		out.println("<span class='error'>No Match Found</span>");
	}
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>