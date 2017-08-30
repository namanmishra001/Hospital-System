<%@ page language="java" session="false" import="info.inetsolv.tools.*,info.inetsolv.bean.*,org.hibernate.*,java.util.*" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	Boolean isValid = new Boolean(request.getParameter("valid"));
	String msg = request.getParameter("msg");
	User user = (User)session.getAttribute("user");
	Long id = user.getId();
	if(isValid){
		Session hsession = BeanFactory.getSession();
		Transaction tx = hsession.beginTransaction();
		String Name = request.getParameter("Name");
		String PhoneNo = request.getParameter("PhoneNo");
		String Email = request.getParameter("Email");
		String Address = request.getParameter("Address");
		String Qualification = request.getParameter("Qualification");
		String Speciality = request.getParameter("Speciality");
		String userName = request.getParameter("UserName");
		String password = request.getParameter("Password");
		user = (User)hsession.get(User.class,id);
	    user.setName(Name);
	    user.setUsername(userName);
	    user.setPassword(password);
	    if((null != PhoneNo)&&!("".equals(PhoneNo)))
	    	user.setPhonenumber(Long.parseLong(PhoneNo));
	    if(null != Email)
	    	user.setEmail(Email);
	    if(null != Address)
	    	user.setAddress(Address);
	    if(null != Qualification)
	    	user.setQualification(Qualification);
	    if(null != Speciality)
	    	user.setSpeciality(Speciality);
	    try{
	    	hsession.update(user);
	    	tx.commit();
	    }catch(Exception e){
	    	e.printStackTrace();
	    }finally{
	    	hsession.close();
	    }
	    session.setAttribute("user",user);
	    response.sendRedirect("editProfile?valid=false&msg=Profile Updated Successfully");
	}
  if(null != user && !isValid){	  
  %>
 <head>
    <base href="<%=(String)session.getAttribute("basePath")%>"/>
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
       var nm = document.getElementById("Name");
       var email = document.getElementById("Email");
       var uname = document.getElementById("UserName");
       var pwd = document.getElementById("Password");
       var unameMsg = document.getElementById("unameMsg");
       if(!isEmpty(nm))
    	 if(email.value=='' || validateEmail(email))
    	    if(!isEmpty(uname))
    		 if((unameMsg.value == '')||(unameMsg.value=='UserName is available'))
    		   if(!isEmpty(pwd)){
    		       document.getElementById("valid").value = true;	 
    			   form1.submit();
    			 }
     }
     $(document).ready(function(){
		//called when key is pressed in textbox
		$("#UserName").keypress(function (e){
			//if the letter is not digit then display error and don't type anything
			if( e.which!=8 && e.which!=0 && (e.which<48 || e.which>57)&& (e.which<65 || e.which>90)&& (e.which<97 || e.which>122))
			{
				//display error message
				alert("No Special Characters.Only numbers & alphabets are allowed");
				return false;
			}
		});
	 }); 
	 function lookup(inputString) {
		if(inputString.length <5) {
			document.getElementById('unameMsg').value = "UserName must be more than 4 characters";
		} else {
			var oldUserName = document.getElementById('oldUserName');
			if(inputString != oldUserName.value){
			  $.post("ValidateUserName.jsp",{user: ""+inputString+""},function(data){
				document.getElementById('unameMsg').value = data;
			  });
			}
		}
	 }
    </script>
 </head>
 <body class="hd" onload="settime()">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main" style="min-height: 500px;">
   	 <div align="center" class="header">Edit Your Profile Here</div>
     <form name="userdata"> 
 	 <table align="center" class="inputForm">
 	 	 <tr>
 	 	  <th colspan="4" align="center">
 	 	   	 <%
 	 	   	  if(null != msg)
				out.println("<span class='msg'>"+msg+"</span>");
 	 		 %>	
 	 	  </th>
 	 	 </tr>
		 <tr>
			<td align="right">Name : </td>
			<td align="left"><input type="text" name="Name" id="Name" value="<%=user.getName()%>"/><span class='error'>*</span></td>
			<td align="right">Phone Number : </td>
			<td align="left"><input type="text" name="PhoneNo" id="PhoneNo" value="<%=ObjectUtil.formatValue(user.getPhonenumber())%>" onkeypress=" return allowNumeric(event);"/></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="NameError" class="error"></div></td>
			<td align="center" colspan="2"><div id="PhoneNoError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td align="right">Email : </td>
		    <td align="left"><input type="text" name="Email" id="Email" value="<%=ObjectUtil.formatValue(user.getEmail())%>"/></td>
		    <td align="right">Address : </td>
		    <td align="left"><textarea name="Address" id="Address" rows="3" cols="16"><%=ObjectUtil.formatValue(user.getEmail())%></textarea></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="EmailError" class="error"></div></td>
			<td align="center" colspan="2"><div id="AddressError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td align="right">Qualification : </td>
		    <td align="left"><input type="text" name="Qualification" id="Qualification" value="<%=ObjectUtil.formatValue(user.getQualification())%>"/></td>
			<td align="right">Speciality : </td>
			<td><input type="text" name="Speciality" id="Speciality" value="<%=ObjectUtil.formatValue(user.getSpeciality())%>"/></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="QualificationError" class="error"></div></td>
			<td align="center" colspan="2"><div id="SpecialityError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td align="right">UserName : </td>
		    <td align="left"><input type="text" name="UserName" id="UserName" value="<%=user.getUsername()%>" onkeyup="lookup(this.value);"/><span class='error'>*</span></td>
		    <td align="right">Password : </td>
		    <td align="left"><input type="password" name="Password" id="Password" value="<%=user.getPassword()%>"/><span class='error'>*</span></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="UserNameError" class="error"></div></td>
			<td align="center" colspan="2"><div id="PasswordError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td colspan="2"><input type="text" id="unameMsg" class="msg" value="" readonly="readonly" /></td>
		    <td colspan="2"></td>
		 </tr>
		 <tr>
		    <td colspan="2" align="center"><input type="button" name="ok" id="ok" value="   SAVE  " onclick="validateForm()" /></td>
			<td colspan="2" align="center"><input type="reset" name="cancel" id="cancel" value="  CLEAR " /></td>
		 </tr>
		 <tr>
		    <td colspan="4"></td>
		 </tr>
 	 </table>
 	 <input type="hidden" id="valid" name="valid" value="false"/>
 	 <input type="hidden" id="oldUserName" name="oldUserName" value="<%=user.getUsername()%>"/>
     </form>
   </div>
 </body>
 <%
	}}else{
	 response.sendRedirect("validate");
  }%>
</html>
