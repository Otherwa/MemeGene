<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Meme</title>
</head>
<body>
    <h1>Edit Meme</h1>
    <form method="post" action="updateMeme">
        <input type="hidden" name="memeId" value="${meme.getObjectId("_id")}">
        <label for="title">Title:</label>
        <input type="text" id="title" name="title" value="${meme.getString("Title")}">
        <label for="author">Author:</label>
        <input type="text" id="author" name="author" value="${meme.getString("Author")}">
        <label for="url">URL:</label>
        <input type="text" id="url" name="url" value="${meme.getString("Url")}">
        <label for="subreddit">Subreddit:</label>
        <input type="text" id="subreddit" name="subreddit" value="${meme.getString("Subreddit")}">
        <label for="upVotes">UpVotes:</label>
        <input type="text" id="upVotes" name="upVotes" value="${meme.getInteger("UpVotes")}">
        <!-- Add more input fields as needed for editing meme details -->
        <input type="submit" value="Update">
    </form>
</body>
</html>
