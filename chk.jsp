<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<% String user = null;
String path = null;
String path_text = null;
if(session.getAttribute("user") == null){
	response.sendRedirect("login.html");

}
else
{
	user = (String)session.getAttribute("user");
	path = (String)session.getAttribute("path");
	path_text = (String)session.getAttribute("path_text");
	
}
 %>
 <% out.println(path);%>

</body>
</html>