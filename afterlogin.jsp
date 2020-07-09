<%@ page language="java" import="java.io.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>


<html>
<head>
<style>

body {
  background: #2D3142;

 
  font-family: 'Raleway', sans-serif;
}


/* Heading */

h1 {
  font-size: 1.5em;
  text-align: center;
  padding: 70px 0 0 0;
  color: #EF8354;
  font-weight: 300;
  letter-spacing: 1px;
}

span {
  border: 2px solid #4F5D75;
  padding: 10px;
}


/* Layout Styling */

#container {
  width: 100%;
  margin: 0 auto;
  padding: 50px 0 150px 0;
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: center;
}


/* Button Styles */

.button {
  display: inline-flex;
  height: 40px;
  width: 230px;
  border: 2px solid #BFC0C0;
  margin: 20px 20px 20px 20px;
  color: #BFC0C0;
  text-transform: uppercase;
  text-decoration: none;
  font-size: .8em;
  letter-spacing: 1.5px;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

a {
  color: #BFC0C0;
  text-decoration: none;
  letter-spacing: 1px;
}
/* Second Button */

#button-2 {
  position: relative;
  overflow: hidden;
  cursor: pointer;
}

#button-2 a {
  position: relative;
 
}
/* Third Button */

#button-3 {
  position: relative;
  overflow: hidden;
  cursor: pointer;
}

#button-3 a {
  position: relative;
 
}

/* Fourth Button */

#button-4 {
  position: relative;
  overflow: hidden;
  cursor: pointer;
}

#button-4 a {
  position: relative;
  
}

@media screen and (min-width:1000px) {
  h1 {
    font-size: 2.2em;
  }
  #container {
    width: 50%;
  }
}
</style>

</head>
<body>
<%//allow access only if session exists
String user = null;
if(session.getAttribute("user") == null){
	response.sendRedirect("login.html");
}
else
{
	user = (String)session.getAttribute("user");
} %>
 
<h1><span>PDF Annotator</span></h1>

<!-- Flex Container -->
<div id="container">

 
  <div class="button" id="button-2">
    <div id="slide"></div>
    <a href="option.jsp">Previous Annotated PDF</a>
  </div>

  <div class="button" id="button-3">
    <div id="circle"></div>
    <a href="pdfviewer.jsp">Upload New PDF </a>
  </div>

  <div class="button" id="button-4">
    <div id="underline"></div>
    <a href="login.html">Logout</a>
  </div>

  
  


  <!-- End Container -->
</div>
</body>
</html>