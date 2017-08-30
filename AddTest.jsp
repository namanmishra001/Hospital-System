<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.bean.*"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.Query"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
	HttpSession session = request.getSession(false);
	if (null != session) {
		Boolean isValid = new Boolean(request.getParameter("valid"));
		String msg = request.getParameter("msg");
		if (isValid) {
			String TestName = request.getParameter("TestName");
			String TestDepartment = request.getParameter("TestDepartment");
			String TestDepartmentMsg = request.getParameter("TestDepartmentMsg");
			String NormalRangeOrValue = request.getParameter("NormalRangeOrValue");
			String MinimumValue = request.getParameter("MinimumValue");
			String MaximumValue = request.getParameter("MaximumValue");
			String NormalValue = request.getParameter("NormalValue");
			String Cost = request.getParameter("Cost");
			String Percentage = request.getParameter("Percentage");
			Session hsession = BeanFactory.getSession();
			Transaction tx = hsession.beginTransaction();
			LabTest test = new LabTest();
			LabTestDepartment dept = null;
			if (null != TestName)
                            test.setName(TestName.toUpperCase());
			if (null != TestDepartment) {
                            if ((null != TestDepartmentMsg)&& ("".equals(TestDepartmentMsg))) {
                                    dept = (LabTestDepartment) hsession.get(LabTestDepartment.class, Long.parseLong(TestDepartment));
                            } else {
                                    dept = new LabTestDepartment();
                                    dept.setName(TestDepartment.toUpperCase());
                                    hsession.save(dept);
                            }
                            test.setLabTestDepartment(dept);
			}
			if (null != NormalRangeOrValue) {
                            if ("Range".equals(NormalRangeOrValue)) {
                                test.setRange(true);
                                if (null != MinimumValue)
                                        test.setMinValue(Long.parseLong(MinimumValue));
                                if(null!= MaximumValue)
                                        test.setMaxValue(Long.parseLong(MaximumValue));
                            } else if ("Value".equals(NormalRangeOrValue)) {
                                test.setRange(false);
                                if(null != NormalValue)
                                        test.setNormalValue(Boolean.parseBoolean(NormalValue));
                            }
			}
			if (null != Cost)
				test.setCost(Long.parseLong(Cost));
			if (null != Percentage)
				test.setPercentage(Long.parseLong(Percentage));
			hsession.save(test);
			try {
				tx.commit();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				hsession.close();
			}
			response.sendRedirect("addTest?valid=false&msg=New Test Saved Successfully");
		} else {
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
   <link type="text/css" href="CSS/DatePicker.css" rel="stylesheet" />
   <script language="Javascript" src="Scripts/validate.js"></script>
   <script language="Javascript" src="Scripts/jquery-1.7.2.js"></script>
   <script type="text/javascript">
     function validateForm(){
       var form1 = document.forms.item(0);
       var TestName = document.getElementById("TestName");
       var TestNameMsg = document.getElementById("TestNameMsg");
       var TestDepartment = document.getElementById("TestDepartment");
       var TestDepartmentMsg = document.getElementById("TestDepartmentMsg");
       var NormalRangeOrValue = document.getElementById("NormalRangeOrValue");
       var MinimumValue = document.getElementById("MinimumValue");
       var MaximumValue = document.getElementById("MaximumValue");
       var NormalValue = document.getElementById("NormalValue");
       var Cost = document.getElementById("Cost");
       var Percentage = document.getElementById("Percentage");
       if(!isEmpty(TestName))
    	if(TestNameMsg.value=='Test Name is available')
    	 if(!isEmpty(TestDepartment))
    	  if((TestDepartmentMsg.value=='')||(TestDepartmentMsg.value=='Department Name is available'))
    	   if(!isEmpty(NormalRangeOrValue))
    		if(NormalRangeOrValue.value == 'Range'){
    		 if(!isEmpty(MinimumValue)&&(!isEmpty(MaximumValue))){
                    if(!isEmpty(Cost))
                      if(!isEmpty(Percentage)){	
                       document.getElementById("valid").value = true;
                       form1.submit();
                      }
    		 }	
    	    }else
    	    if(NormalRangeOrValue.value == 'Value'){
    	     if(!isEmpty(NormalValue)){
    	      if(!isEmpty(Cost))
               if(!isEmpty(Percentage)){	
    	        document.getElementById("valid").value = true;
    	        form1.submit();
    	       }
              }
    	    }
     }
     function setDepartment(element){
       var value = element.value;
       var TestDepartment = document.getElementById('TestDepartment');
       if("" == value){
    	TestDepartment.value =  "";	
    	TestDepartment.setAttribute("readonly","readonly" );
    	TestDepartment.style.display='none';
       }else
       if(value=="Other"){
    	TestDepartment.value =  "";   
    	TestDepartment.removeAttribute("readonly");
    	TestDepartment.style.display='block';
       }
       else{
    	TestDepartment.value =  value;  
    	TestDepartment.setAttribute("readonly","readonly");
    	TestDepartment.style.display='none';
       }
     }
     function lookup1(inputString) {
		if(inputString.length>0 ) {
			$.post("ValidateTestName.jsp",{testName: ""+inputString+""},function(data){
				//$('#TestNameMsg').html(data).show();
				document.getElementById('TestNameMsg').value = data;
			});
		}else{
				document.getElementById('TestNameMsg').value = "";
		}
	 }
     function lookup2(inputString) {
		if(inputString.length>0 ) {
			$.post("ValidateDeptName.jsp",{deptName: ""+inputString+""},function(data){
				//$('#TestDepartmentMsg').html(data).show();
				document.getElementById('TestDepartmentMsg').value = data;
			});
		}else{
				document.getElementById('TestDepartmentMsg').value = "";
		}
	 }
   </script>
  </head>
  <body class="hd" onload="settime()">
  <div class="main">
   <jsp:include page="Head.jsp" />
  </div>
  <jsp:include page="Menu.jsp" />
  <div class="main" style="min-height: 550px;">
  	<div align="center" class="header">Enter Test Information</div>
  	<form method="post" action="addTest">
     <table align="center" class="inputForm">
      <tr>
 	   <th colspan="4" align="center">
 	 	<%
 	 	if(null != msg)
 	 	  out.println("<span class='msg'>" + msg + "</span>");
 	 	%>	
 	   </th>
 	  </tr>
	  <tr>
	   <td align="right"><span class='error'>* </span>Test Name</td>
	   <td align="left"><input type="text" name="TestName" id="TestName" onkeyup="lookup1(this.value);"/></td>
  	  </tr>
  	  <tr>
  	   <td align="right" colspan="2"><input type="text" id="TestNameMsg" class="msg" value="" readonly="readonly"/></td>
  	  </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="TestNameError" class='error'></div></td>
  	  </tr>
	  <tr>
       <td align="right" valign="top"><span class='error'>* </span>Test Department<br/><br/></td>
       <td align="left">
       	 <select name="TestDepartmentSelect" id="TestDepartmentSelect" onchange="setDepartment(this);">
		  <option value="">---SELECT---</option>
		  <%
		  	Session hsession = BeanFactory.getSession();
		  	String queryString = "from LabTestDepartment order by name";
		  	Query q1 = hsession.createQuery(queryString);
		  	List departments = q1.list();
		  	if (null != departments && departments.size() > 0) {
		  	  Iterator it = departments.iterator();
		  	  while (it.hasNext()) {
		  		LabTestDepartment department = (LabTestDepartment) it.next();
		        %>
				<option value="<%=department.getId()%>"><%=department.getName()%></option>
			    <%
			  }
			}
		 %>
		<option value="Other">Other</option> 
		 </select><br/><br/>
		 <input type="text" name="TestDepartment" id="TestDepartment" readonly="readonly" style="display: none;" onkeyup="lookup2(this.value);"/>
       </td>
      </tr>
      <tr>
  	   <td align="right" colspan="2"><input type="text" id="TestDepartmentMsg" name="TestDepartmentMsg" class="msg" value="" readonly="readonly"/></td>
  	  </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="TestDepartmentError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Normal Range/Value</td>
       <td align="left">
        <select name="NormalRangeOrValue" id="NormalRangeOrValue">
         <option value="">---SELECT---</option>
       	 <option value="Range">Range</option>
       	 <option value="Value">Value</option>
       	</select>
       </td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="NormalRangeOrValueError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right">Minimum</td>
       <td align="left">
       	 <input type="text" name="MinimumValue" id="MinimumValue"/>
       </td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="MinimumValueError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right">Maximum</td>
       <td align="left">
       	 <input type="text" name="MaximumValue" id="MaximumValue"/>
       </td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="MaximumValueError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right">Normal Value</td>
       <td align="left">
        <select name="NormalValue" id="NormalValue" >
         <option value="">--SELECT--</option>
       	 <option value="true">Positive</option>
       	 <option value="false">Negative</option>
       	</select>
       </td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="NormalValueError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Cost</td>
       <td align="left">
       	 <input type="text" name="Cost" id="Cost"/>
       </td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="CostError" class='error'></div></td>
  	  </tr>
  	  <tr>
       <td align="right"><span class='error'>* </span>Percentage</td>
       <td align="left">
       	 <input type="text" name="Percentage" id="Percentage"/>
       </td>
      </tr>
  	  <tr>
	   <td align="right" colspan="2"><div id="PercentageError" class='error'></div></td>
  	  </tr>
	  <tr align = "center">
	   <td>
	    <input type="button" name="ok" id="ok" value="  SAVE  " onclick="validateForm()" />
	   </td>
	   <td>
	    <input type="reset" name="cancel" id="cancel" value="  CLEAR  " />
	   </td>
	  </tr>
	  <tr><td colspan="2"></td></tr>
     </table>
     <input type="hidden" id="valid" name="valid" value="false"/>
    </form>
   </div>
  </body>
  <%
  	}
  	} else {
  		response.sendRedirect("validate");
  	}
  %>
</html>
