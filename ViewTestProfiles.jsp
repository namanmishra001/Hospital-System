<%@ page language="java" session="false" import="org.hibernate.*,java.util.*,info.inetsolv.bean.*,info.inetsolv.tools.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.hibernate.criterion.Order"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	String msg = request.getParameter("msg");
  %>
  <head>
   <base href="<%=session.getAttribute("basePath")%>"/>
   <meta http-equiv="pragma" content="no-cache" />
   <meta http-equiv="cache-control" content="no-cache" />
   <meta http-equiv="expires" content="0" />
   <meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
   <meta http-equiv="description" content="This is my page" />
   <link type="text/css" href="CSS/styles.css" rel="stylesheet" />
   <link type="text/css" href="CSS/menu.css" rel="stylesheet" />
   <link type="text/css" href="CSS/tooltip.css" rel="stylesheet" />
  </head>
  <body class="hd" onload="javascript: settime();">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main">
    <div align="center">
  	<%
 	  if (null != msg)
 	 	out.println("<span class='msg'>" + msg + "</span>");
 	%>
 	</div>
   	<div align="center" style="min-height:550px;padding-top:50px;">
   	  <%
      try {
	   Session hsession = BeanFactory.getSession();
	   Criteria cr = hsession.createCriteria(LabTestProfile.class);
	   cr.addOrder(Order.asc("id"));
	   List testProfiles = cr.list();
	   if(null != testProfiles && testProfiles.size()>0)
	   {%>
	   List of Lab Test Profiles
	    <table align="center">				
	     <tr class="tr_header">
		  <td>Id</td>
		  <td>Profile</td>
		  <td>Tests</td>
		  <td>Edit?</td>
	     </tr>
	     <%
		  Iterator it = testProfiles.iterator();
	      int count = 0;
		  while(it.hasNext()){
		   LabTestProfile testProfile = (LabTestProfile)it.next();
		   %>		
		   <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>">
			<td><%=testProfile.getId()%></td>
			<td><%=testProfile.getName()%></td>
			<td>
			 <%
			   List<Long> tests=ObjectUtil.csvToList(testProfile.getTests(),",");
			   if(null!=tests){
				 for(Iterator<Long> it1=tests.iterator();it1.hasNext();){
					LabTest test = (LabTest)hsession.get(LabTest.class,it1.next());
					if(null!=test){%>
					 <span class="link">
					  <a href="javascript:void(0);">
					   <%=test.getName()%>
					   <span>
					    <p align="center" style="text-transform:capitalize;font-weight:bold">Test Details</p>
					    Test Name : <%=test.getName()%><br/><br/>
					    Department : <%=test.getLabTestDepartment().getName()%><br/><br/>
					    Range/Value: <%=(null!=test.getRange())?(test.getRange()==true)?"Range":"Value":""%><br/><br/>
					    Minimum Value: <%=ObjectUtil.formatValue(test.getMinValue())%><br/><br/>
					    Maximum Value: <%=ObjectUtil.formatValue(test.getMaxValue())%><br/><br/>
					    Normal Value: <%=(null!=test.getNormalValue())?(test.getNormalValue()==true)?"Positive":"Negative":""%><br/><br/>
					    Cost: <%=ObjectUtil.formatValue(test.getCost())%><br/><br/>
					    Royality: <%=ObjectUtil.formatValue(test.getPercentage())%>
					   </span>
					  </a>
					 </span><br/>
					<%}
				 }
			   }
			 %>
			</td>
			<td><a href="editTestProfile?id=<%=testProfile.getId()%>">Edit</a></td>
		   </tr>
		 <%count++;
		  }
		  %>
	    </table>
	   <%}else{
		    out.println("<span class='error'>Test Profiles are not Available</span>");
	    }
       }catch(Exception e){
	      out.println("Exception is "+e);
       }%>
   	</div>
   </div>
  </body>
  <%}else{
	 response.sendRedirect("validate");
  }%>
</html>
