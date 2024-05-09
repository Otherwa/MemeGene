<%-- 
    Document   : recommendmemes
    Created on : 09-May-2024, 2:16:22 pm
    Author     : athar
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Recommended Memes</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.css"  rel="stylesheet" />
    </head>
    <body>
        <h1 class="flex items-center text-5xl font-extrabold dark:text-white p-2">Recommended Memes</h1>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 p-2">
            <c:forEach var="meme" items="${redditPosts}">
                <div class="gap-2 p-1 border border-green-300 rounded">
                    <img class="h-80 max-w-full rounded-lg" src="${meme.getUrl()}" alt="${meme.title}">
                    <div class="code p-2">
                    <p class="ms-2 font-semibold text-gray-500 dark:text-gray-400">Author: ${meme.getAuthor()}</p>
                    <p>Title: ${meme.getTitle()}</p>
                    <p>Subreddit: ${meme.getSubreddit()}</p>
                    <p class="bg-green-100 text-green-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-green-400 border border-green-400">UpVotes: ${meme.getUps()}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>
    </body>
</html>