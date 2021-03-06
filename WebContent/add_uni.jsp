<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<%
	String shortname ="";
	if (request.getParameter("shortNameInput") != null) {

		if (request.getParameter("shortNameInput").length() > 20) {
	shortname = request.getParameter("shortNameInput")
	.substring(0, 20).replace('<', ' ')
	.replace('>', ' ');
		} else {
	shortname = request.getParameter("shortNameInput")
	.replace('<', ' ').replace('>', ' ');
		}
	}

	String fullname="";
	if (request.getParameter("fullNameInput") != null) {
		if (request.getParameter("fullNameInput").length() > 20) {
	fullname = request.getParameter("fullNameInput")
	.substring(0, 20).replace('<', ' ')
	.replace('>', ' ');
		} else {
	fullname = request.getParameter("fullNameInput")
	.replace('<', ' ').replace('>', ' ');
		}

	}

	String place = "";
	if (request.getParameter("place") != null) {
		if (request.getParameter("place").length() > 20) {
	place = request.getParameter("place").substring(0, 20)
	.replace('<', ' ').replace('>', ' ');
		} else {
	place = request.getParameter("place").replace('<', ' ')
	.replace('>', ' ');
		}
	}
	int zipParse = 0;
	String zip = "";
	if (request.getParameter("zip") != null) {
		zip="0";
		if (request.getParameter("zip").length() > 20) {
	zip = request.getParameter("zip").substring(0, 20)
			.replace('<', ' ').replace('>', ' ');
		} else {
	zip = request.getParameter("zip").replace('<', ' ')
			.replace('>', ' ');
		}
		zipParse = Integer.parseInt(zip);
	}

	String country = "";
	if (request.getParameter("country") != null) {
		if (request.getParameter("country").length() > 20) {
			country = request.getParameter("country").substring(0, 20)
					.replace('<', ' ').replace('>', ' ');
		} else {
			country = request.getParameter("country").replace('<', ' ')
					.replace('>', ' ');
		}
	}
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        	<% Object username = session.getAttribute("AdminUsername");
   			if(username == null){
       			out.print("<meta http-equiv=\"refresh\" content=\"1;url=./lutadmin.jsp\"> ");
       			return;
   			}
		%>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="refresh" content="3;url=admin_unis.jsp"> 
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>School added NOW!</title>
    </head>
    <body>
        School has been added.<br>
        You will be redirected back to the previous page in a few seconds.
    </tr>
</body>
</html>

<c:choose>
	<c:when
		test="${ ! empty param.shortNameInput || ! empty param.fullNameInput || ! empty param.place || ! empty param.zip || ! empty param.country}">
		<sql:transaction dataSource="jdbc/lut2">
			<sql:update var="count">
        			INSERT INTO school(full_name, short_name, place, zip, country) VALUES (?, ?, ?, ?, ?)
       				<sql:param value='<%=fullname%>' />
				<sql:param value='<%=shortname%>' />
				<sql:param value='<%=place%>' />
				<sql:param value='<%=zipParse%>' />
				<sql:param value='<%=country%>' />
			</sql:update>
		</sql:transaction>
	</c:when>
</c:choose>