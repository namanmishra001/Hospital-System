<%@ page language="java" session="false" import="java.util.*,org.hibernate.*,info.inetsolv.bean.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
  </head>
  <body>
   <%
     HttpSession session = request.getSession(false);
     if(null != session){
      session.invalidate();
      response.sendRedirect("login?success=Logout Successful");
     }else{
      String uname = request.getParameter("UserName");
      String pwd = request.getParameter("Password");
      if(null != uname && null != pwd){
       Session session1 = BeanFactory.getSession();
       String queryString = "from User where username=:uname and password=:pwd and status=1";
       Query q1 = session1.createQuery(queryString);
       q1.setString("uname", uname);
       q1.setString("pwd", pwd);
       List users = q1.list();
       if((null!=users)&&(users.size()>0)){
    	User user = (User)users.get(0);
    	session = request.getSession(true);
    	session.setAttribute("user", user);
    	session.setAttribute("basePath", basePath);
    	response.sendRedirect("home");
       }else{
    	response.sendRedirect("login?error=Invalid UserName/Password");
       }
      }else{
    	response.sendRedirect("login?auth=Session has expired.Hence, login to the application once again");
      }
    }%>
  </body>
</html>
