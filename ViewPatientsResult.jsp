<%@ page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  try {
	String searchString = request.getParameter("searchString");
	Long lowerLimitLong = DateUtil.stringToLong(searchString);
	Long upperLimitLong = DateUtil.ceilDate(lowerLimitLong);
	Session session = BeanFactory.getSession();
	Criteria cr = session.createCriteria(PatientInfo.class);
	Criterion c1 = Restrictions.between("regddate",lowerLimitLong,upperLimitLong);
	cr.add(c1);
	cr.addOrder(Order.asc("regddate"));
	List patients = cr.list();
	if((null != patients)&&(patients.size()>0))
	{%>
	<table align="center">				
	 <tr class="tr_header">
	   <td>Id</td>
	   <td>Name</td>
	   <td>Gender</td>
	   <td>Age</td>
	   <td>City</td>
	   <td>Address</td>
	   <td>Contact No1</td>
	   <td>Contact No2</td>
	   <td>Relation Type</td>
	   <td>Relative Name</td>
	   <td>Consultant</td>
	   <td>Reg. Type</td>
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
		  <td><%=ObjectUtil.formatValue(patient.getContactno2())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getRelationType())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getRelativeName())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getConsultant().getName())%></td>
		  <td><%=ObjectUtil.formatValue(patient.getRegType())%></td>
		</tr>
	  <%count++;
	   }%>
	 </table>
		
	<%}else{
	  out.println("<span class='error'>No Patient Registered on this Date</span>");
	 }
  }catch(Exception e){
	out.println("Exception is "+e);
  }
%>