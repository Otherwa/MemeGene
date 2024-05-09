/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package memes;

/**
 *
 * @author athar
 */
public class Meme {

    private final String postLink;
    private final String subreddit;
    private final String title;
    private final String url;
    private final boolean nsfw;
    private final boolean spoiler;
    private final String author;
    private final int ups;

    
    public Meme(String postLink, String subreddit, String title, String url, boolean nsfw, boolean spoiler, String author, int ups) {
        this.postLink = postLink;
        this.subreddit = subreddit;
        this.title = title;
        this.url = url;
        this.nsfw = nsfw;
        this.spoiler = spoiler;
        this.author = author;
        this.ups = ups;
    }

    public String getPostLink() {
        return postLink;
    }

    public String getSubreddit() {
        return subreddit;
    }

    public String getTitle() {
        return title;
    }

    public String getUrl() {
        return url;
    }

    public boolean isNsfw() {
        return nsfw;
    }

    public boolean isSpoiler() {
        return spoiler;
    }

    public String getAuthor() {
        return author;
    }

    public int getUps() {
        return ups;
    }
}
