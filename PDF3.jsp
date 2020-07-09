<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" type="text/css" href="shared/toolbar.css"/>
  <link rel="stylesheet" type="text/css" href="shared/pdf_viewer.css"/>
   <!-- installs jquery and ajax. -->
    
  <title>PDF and rect 11</title>
  <style>
	select option:checked 
	{
        background: linear-gradient(#d6d6d6, #d6d6d6);
        background-color: transparent !important; /* for IE */
        color: transparent !important;
    }
	select::-ms-expand 
	{
    display: none;
	}
    #canvas_container 
	{
		margin-top:10px;
        width: device-width;
        height: 580px ;
        overflow: auto;
    }
	#canvas_container 
	{
		background: #333;
		text-align: center;
		border: solid 3px;
		body 
		{
		  background-color: #eee;
		  font-family: sans-serif;
		  margin: 0;
		}
	}
	
</style>
</head>
<body onload="init()" style="background-color:white;height:device-height;">
<%-- <%//allow access only if session exists
 String user = null;
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
	
}  %> --%>

 

<%--  <h3>hi<%=path %></h3>
  <h2>hi<%=path_text %></h2> --%>
 
	<div class="toolbar">
		<button class="cursor" type="button" title="Cursor" data-tooltype="cursor">➚</button>
		<div class="spacer"></div>
		<button class="rectangle" type="button" title="Rectangle" data-tooltype="area">&nbsp;</button>
		<button class="highlight" type="button" title="Highlight" data-tooltype="highlight" id="#66ffff" onclick="color(this)">&	;</button>
		<button class="strikeout" type="button" title="Strikeout" data-tooltype="strikeout">&nbsp;</button>
		<div class="spacer"></div>
		<button class="text" type="button" title="Text Tool" data-tooltype="text"></button>
		<div class="text-color"></div>
		<div class="spacer"></div>
		<button class="pen" type="button" title="Pen Tool" data-tooltype="draw" onclick="change(1)">&#10004;</button>
		<button class="pen" type="button" title="Pen Tool" data-tooltype="draw" onclick="change(2)">&#10060;</button>
		<button class="pen" type="button" title="Pen Tool" data-tooltype="draw" onclick="save()">save</button>
		<button class="pen" type="button" title="Pen Tool" data-tooltype="draw" onclick="readAnn()">load</button>
		<div class="spacer"></div>
		<button class="pen" type="button" title="Pen" data-tooltype="draw" onclick="change(3)">&#x270E;</button>


		<button class="highlight1" type="button" title="pen color" data-tooltype="highlight" id="red"     onclick="color(this)">&	;</button>
		<button class="highlight6" type="button" title="pen color" data-tooltype="highlight" id="#ff9900" onclick="color(this)">&	;</button>
		<button class="highlight2" type="button" title="pen color" data-tooltype="highlight" id="yellow"  onclick="color(this)">&	;</button>
		<button class="highlight3" type="button" title="pen color" data-tooltype="highlight" id="#00ff00" onclick="color(this)">&	;</button>
		<button class="highlight5" type="button" title="pen color" data-tooltype="highlight" id="blue"    onclick="color(this)">&	;</button>
		<button class="highlight4" type="button" title="pen color" data-tooltype="highlight" id="black"   onclick="color(this)">&	;</button>
	
		<div class="spacer"></div>

		<button class="comment" type="button" title="Comment" data-tooltype="point">🗨</button>
		<div class="spacer"></div>
		
	</div>

	<div id="my_pdf_viewer">
	
		<!CANVAS>
		<div id="canvas_container" >
			
				<canvas id="pdf_renderer" style="z-index: 1; position:relative; top:0px; left:0px;">canvas not supported</canvas>
				<img 	id="annimg"		  style="z-index: 2; position:relative; top:0px; left:0px; visibility: hidden;">
				<canvas id="annotation"   style="z-index: 3; position:relative; top:0px; left:0px;" onclick="showCoords(event)">canvas not supported</canvas>
		</div>

		<!BOTTOM TOOLBAR>
		<div id="navigation_controls">
			<button id="go_previous"> ⯇ </button>
			<input  id="current_page" value="1" type="number"/>
			<button id="go_next"> ⯈ </button>
			<button id="zoom_in"> ➕ </button>
			<button id="zoom_out"> ➖ </button>
			
		</div>	
	</div>
	
	
	

	
	<script src="./pdfjs-dist-master/build/pdf.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
    
    
    
   
	<script>
	
		var user = '<%= (String) (session.getAttribute("user")) %>';
		//alert(somestr);
		var filname = '<%= (String) (request.getParameter("filname")) %>';
		var dir = './adt/';
		//String filePath12 = finalpath.substring(0,(finalpath.length)-4)+'.txt';
		var finalpath = dir+user+'/'+filname;
		alert(finalpath);
		var anim = document.getElementById("annimg");//annotation canvas
		var c = document.getElementById("annotation");//annotation canvas
		var ctd = c.getContext("2d");//.....
		var canvasp = document.getElementById("pdf_renderer");
		var ctx = canvasp.getContext('2d');	
		//store properties of PDF page
		var myState = {
			pdf: null,
			currentPage: 1,
			zoom: 1
		}
		
		var canvas,cti, flag = false,prevX = 0,currX = 0,prevY = 0,currY = 0,dot_flag = false,t_flag = 0;
		var x = "black",y = 2;
		var dataURL = new Array();
		dataURL[0]="000";
		var symbol=0;
		
		<%-- var path1= '<%= path %>'; --%>
		/* alert(path1); */
		
		
		//SELECT PDF
		pdfjsLib.getDocument(finalpath).then((pdf) => {
		//pdfjsLib.getDocument(filePath+'.pdf').then((pdf) => {
			myState.pdf = pdf;
			render(); 
		});

	
		
		function init() 
		{
			
			//readAnn();
			canvas = document.getElementById('annotation');
			cti = canvas.getContext("2d");
			//w = canvas.width;
			//h = canvas.height;
		
			canvas.addEventListener("mousemove", function (e) {
				findxy('move', e)
			}, false);
			canvas.addEventListener("mousedown", function (e) {
				findxy('down', e)
			}, false);
			canvas.addEventListener("mouseup", function (e) {
				findxy('up', e)
			}, false);
			canvas.addEventListener("mouseout", function (e) {
				findxy('out', e)
			}, false);
		}
		
		function color(obj) 
		{
			x=obj.id;
			if (x == "#66ffff") 
				y = 14;
			else 
				y = 2;
		
		}
		
		function draw() 
		{
			
			cti.beginPath();
			cti.moveTo(prevX, prevY);
			cti.lineTo(currX, currY);
			cti.strokeStyle = x;
			cti.lineWidth = y;
			cti.stroke();
			cti.closePath();
		}
		
		function findxy(res, e) 
		{
			if(symbol!=3)
				return;
			if (res == 'down') 
			{
				prevX = currX;
				prevY = currY;
				currX = e.clientX - canvas.offsetLeft;
				currY = e.clientY - canvas.offsetTop + document.getElementById('canvas_container').scrollTop + document.body.scrollTop;
		
				flag = true;
				dot_flag = true;
				if (dot_flag) 
				{
					cti.beginPath();
					cti.fillStyle = x;
					cti.fillRect(currX, currY, 2, 2);
					cti.closePath();
					dot_flag = false;
				}
			}
			if (res == 'up' || res == "out") 
			{
				t_flag = 1;
				flag = false;
			}
			if (res == 'move') 
			{
				if (flag) 
				{
					prevX = currX;
					prevY = currY;
					currX = e.clientX - canvas.offsetLeft;
					currY = e.clientY - canvas.offsetTop + document.getElementById('canvas_container').scrollTop + document.body.scrollTop;
					draw();
				}
			}
		}
		
		
		
		
		// 				********RENDER*******
		function render() 
		{
			myState.pdf.getPage(myState.currentPage).then((page) => {
				
				var viewport = page.getViewport(myState.zoom);
				canvasp.width = viewport.width;
				
			//	dataURL[myState.currentPage] = c.toDataURL();
				anim.src = dataURL[myState.currentPage];
				
				canvasp.height = viewport.height;
				c.width = viewport.width;
				c.height = viewport.height;
				anim.width = viewport.width;
				anim.height = viewport.height;
		
				
				
				c.style.marginLeft= "-"+(c.width+6)+"px";
				anim.style.marginLeft= "-"+(c.width+6)+"px";
				ctd.drawImage(anim, 0, 0,canvasp.width,canvasp.height);
				page.render({
					canvasContext: ctx,
					viewport: viewport
				});
			});
		}
			
		//CURRENT PAGE		
		document.getElementById('current_page').addEventListener('keypress', (e) => {
				if(myState.pdf == null) 
					return;
				// Get key code
				var code = (e.keyCode ? e.keyCode : e.which);
				// If key code matches that of the Enter key
				if(code == 13) 
				{
					var desiredPage =parseInt(document.getElementById('current_page').value, 10);
					if(desiredPage<1)
						desiredPage=1;
					else if(desiredPage>myState.pdf._pdfInfo.numPages)
						desiredPage=myState.pdf._pdfInfo.numPages;
					dataURL[myState.currentPage] = c.toDataURL();
					myState.currentPage = desiredPage;
					anim.src = dataURL[myState.currentPage];
					document.getElementById("current_page").value = desiredPage;
					render();
				}
			});
			
			
		//PREV. PAGE
		document.getElementById('go_previous').addEventListener('click', (e) => {
					if(myState.pdf == null || myState.currentPage == 1) 
						return;
					dataURL[myState.currentPage] = c.toDataURL();
					myState.currentPage -= 1;
					anim.src = dataURL[myState.currentPage];
					document.getElementById("current_page").value = myState.currentPage;
					render();
				});
				
				
		//NEXT PAGE		
		document.getElementById('go_next').addEventListener('click', (e) => {
					if(myState.pdf == null || myState.currentPage > myState.pdf._pdfInfo.numPages) 
					   return;
					dataURL[myState.currentPage] = c.toDataURL();
					myState.currentPage += 1;
			    	//alert(dataURL);//sdfhshdcuh
					anim.src = dataURL[myState.currentPage];
					document.getElementById("current_page").value = myState.currentPage;
					render();
				});
			
		//ZOOM IN
		document.getElementById('zoom_in').addEventListener('click', (e) => {
					if(myState.pdf == null) 
						return;
					if(myState.zoom <= 1.6)
					{
						if(t_flag == 1)
						{
							dataURL[myState.currentPage] = c.toDataURL();
							anim.src = dataURL[myState.currentPage];
							t_flag=0;
						}
						myState.zoom += 0.1;
					}
					render();
				});
							
		//ZOOM OUT	
		document.getElementById('zoom_out').addEventListener('click', (e) => {
					if(myState.pdf == null) 
						return;
					if(myState.zoom >= 0.8)
					{	
						if(t_flag == 1)
						{
							dataURL[myState.currentPage] = c.toDataURL();
							anim.src = dataURL[myState.currentPage];
							t_flag=0;
						}
						myState.zoom -= 0.1;
					}
					render();
				});
		

		
		function showCoords(event) 
		{
			
			rect=c.getBoundingClientRect();
			var x = event.clientX-rect.left;
			var y = event.clientY-rect.top;
			ctd.font = "15px Arial";
			if(symbol==2)
				ctd.fillText(String.fromCharCode(10060),x-10,y+7);
			if(symbol==1)
				ctd.fillText(String.fromCharCode(10004),x-10,y+2);
		}
		
		
	
    	function readAnn()
		{
			var filePath12 = finalpath.substring(0,(finalpath.length)-4)+'.txt';
			alert(filePath12);
			$.get(filePath12,function(data){
				dataURL=JSON.parse(data);
				anim.src=dataURL[mystate.currentPage];
				render();
			},"text");
			
		}

		function change(x)
		{
			symbol=(symbol==x)? 0:x ;
			//alert(canvas.offsetTop + document.getElementById('canvas_container').scrollTop);
		}
		function save()
		{
			dataURL[myState.currentPage] = c.toDataURL();
			 $(function(){
     var arr = JSON.stringify(dataURL);
    // dataURL=JSON.parse(arr);
      //  alert(arr);
        $.ajax({
            url: "MyServlet1",
            type: "POST",
            data: {
                myArray : arr
            }
        }).done(function(data,text,jQxhr){
       alert("success");
      
    }).fail(function(){
    	alert("Failed");
    });
});
			}
	</script>
</body>
</html>


















