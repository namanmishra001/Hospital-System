<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.regex.*"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  try {
	String searchString = request.getParameter("searchString");
	Session hsession = BeanFactory.getSession();
	Criteria cr = hsession.createCriteria(User.class);
	Scanner scanner = new Scanner(searchString);
	if(!scanner.hasNextInt()){
	 Criterion c1 = Restrictions.ilike("name","%"+searchString+"%");
	 Criterion c2 = Restrictions.like("username",searchString+"%");
	 cr.add(Restrictions.or(c1,c2)); 
	}else{
	 Criterion c3 = Restrictions.idEq(Long.parseLong(searchString));
	 cr.add(c3);
	}
	cr.addOrder(Order.asc("id"));
	List users = cr.list();
	if(null != users && users.size()>0)
	{%>
	 <table align="center">				
	  <tr class="tr_header">
		<td>Id</td>
		<td>Name</td>
		<td>Role</td>
		<td>Phone No</td>
		<td>Email</td>
		<td>Qualification</td>
		<td>Speciality</td>
		<td>User Name</td>
		<td>Password</td>
		<td>Date Of Join</td>
		<td>Date Of Left</td>
		<td>Status</td>
		<td>Edit?</td>
	  </tr>
	  <%
		Iterator it = users.iterator();
	    int count = 0;
		while(it.hasNext()){
		  User user = (User)it.next();
		 %>		
		 <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>">
			<td><%=user.getId()%></td><td><%=user.getName()%></td><td><%=user.getUserRole().getRole()%></td>
			<td><%=ObjectUtil.formatValue(user.getPhonenumber())%></td>
			<td><%=ObjectUtil.formatValue(user.getEmail())%></td>
			<td><%=ObjectUtil.formatValue(user.getQualification())%></td>
			<td><%=ObjectUtil.formatValue(user.getSpeciality())%></td>
			<td><%=ObjectUtil.formatValue(user.getUsername())%></td>
			<td><%=ObjectUtil.formatValue(user.getPassword())%></td>
			<td><%=(null != user.getDoj())?DateUtil.formatDate("dd-MMM-yyyy",user.getDoj()):""%></td>
			<td><%=(null != user.getDol() && 0l!= user.getDol())?DateUtil.formatDate("dd-MMM-yyyy",user.getDol()):""%></td>
			<td><%=((null!=user.getStatus())&&(user.getStatus()==true))?"Active":"Inactive"%></td>
			<td><a href="editEmployee?id=<%=user.getId()%>">Edit</a></td>
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