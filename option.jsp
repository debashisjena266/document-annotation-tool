<%@ page language="java" import="java.io.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Table V01</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<%//allow access only if session exists
String user = null;
if(session.getAttribute("user") == null){
	response.sendRedirect("login.html");
}
else
{
	user = (String)session.getAttribute("user");
} %>
 
<% 
String file = application.getRealPath("/adt/"+user);
File f = new File(file);
String [] fileNames = f.list();
File [] fileObjects= f.listFiles();
%>
<body>
	<div class="limiter">
		<div class="container-table100">
			<div class="wrap-table100">
				<div class="table100">
					<table>
						<thead>
							<tr class="table100-head">
								<th class="column1">Previously Annotated PDF</th>
								<th class="column1">View</th>
								
							</tr>
						</thead>
						<tbody>
<%
for (int i = 0; i < fileObjects.length; i++) {
if(!fileObjects[i].isDirectory()){
    String fname = file+fileNames[i];
    if(fname.endsWith(".pdf"))
    {
%>
								<tr>
									<td class="column1"><%=fileNames[i]%></td>
									<td class="column2"><a href="PDF3.jsp?filname=<%=fileNames[i]%>">open</a></td>
									
								</tr>
<%
 }}}
%>								
								
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>