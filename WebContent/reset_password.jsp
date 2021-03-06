<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="sun.net.smtp.SmtpClient, java.io.*" %>
<%@ page import="java.math.BigInteger, java.security.SecureRandom"%>
<%@ page import="enc.*" %>
<%@ page language="java" import="captchas.CaptchasDotNet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reset password</title>
</head>
<body>
<sql:query var="users" dataSource="jdbc/lut2">
    SELECT email FROM normal_users
    WHERE  email = ? <sql:param value='${param.email}' />
</sql:query>
<c:set var="user" value="${users.rows[0]}"/>
<%!
public String sendPasswordMail (String to, String password)
{
	String from="no-reply@stud.ntnu.no";
	String output;
	 try{
		 //This address only works on telenor and canal digital connections
	     SmtpClient client = new SmtpClient("smtp.online.no");
	     client.from(from);
	     client.to(to);
	     PrintStream message = client.startMessage();
	     message.println("To: " + to);
	     message.println("Subject:  Your new password");
	     message.println("Your new password is: " + password);
	     message.println();     
	     message.println();
	     client.closeServer();
	     output = "Your new password has been sent to your registered email address";
	  }
	  catch (IOException e){	
	     output = "Error while sending new password, contact support";
	  }
	 return output;
}
%>
<%
boolean captchaGood = false;
CaptchasDotNet captchas = new captchas.CaptchasDotNet(
   request.getSession(true),     // Ensure session
  "progsikgr7",                       // client
  "NY0lOO3AAiKZpv1U8cSjEageoQSJoxioVUYOro1e"                      // secret
  );
String password;
if(request.getParameter("password") == null)
{ 
	password = " "; 
}
else
{
	password = request.getParameter("password");
}
String body;
switch (captchas.check(password)) {
   case 's':
     body = "Session seems to be timed out or broken. ";
     body += "Please try again or report error to administrator.";
     break;
   case 'm':
     body = "Every CAPTCHA can only be used once. ";
     body += "The current CAPTCHA has already been used. ";
     body += "Please use back button and reload";
     break;
   case 'w':
     body = "You entered the wrong password. ";
     body += "Please use back button and try again. ";
     break;
   default:
     body = "";
	 captchaGood = true;
     break;
 }
if(captchaGood == false)
{
	out.print(body);
	return;
}
 %>

<%
if(pageContext.getAttribute("user") != null)
{
	if(captchaGood == true)
	{
		SecureRandom r = new SecureRandom();
		String pass = new BigInteger(40, r).toString(32);
		out.print(sendPasswordMail(request.getParameter("email"),pass));
		pass = MD5.hash(pass);
		//out.print(pass);
		pageContext.setAttribute("password", pass);
	}
	else
	{
		out.print(body);
	}
	
}
else
{
	out.print("No user is registered with that email address");	
}

%>
<c:choose>
	<c:when test="${ not empty password }">
		<sql:transaction dataSource="jdbc/lut2">
    		<sql:update var="count">
        		UPDATE normal_users SET pw=? WHERE email=?
        		<sql:param value='${password}' />
        		<sql:param value='${param.email}' />
    		</sql:update>
		</sql:transaction>
	</c:when>
	<c:otherwise>

	</c:otherwise>
</c:choose>
</body>
</html>