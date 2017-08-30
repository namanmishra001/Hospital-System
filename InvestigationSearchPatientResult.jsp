 <%@ page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
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
		<td>Investigations</td>
	  </tr>
	<%
	 Iterator it = patients.iterator();
	 int count = 0;
	 while(it.hasNext()){
	   PatientInfo patient = (PatientInfo)it.next();
	   %>		
	  <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
		<td align="center"><%=patient.getId()%></td>
		<td><%=patient.getName()%></td>
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
		<td align="center"><a href='addInvestigation?id=<%=patient.getId()%>'>Add</a> / <a href="javascript:viewInvestigations('<%=patient.getId()%>')">View</a></td>
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