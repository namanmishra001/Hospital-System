<%@page language="java" import="info.inetsolv.bean.*,info.inetsolv.tools.*,java.util.*,org.hibernate.*" session="false" %>
<%@page import="org.hibernate.criterion.Criterion"%>
<%@page import="org.hibernate.impl.CriteriaImpl.CriterionEntry"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="java.util.regex.*"%>
<%@page import="org.hibernate.criterion.Order"%>
<% response.setContentType("text/html");%>
<%
  HttpSession session = request.getSession(false);
  if(null != session){
   ArrayList<Long> tests = null;
   if(null == session.getAttribute("tests"))
	   tests = new ArrayList<Long>();
   else
	   tests = (ArrayList<Long>)session.getAttribute("tests");
   try {
	String id = request.getParameter("id");
	String type = request.getParameter("type");
	String operation = request.getParameter("operation");
	Session hsession = BeanFactory.getSession();
	if((null!=id)&&(!"".equals(id))&&(null!=type)){
	 if("Test".equals(type)){
	   LabTest test = (LabTest)hsession.get(LabTest.class,Long.parseLong(id));
	   if((null!=test)&&(null!=operation)){
		if("Add".equals(operation)){
		 if(!tests.contains(test.getId()))
		   tests.add(test.getId());
		 session.setAttribute("tests",tests);
	    }
		else
		if("Remove".equals(operation)){
		 if(tests.contains(test.getId()))		   
		   tests.remove(test.getId());
		 session.setAttribute("tests",tests);
	    }
	   }
	 }else
	 if("Profile".equals(type)){
	   LabTestProfile profile = (LabTestProfile)hsession.get(LabTestProfile.class,Long.parseLong(id));
	   if((null!=profile)&&(null!=operation)){
		List<Long> tests1 = ObjectUtil.csvToList(profile.getTests(),",");
		if(tests1.size()!=0){
		 if("Add".equals(operation)){
		  for(Long testId:tests1){
		   LabTest test1 = (LabTest)hsession.get(LabTest.class,testId);
		   if(!tests.contains(test1.getId()))
		    tests.add(test1.getId());
		  }
		  session.setAttribute("tests",tests);
	     }
		 else
		 if("Remove".equals(operation)){
		  for(Long testId:tests1){
		   LabTest test1 = (LabTest)hsession.get(LabTest.class,testId);
		   if(tests.contains(test1.getId()))		   
		    tests.remove(test1.getId());
		  }
		  session.setAttribute("tests",tests);
	     }
		}
	   } 
	 }
	}else{
	  if((null!=operation)&&("Clear".equals(operation)))
			session.removeAttribute("tests");
	}
	tests = (ArrayList<Long>)session.getAttribute("tests");
	if(null != tests && tests.size()>0)
		{%>
		 <table align="center">				
		  <tr class="tr_header">
			<td>Id</td>
			<td>Name</td>
			<td>Department</td>
			<td>Test Cost</td>
			<td>Remove?</td>
		  </tr>
		  <%
			Iterator<Long> it = tests.iterator();
		    int count = 0;
		    Long cost = 0l;
			while(it.hasNext()){
			  LabTest test = (LabTest)hsession.get(LabTest.class,it.next());
			 %>		
			 <tr class="<%=(count%2==0)?"tr_even":"tr_odd"%>">
				<td><%=test.getId()%></td>
				<td><%=test.getName()%></td>
				<td><%=test.getLabTestDepartment().getName()%></td>
				<td align="center"><%=ObjectUtil.formatValue(test.getCost())%></td>
				<td><a href="javascript:remove('<%=test.getId()%>','Test')">Remove</a></td>
			 </tr>
			<%
			 cost += test.getCost();
			 count++;
			}
			%>
			<tr><td colspan="3" align="right">Total Cost</td><td align="center"><%=cost%></td><td></td></tr>
			<tr>
			 <td colspan="5">
			  <input type="hidden" id="tests" name="tests" value="<%=ObjectUtil.listToCsv((ArrayList<Long>)session.getAttribute("tests"),",")%>" />
			  <input type="hidden" id="cost" name="cost" value="<%=cost%>" />
			 </td>
			</tr>
		 </table>
	  <%}	
  }catch(Exception e){
	out.println("Exception is "+e);
  }}
  %>