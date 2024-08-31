<%@page import="org.bson.Document"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Meme List</title>
    </head>
    <body>
        <h1>Meme List</h1>
        <ul>
            <%
            List<Document> memes = (List<Document>) request.getAttribute("memes");
            for (Document meme : memes) {%>
            <li>
                <code><%= meme%></code>
                <h2><%= meme.getString("Title")%></h2>
                <p>Author: <%= meme.getString("Author")%></p>
                <img src="<%= meme.getString("Url")%>" style="width: 10.25rem">
                <!-- Add more meme fields as needed -->
                <form method="post" action="editMeme">
                    <input required="true" type="hidden" name="memeId" value="<%= meme.getObjectId("_id")%>">
                    <input  type="submit" value="Edit">
                </form>
                <form method="post" action="deleteMeme">
                    <input required="true" type="hidden" name="memeId" value="<%= meme.getObjectId("_id")%>">
                    <input type="submit" value="Delete">
                </form>
            </li>
            <% }%>
        </ul>
    </body>
</html>
