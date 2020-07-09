<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>

<!DOCTYPE html>
<html>
<title>W3.CSS Template</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-teal.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">




<!-- Header -->
<body class="w3-container w3-theme w3-padding" id="myHeader">




<%//allow access only if session exists
String user = null;
if(session.getAttribute("user") == null){
	response.sendRedirect("login.html");
}
else
{
	user = (String)session.getAttribute("user");
} %>
 
 
 
 
 
 <div class="w3-center">
  <br/><br/><br/>
 <img src="image/green.jpg" class="im" style="background:black;border-radius:50%" height="150" width="150">
  <h2 class="w3-xxxlarge ">PDF Annotator</h2>
  <% out.println(user);%>
  <h4 >Select PDF to upload:</h4><br/>
 
<form action="UploadServlet" method="post"
enctype="multipart/form-data">
<div class="w3-padding-32">
     
<input type="submit" class="w3-btn w3-xlarge w3-theme-dark w3-hover-teal" value="Upload PDF" />
<input type="file" class="w3-btn w3-xlarge w3-theme-dark w3-hover-teal" name="file" size="50" />
<br />

 </div>
  </div>

</form>
</body>
</html>