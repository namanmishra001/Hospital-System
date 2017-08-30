<%@ page language="java" session="false" pageEncoding="ISO-8859-1"%>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
String redirectPage = basePath+"login";
response.sendRedirect(redirectPage);
%>
