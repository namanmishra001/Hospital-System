<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
 <%
   String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
 %>
 <head>
   <base href="<%=basePath%>" />
   <meta http-equiv="pragma" content="no-cache" />
   <meta http-equiv="cache-control" content="no-cache" />
   <meta http-equiv="expires" content="0" />
   <link rel="stylesheet" type="text/css" href="CSS/styles.css" />
   <script language="Javascript" src="Scripts/validate.js"></script>
   <script type="text/javascript">
   function validateForm(){
       var form1 = document.forms.item(0);
       var uname = document.getElementById("UserName");
       var pwd = document.getElementById("Password");
       if(!isEmpty(uname))
   	   	 if(!isEmpty(pwd))
    	    form1.submit();
   }
   function setFocus(){
	   document.getElementById("UserName").focus();
   }
   </script>
 </head>
 <body class="hd" onload="setFocus()">
 <h1 align="center"> Please enter your login detaits..</h1>
  <div class="login">
   <form action="validate" method="post">
    <table align="center" class="inputForm">
    <tr>
     <td colspan="2">
      <%
  	   String error = request.getParameter("error");
  	   String success = request.getParameter("success");
  	   String auth = request.getParameter("auth");
  	   if(error!=null)
   		 out.println("<span class=\"error\">"+error+"</span>");
  	   else
  	   if(success!=null)
         out.println("<span class=\"success\">"+success+"</span>");
       else
       if(auth!=null)
         out.println("<span class=\"authenticate\">"+auth+"</span>");
      %>
     </td>
    </tr>
    <tr>
     <td>User Name:</td>
     <td><input id="UserName" name="UserName" type="text" /><span class='error'>*</span></td>
    </tr>
    <tr>
	 <td align="right" colspan="2"><div id="UserNameError" class="error"></div></td>
    </tr>
    <tr>
     <td>Password:</td>
     <td><input id="Password" name="Password" type="password" /><span class='error'>*</span></td>
    </tr>
    <tr>
	 <td align="right" colspan="2"><div id="PasswordError" class="error"></div></td>
    </tr>
    <tr>
     <td><input type="button" name="ok" id="ok" value="   LOGIN  " onclick="validateForm();" /></td>
     <td><input type="reset" name="cancel" id="cancel" value="CLEAR"/></td>
    </tr>
   </table>
   </form>
  </div>
 </body>
</html>