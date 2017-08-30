<%@ page language="java" session="false" import="info.inetsolv.tools.*,info.inetsolv.bean.*,org.hibernate.*,java.util.*" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	Boolean isValid = new Boolean(request.getParameter("valid"));
	String id = request.getParameter("id");
	if(null != id){
	 Session hsession = BeanFactory.getSession();
	 User user = (User)hsession.get(User.class,Long.parseLong(id));
	 DoctorPreferences preferences = user.getPreferences();
	 if(isValid){
		String Name = request.getParameter("Name");
		String PhoneNo = request.getParameter("PhoneNo");
		String Email = request.getParameter("Email");
		String Address = request.getParameter("Address");
		String Qualification = request.getParameter("Qualification");
		String DOJ = request.getParameter("DOJ");
		String DOL = request.getParameter("DOL");
		String role = request.getParameter("Role");
		Long lrole = Long.parseLong(role);
		String OpConsultationFee = request.getParameter("OPConsultationFee");
		String ICUConsultationFee = request.getParameter("ICUConsultationFee");
		String ACConsultationFee = request.getParameter("ACConsultationFee");
		String NonACConsultationFee = request.getParameter("NonACConsultationFee");
		String GWConsultationFee = request.getParameter("GWConsultationFee");
		String ConsultationPeriod = request.getParameter("ConsultationPeriod");
		String Speciality = request.getParameter("Speciality");
		String maxVisits = request.getParameter("MaxVisits");
		Transaction tx = hsession.beginTransaction();
	    user.setName(Name);
	    user.setUserRole(new UserRole(lrole));
	    user.setStatus(false);
	    if((null != PhoneNo)&&!("".equals(PhoneNo)))
	    	user.setPhonenumber(Long.parseLong(PhoneNo));
	    if(null != Email)
	    	user.setEmail(Email);
	    if(null != Address)
	    	user.setAddress(Address);
	    if(null != Qualification)
	    	user.setQualification(Qualification);
	    if((null != DOJ)&&(null != DateUtil.stringToLong(DOJ))){
	    	if(Calendar.getInstance().getTimeInMillis() >= DateUtil.stringToLong(DOJ))
	    		user.setStatus(true);
	    	user.setDoj(DateUtil.stringToLong(DOJ));
	    }
	    if((null != DOL)&&(null != DateUtil.stringToLong(DOL))){
	    	if(Calendar.getInstance().getTimeInMillis() <= DateUtil.stringToLong(DOL))
	    		user.setStatus(false);
	    	user.setDoj(DateUtil.stringToLong(DOJ));
	    }
	    if(null != Speciality)
	    	user.setSpeciality(Speciality);
	    hsession.saveOrUpdate(user);
	    if(lrole == 3){
	    	if(null == preferences)
	    	  preferences = new DoctorPreferences();
	    	preferences.setDoctor(user);
	    	if((null != OpConsultationFee)&&!("".equals(OpConsultationFee)))
	    		preferences.setoPConsultationFee(Long.parseLong(OpConsultationFee));
	    	if((null != ICUConsultationFee)&&!("".equals(ICUConsultationFee)))
	    		preferences.setiCUConsultationFee(Long.parseLong(ICUConsultationFee));
	    	if((null != ACConsultationFee)&&!("".equals(ACConsultationFee)))
	    		preferences.setaCConsultationFee(Long.parseLong(ACConsultationFee));
	    	if((null != NonACConsultationFee)&&!("".equals(NonACConsultationFee)))
	    		preferences.setNonACConsultationFee(Long.parseLong(NonACConsultationFee));
	    	if((null != GWConsultationFee)&&!("".equals(GWConsultationFee)))
	    		preferences.setgWConsultationFee(Long.parseLong(GWConsultationFee));
	    	if((null != ConsultationPeriod)&&!("".equals(ConsultationPeriod)))
	    		preferences.setConsultationPeriod(Long.parseLong(ConsultationPeriod)*24*60*60*1000);
	    	if(null != maxVisits)
	    		preferences.setMaxvisits(Long.parseLong(maxVisits));
		    hsession.save(preferences);
	    }
	    try{
	     tx.commit();
	    }catch(Exception e){
	    	e.printStackTrace();
	    }finally{
	    	hsession.close();
	    }
	    response.sendRedirect("viewEmployees?valid=false&msg=Employee Info Updated Successfully&id="+user.getId());
	}else{	  
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
    <script language="Javascript" src="Scripts/DatePicker.js"></script>
    <script type="text/javascript">
     function showPreferences(){
	   var role = document.getElementById("Role");
	   var opcf1 = document.getElementById("opcf1");
	   var opcf2 = document.getElementById("opcf2");
	   var icucf1 = document.getElementById("icucf1");
	   var icucf2 = document.getElementById("icucf2");
	   var accf1 = document.getElementById("accf1");
	   var accf2 = document.getElementById("accf2");
	   var naccf1 = document.getElementById("naccf1");
	   var naccf2 = document.getElementById("naccf2");
	   var gwcf1 = document.getElementById("gwcf1");
	   var gwcf2 = document.getElementById("gwcf2");
	   var cp1 = document.getElementById("cp1");
	   var cp2 = document.getElementById("cp2");
	   var sp1 = document.getElementById("sp1");
	   var sp2 = document.getElementById("sp2");
	   var mv1 = document.getElementById("mv1");
	   var mv2 = document.getElementById("mv2");
	   if(role.value==3){
		 opcf1.style.display="block";
		 opcf2.style.display="block";
		 icucf1.style.display="block";
		 icucf2.style.display="block";
		 accf1.style.display="block";
		 accf2.style.display="block";
		 naccf1.style.display="block";
		 naccf2.style.display="block";
		 gwcf1.style.display="block";
		 gwcf2.style.display="block";
		 cp1.style.display="block";
		 cp2.style.display="block";
		 sp1.style.display="block";
		 sp2.style.display="block";
		 mv1.style.display="block";
		 mv2.style.display="block";
	   }else{
		 opcf1.style.display="none";
		 opcf2.style.display="none";
		 icucf1.style.display="none";
		 icucf2.style.display="none";
		 accf1.style.display="none";
		 accf2.style.display="none";
		 naccf1.style.display="none";
		 naccf2.style.display="none";
		 gwcf1.style.display="none";
		 gwcf2.style.display="none";
		 cp1.style.display="none";
		 cp2.style.display="none";
		 sp1.style.display="none";
		 sp2.style.display="none";
		 mv1.style.display="none";
		 mv2.style.display="none";
	   }
     }
     function clearForm(){
       var form1 = document.forms.item(0);
	   var opcf1 = document.getElementById("opcf1");
	   var opcf2 = document.getElementById("opcf2");
	   var icucf1 = document.getElementById("icucf1");
	   var icucf2 = document.getElementById("icucf2");
	   var accf1 = document.getElementById("accf1");
	   var accf2 = document.getElementById("accf2");
	   var naccf1 = document.getElementById("naccf1");
	   var naccf2 = document.getElementById("naccf2");
	   var gwcf1 = document.getElementById("gwcf1");
	   var gwcf2 = document.getElementById("gwcf2");
	   var cp1 = document.getElementById("cp1");
	   var cp2 = document.getElementById("cp2");
	   var sp1 = document.getElementById("sp1");
	   var sp2 = document.getElementById("sp2");
	   var mv1 = document.getElementById("mv1");
	   var mv2 = document.getElementById("mv2");
	   opcf1.style.display="none";
	   opcf2.style.display="none";
	   icucf1.style.display="none";
	   icucf2.style.display="none";
	   accf1.style.display="none";
	   accf2.style.display="none";
	   naccf1.style.display="none";
	   naccf2.style.display="none";
	   gwcf1.style.display="none";
	   gwcf2.style.display="none";
	   cp1.style.display="none";
	   cp2.style.display="none";
	   sp1.style.display="none";
	   sp2.style.display="none";
	   mv1.style.display="none";
	   mv2.style.display="none";
       form1.reset();
     }
     function validateForm(){
       var form1 = document.forms.item(0);
       var nm = document.getElementById("Name");
       var email = document.getElementById("Email");
       var doj = document.getElementById("DOJ");
       var role = document.getElementById("Role");
       if(!isEmpty(nm))
    	 if(email.value=='' || validateEmail(email))
    	   if(!isEmpty(doj))
    		if(!isEmpty(role)){
    		   document.getElementById("valid").value = true;	 
    		   form1.submit();
    		}
     }
     </script>
 </head>
 <body class="hd" onload="javascript:settime(); showPreferences();">
   <div class="main">
    <jsp:include page="Head.jsp" />
   </div>
   <jsp:include page="Menu.jsp" />
   <div class="main">
   	 <div align="center" class="header">Edit Employee Data</div>
     <form name="userdata" action="" method="post"> 
 	 <table align="center" class="inputForm" width="860px">
		 <tr>
			<td align="right"><span class='error'>* </span>Name : </td>
			<td align="left"><input type="text" name="Name" id="Name" value="<%=user.getName()%>"/></td>
			<td align="right">Phone Number : </td>
			<td align="left"><input type="text" name="PhoneNo" id="PhoneNo" value="<%=ObjectUtil.formatValue(user.getPhonenumber())%>" onkeypress="return allowNumeric(event)"/></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="NameError" class="error"></div></td>
			<td align="center" colspan="2"><div id="PhoneNoError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td align="right">Email : </td>
		    <td align="left"><input type="text" name="Email" id="Email" value="<%=ObjectUtil.formatValue(user.getEmail())%>"/></td>
		    <td align="right">Address : </td>
		    <td align="left"><textarea name="Address" id="Address" rows="3" cols="16"><%=ObjectUtil.formatValue(user.getAddress())%></textarea></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="EmailError" class="error"></div></td>
			<td align="center" colspan="2"><div id="AddressError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td align="right">Qualification : </td>
		    <td align="left"><input type="text" name="Qualification" id="Qualification" value="<%=ObjectUtil.formatValue(user.getQualification())%>"/></td>
		    <td align="right"><span class='error'>* </span>Date of Joining : </td>
		    <td align="left">
		      <input type="text" name="DOJ" id="DOJ" readonly="readonly" value="<%=DateUtil.formatDate("dd-MM-yyyy",user.getDoj())%>" />
		      <img src="Images/CalDis.gif" alt="Select Date" onmouseover="this.src='Images/CalEn.gif';" onmouseout="this.src='Images/CalDis.gif';" onclick="displayDatePicker('DOJ',false,'dmy','-');"/>
		    </td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="QualificationError" class="error"></div></td>
			<td align="center" colspan="2"><div id="DOJError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td align="right">Date of Leaving : </td>
		    <td align="left">
		      <input type="text" name="DOL" id="DOL" readonly="readonly" value="<%=(user.getDol()!=0l)?DateUtil.formatDate("dd-MM-yyyy",user.getDol()):""%>" />
		      <img src="Images/CalDis.gif" alt="Select Date" onmouseover="this.src='Images/CalEn.gif';" onmouseout="this.src='Images/CalDis.gif';" onclick="displayDatePicker('DOL',false,'dmy','-');"/>
		    </td>
		    <td align="right"><span class='error'>* </span>Role : </td>
			<td align="left">
			  <select name="Role" id="Role" onchange="showPreferences()">
				<option value="">---SELECT---</option>
				<%
				  Session session1 = BeanFactory.getSession();
				  String queryString = "from UserRole order by id";
				  Query q1 = session1.createQuery(queryString);
				  List userRoles = q1.list();
				  if(null!=userRoles && userRoles.size()>0){
					Iterator it = userRoles.iterator();
					while(it.hasNext()){
					 UserRole role = (UserRole)it.next();
				     %>
					  <option value="<%=role.getId()%>" <%=(user.getUserRole().equals(role))?"selected":""%>><%=role.getRole()%></option>
				   <%}
				  }
				 %>
			  </select>
			</td>
		 </tr>
		 <tr>
			<td colspan="2"></td>
			<td align="center" colspan="2"><div id="RoleError" class="error"></div></td>
		 </tr>
		 <tr>
			<td align="right"><span id="opcf1" style="display:none">Consultation Fee :</span></td>
			<td><span id="opcf2" style="display:none"><input type="text" name="OPConsultationFee" id="OPConsultationFee" value="<%=(null!=preferences)?preferences.getoPConsultationFee():""%>" onkeypress="return allowNumeric(event);"/></span></td>
			<td align="right"><span id="cp1" style="display:none">Consultation Period(in days) :</span></td>
			<td><span id="cp2" style="display:none"><input type="text" name="ConsultationPeriod" id="ConsultationPeriod" value="<%=(null!=preferences)?preferences.getConsultationPeriod()/86400000:""%>" onkeypress=" return allowNumeric(event);"/></span></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="OPConsultationFeeError" class="error"></div></td>
			<td align="center" colspan="2"><div id="ConsultationPeriodError" class="error"></div></td>
		 </tr>
		 <tr>
			<td align="right"><span id="sp1" style="display:none" >Speciality :</span></td>
			<td><span id="sp2" style="display:none" ><input type="text" name="Speciality" id="Speciality"  value="<%=ObjectUtil.formatValue(user.getSpeciality())%>"/></span></td>
			<td align="right"><span id="mv1" style="display:none" >Max Visits :</span></td>
			<td>
			  <span id="mv2" style="display:none" >
			   <select name="MaxVisits" id="MaxVisits">
			   	 <option value="0">--select--</option>
			   	 <option value="1" <%=(null != preferences)?(preferences.getMaxvisits()==1l)?"selected":"":""%>>1</option>
			   	 <option value="2" <%=(null != preferences)?(preferences.getMaxvisits()==2l)?"selected":"":""%>>2</option>
			   	 <option value="3" <%=(null != preferences)?(preferences.getMaxvisits()==3l)?"selected":"":""%>>3</option>
			   	 <option value="4" <%=(null != preferences)?(preferences.getMaxvisits()==4l)?"selected":"":""%>>4</option>
			   	 <option value="5" <%=(null != preferences)?(preferences.getMaxvisits()==5l)?"selected":"":""%>>5</option>
			   </select>
			  </span>
			</td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="SpecialityError" class="error"></div></td>
			<td align="center" colspan="2"><div id="MaxVisitsError" class="error"></div></td>
		 </tr>
		 <tr>
			<td align="right"><span id="icucf1" style="display:none">IP ICU Consultation Fee :</span></td>
			<td><span id="icucf2" style="display:none"><input type="text" name="ICUConsultationFee" id="ICUConsultationFee" value="<%=(null!=preferences)?preferences.getiCUConsultationFee():""%>" onkeypress="return allowNumeric(event)"/></span></td>
			<td align="right"><span id="accf1" style="display:none">IP AC Consultation Fee :</span></td>
			<td><span id="accf2" style="display:none"><input type="text" name="ACConsultationFee" id="ACConsultationFee" value="<%=(null!=preferences)?preferences.getaCConsultationFee():""%>" onkeypress="return allowNumeric(event)"/></span></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="ICUConsultationFeeError" class="error"></div></td>
			<td align="center" colspan="2"><div id="ACConsultationFeeError" class="error"></div></td>
		 </tr>
		 <tr>
			<td align="right"><span id="naccf1" style="display:none">IP Non-AC Consultation Fee :</span></td>
			<td><span id="naccf2" style="display:none"><input type="text" name="NonACConsultationFee" id="NonACConsultationFee" value="<%=(null!=preferences)?preferences.getNonACConsultationFee():""%>" onkeypress="return allowNumeric(event)"/></span></td>
			<td align="right"><span id="gwcf1" style="display:none">IP General Ward Consultation Fee :</span></td>
			<td><span id="gwcf2" style="display:none"><input type="text" name="GWConsultationFee" id="GWConsultationFee" value="<%=(null!=preferences)?preferences.getgWConsultationFee():""%>" onkeypress="return allowNumeric(event)"/></span></td>
		 </tr>
		 <tr>
			<td align="center" colspan="2"><div id="NonACConsultationFeeError" class="error"></div></td>
			<td align="center" colspan="2"><div id="GWConsultationFeeError" class="error"></div></td>
		 </tr>
		 <tr>
		    <td colspan="2" align="center"><input type="button" name="ok" id="ok" value="   UPDATE  " onclick="validateForm();" /></td>
			<td colspan="2" align="center"><input type="button" name="cancel" id="cancel" value="  CLEAR " onclick="clearForm();"/></td>
		 </tr>
		 <tr>
		    <td colspan="4"></td>
		 </tr>
 	 </table>
 	 <input type="hidden" id="valid" name="valid" value="false"/>
     </form>
   </div>
 </body>
 <%}
	 }else{
		 response.sendRedirect("viewEmployees");
	 }
  }else{
	 response.sendRedirect("validate");
  }%>
</html>
