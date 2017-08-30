<%@ page language="java" session="false" import="info.inetsolv.bean.*" pageEncoding="ISO-8859-1"%>
<%
  HttpSession session = request.getSession(false);
  if(null != session){
	User user = (User)session.getAttribute("user");
	UserRole role = user.getUserRole();
	Long roleId = role.getId(); 
	if(null != roleId){
	 if(roleId.longValue() == 1l){
     %>
     <ul class="menu">
       <li><a href="home" title="It displays the default home page">Home</a></li>
       <li><a href="javascript:void(0);" title="It is used to manage employees">Staff Mgmt</a>
        <ul>
         <li><a href="addEmployee" title="It is used to add a new Employee">Add Employee</a></li>
         <li><a href="viewEmployees" title="It is used to view all Employees">View Employees</a></li>
         <li><a href="searchEmployee" title="It is used to search for an Employee">Search Employee</a></li>
        </ul>
       </li>
	   <li><a href="javascript:void(0);">Room Mgmt</a>
        <ul>
         <li><a href="viewRoomCategories" title="It is used to view Room Categories">Room Categories</a></li>
         <li><a href="viewRoomDetails" title="It is used to view Room Details">Room Details</a></li>
        </ul>
       </li>
       <li><a href="javascript:void(0);" title="It is used to manage employees">Accounts</a>
        <ul>
       	 <li><a href="viewOpBills" title="It is used to view OpBills">View OP Bills</a></li>
       	 <li><a href="viewLabBills" title="It is used to view Lab Bills">View LAB Bills</a></li>
       	 <li><a href="viewIPBills" title="It is used to view IP Bills">View IP Bills</a></li>
       	</ul>
       </li>
       <li><a href="editProfile" title="It is used to edit your own profile">Edit Profile</a></li>
     </ul>
     <%}
	 else if(roleId.longValue() == 2l){
	 %>
	 <ul class="menu">
       <li><a href="home" title="It displays the default home page">Home</a></li>
       <li><a href="javascript:void(0);">Room Mgmt</a>
        <ul>
         <li><a href="viewRoomCategories" title="It is used to view Room Categories">Room Categories</a></li>
         <li><a href="viewRoomDetails" title="It is used to view Room Details">Room Details</a></li>
        </ul>
       </li>
       <li><a href="javascript:void(0);">In Patient</a>
        <ul>
         <li><a href="ipSearchPatient" title="It is used to add/view/change IP Details">Manage IP Details</a></li>
	 <li><a href="roomOccupancy" title="It is used to view Room Occupancy">View IP Details</a></li>
        </ul>
       </li>
       <li>
         <a href="javascript:void(0);">Accounts</a>
         <ul>
          <li><a href="viewOpBills" title="It is used to view OP Bills">View OP Bills</a></li>
          <li><a href="viewLabBills" title="It is used to view Lab Bills">View LAB Bills</a></li>
          <li><a href="viewIPBills" title="It is used to view IP Bills">View IP Bills</a></li>
         </ul>  
       </li>
       <li><a href="editProfile" title="It is used to edit your own profile">Edit Profile</a></li>
     </ul>	 
	 <%}
	 else if(roleId.longValue() == 3l){
     %>
     <ul class="menu">
      <li><a href="home" title="It displays the default home page">Home</a></li>
	  <li><a href="javascript:void(0);">Profiles Mgmt</a>
       <ul>
    	 <li><a href="createTestProfile" title="It is used to create new test profile">Create Test Profile</a></li>
    	 <li><a href="viewTestProfiles" title="It is used to view test profiles">View Test Profiles</a></li>
       </ul>
      </li>
  	  <li><a href="javascript:void(0);">OP Details</a>
	   <ul>
        <li><a href="viewMyOpBills" title="It is used view your OP Bills">View OP Bills</a></li>
        <li><a href="viewMyAppointments" title="It displays your appointments for today">View Appointments</a></li>
	   </ul>
      </li>
      <li><a href="roomOccupancy" title="It is used to view Room Occupancy">View IP Details</a></li>
      <li><a href="editProfile" title="It is used to edit your own profile">Edit Profile</a></li>
     </ul>
     <%}
	 else if(roleId.longValue() == 4l){
     %>
     <ul class="menu">
    	<li><a href="javascript:void(0);">Patient Mgmt</a>
    	 <ul>
    	  <li><a href="registerPatient" title="It is used to register a new patient">Register Patient</a></li>
    	  <li><a href="viewPatients" title="It is used to view patients who registered today">View Patients</a></li>
    	  <li><a href="searchPatient" title="It is used to search for a patient">Search Patient</a></li>
    	 </ul>
    	</li>
    	<li><a href="javascript:void(0);">Out Patient</a>
    	 <ul>
    	  <li><a href="searchPatient" title="It is used to search for a patient">Fix Appointments</a></li>
    	  <li><a href="viewAppointments" title="It is used to view the Appointments">View Appointments</a></li>
    	 </ul>
    	</li>
    	<li><a href="javascript:void(0);">In Patient</a>
    	 <ul>
		  <li><a href="roomOccupancy" title="It is used to view Room Occupancy">View Room Occupancy</a></li>
		  <li><a href="viewRoomDetails" title="It is used to view Room Details">Room Details</a></li>
          <li><a href="ipSearchPatient" title="It is used to add/view/change IP Details">Manage IP Details</a></li>
         </ul>
    	</li>
   	    <li><a href="investigationSearchPatient" title="It is used to add,view,edit investigation">Investigations</a></li>
   	    <li><a href="javascript:void(0);">Accounts</a>
    	 <ul>
    	  <li><a href="viewLabBills" title="It is used to view LabBills">View Lab Bills</a></li>
    	  <li><a href="viewOpBills" title="It is used to view OpBills">View OP Bills</a></li>
    	 </ul>
    	</li>
    	<li><a href="editProfile" title="It is used to edit your own profile">Edit Profile</a></li>
     </ul>
     <%}
	 else if(roleId.longValue() == 5l){
     %>
     <ul class="menu">
    	<li><a href="home">Home</a></li>
    	<li><a href="javascript:void(0);">Tests Mgmt</a>
    	 <ul>
    	  <li><a href="addTest" title="It is used to add lab tests">Add Lab Test</a></li>
    	  <li><a href="viewTests" title="It is used to view lab tests">View Lab Test</a></li>
    	  <li><a href="createTestProfile" title="It is used to create new test profile">Create Test Profile</a></li>
    	  <li><a href="viewTestProfiles" title="It is used to view test profiles">View Test Profiles</a></li>
    	 </ul>
    	</li>
    	<li><a href="investigationSearchPatient" title="It is used to add,view,edit investigation">Investigations</a></li>
        <li><a href="viewLabReports" title="It is used to view Lab Reports">View Reports</a></li>
        <li><a href="viewLabBills" title="It is used to view Lab Bills">View Bills</a></li>
       	<li><a href="editProfile" title="It is used to edit your own profile">Edit Profile</a></li>
     </ul>
     <%}
	}else{
    	out.println("You don't have any assigned role.Contact your administrator for a role.");
     }
  }else{
	 response.sendRedirect("validate");
}%>
