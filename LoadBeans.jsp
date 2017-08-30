<%@page session="false" language="java" import="java.util.*,info.inetsolv.bean.*,info.inetsolv.job.*" pageEncoding="ISO-8859-1"%>
<%@page import="org.hibernate.Session"%>
<%@page import="info.inetsolv.job.Deploy"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
    <%!public void jspInit(){
    	Session hsession = null; 
    	try{
	       hsession = BeanFactory.getSession();
	       User user = (User)hsession.get(User.class,1l);
	       if(null==user){
	    	 System.out.println("HMS Initialization Started");
	    	 Deploy init = new Deploy();
	    	 init.deploy();
	    	 System.out.println("HMS Initialized Successfully");
	       }
	       Timer scheduler = new Timer();
	       RefreshUserStatus refresh = new RefreshUserStatus();
	       ServletConfig config = getServletConfig();
	       String inter = config.getInitParameter("interval");
	       Long interval = 86400000l;
	       if(null != inter)
	    	  interval = Long.parseLong(inter)*60*1000;
	       scheduler.scheduleAtFixedRate(refresh,new Date(),interval);
    	}catch(Exception e){
    		e.printStackTrace();
    	}finally{
    		if((null!=hsession)&&(hsession.isOpen()))
    			hsession.close();
    	}
      }%>
  </body>
</html>
