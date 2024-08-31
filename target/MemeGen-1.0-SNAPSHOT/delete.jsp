<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Meme</title>
</head>
<body>
    <h1>Delete Meme</h1>
    <form method="post" action="deleteMeme">
        <input type="hidden" required="true" name="memeId" value="${meme.getObjectId("_id")}">
        <p>Are you sure you want to delete this meme?</p>
        <p>Title: ${meme.getString("Title")}</p>
        <p>Author: ${meme.getString("Author")}</p>
        <p>URL: ${meme.getString("Url")}</p>
        <p>Subreddit: ${meme.getString("Subreddit")}</p>
        <p>UpVotes: ${meme.getInteger("UpVotes")}</p>
        <!-- Add more meme details if needed -->
        <input type="submit" value="Delete">
    </form>
</body>
</html>
