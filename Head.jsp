<%@page session="false" import="info.inetsolv.bean.*,java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
 HttpSession session = request.getSession(false);
 String userName = "";
 if(null != session){
 	User user = (User)session.getAttribute("user");
 	if(null!=user){
 	 if(null!=user.getName())
 	  userName = user.getName();
 	}
 %>
 <script language="JavaScript1.2">
  setInterval("settime()", 1000);
  function settime() {
   var curtime = new Date();
   var curhour = curtime.getHours();
   var curmin = curtime.getMinutes();
   var cursec = curtime.getSeconds();
   var time = ""; 
   if(curhour == 0) curhour = 12;
   time = (curhour > 12 ? curhour - 12 : curhour) + ":" +
         (curmin < 10 ? "0" : "") + curmin + ":" +
         (cursec < 10 ? "0" : "") + cursec + " " +
         (curhour >= 12 ? "PM" : "AM");
   document.getElementById('clock').value = time;
  }
 </script>
 <table width="960px" cellpadding="0" cellspacing="0">
  <tr>
   <td><img src="Images/Title.png" alt="Enterprise Infirmary Managment and Patient Care Automation Software"/></td>
   <td align="right">
   	<%=new SimpleDateFormat("dd MMMM yyyy").format(new Date())%>
    <input id="clock" type="text" class="timer" size="10" readonly="readonly"/><br />
    <font class="timer">Welcome  
     <%out.println("<span class=\'user\'>"+userName+"</span>");%>
     <a href="javascript: logout();" title="It is used to come out of the application">Logout</a>
    </font>
   </td>
  </tr>
 </table>
 <%}else{
	 response.sendRedirect("validate");
  }%>