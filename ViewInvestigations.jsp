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
	PatientInfo patient = (PatientInfo)hsession.get(PatientInfo.class, searchString);
    Set<LabTestReport> reports = patient.getLabTestReports();
	if(reports.size()>0)
	{
		out.println("Investigations of "+patient.getName()+" are:");
	 %>
	 <table align="center">				
	  <tr class="tr_header">
		<td>S.No.</td>
		<td>Doctor</td>
		<td>Report Prescribed Date</td>
		<td>Report Generated Date</td>
		<td>Report Delivered Date</td>
		<td>Total Cost</td>
		<td>Bill</td>
		<td>Report</td>
	  </tr>
	  <%
	   Iterator<LabTestReport> it = reports.iterator();
	   int count = 0;
	   while(it.hasNext()){
	     LabTestReport report = (LabTestReport)it.next();
	   %>		
	   <tr class='<%=(count%2==0)?"tr_even":"tr_odd"%>'>
		<td align="center"><%=++count%></td>
		<td><%=report.getConsultant().getName()%></td>
		<td align="center"><%=(null!=report.getReportPrescribedDate())?DateUtil.formatDate("dd-MM-yyyy",report.getReportPrescribedDate()):""%></td>
		<td align="center"><%=(null!=report.getReportGeneratedDate())?DateUtil.formatDate("dd-MM-yyyy",report.getReportGeneratedDate()):""%></td>
		<td align="center"><%=(null!=report.getReportDeliveredDate())?DateUtil.formatDate("dd-MM-yyyy",report.getReportDeliveredDate()):""%></td>
		<td align="center"><%=ObjectUtil.formatValue(report.getTotalCost())%></td>
		<%
		 if(report.getLabBills().size()==0){
		   out.println("<td align='center'><a href='generateLabBill?id="+report.getId()+"&valid=false'>Generate</a></td>");
		   out.println("<td></td>");
		 }else{
		   LabBill bill = report.getLabBills().iterator().next();
		   %>
		   <td align="center">
			<span class="link">
			 <a href="javascript:void(0);">
			  <%=bill.getId()%>
			  <span>
			    <p align="center" style="text-transform:capitalize;font-weight:bold">Bill Details</p>
			    Consultant Name : <%=bill.getConsultant().getName()%><br/><br/>
			    Patient Name : <%=bill.getPatientInfo().getName()%><br/><br/>
			    Bill Date : <%=DateUtil.formatDate("dd-MM-yyyy HH:mm:ss",bill.getBilldate())%><br/><br/>
			    Prepared By: <%=ObjectUtil.formatValue(bill.getUser().getName())%><br/><br/>
			    Amount: <%=ObjectUtil.formatValue(bill.getAmount())%><br/><br/>
			    Discount: <%=ObjectUtil.formatValue(bill.getDiscount())%><br/><br/>
			    Discount Reason: <%=ObjectUtil.formatValue(bill.getDiscountreason())%><br/><br/>
			    Net Amount: <%=ObjectUtil.formatValue(bill.getNetAmount())%><br/><br/>
			  </span>
			 </a>
			</span>
		   </td>
		   <td align="center">
		   <%
		    HttpSession session = request.getSession(false);
		    User loggedinUser = (User)session.getAttribute("user");
		    if(loggedinUser.getUserRole().getId() == 3l){
		      out.println("<a href='viewReport?id="+bill.getLabTestReport().getId()+"'>View</a>");	
		    }
		    else if(loggedinUser.getUserRole().getId() == 5l){
		     if(bill.getLabTestReport().getLabTestReportDetails().size()==0){
		      out.println("<a href='addReport?id="+bill.getLabTestReport().getId()+"'>Add</a>");
		     }else{
		      out.println("<a href='editReport?id="+bill.getLabTestReport().getId()+"'>Edit</a> / ");
		      out.println("<a href='viewReport?id="+bill.getLabTestReport().getId()+"'>View</a>");
		     }
		    }
		   %>
		   </td>
		 <%}%>
		</td>
	   </tr>
	   <%}%>
	 </table>
	<%
	}else{
		out.println("<span class='error'>Investigations not available for "+patient.getName()+"</span>");
	}
  }catch(Exception e){
	out.println("Exception is "+e);
  }finally{
	  hsession.clear();
  }
%>