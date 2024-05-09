/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package memes;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author athar
 */
public class MemesLists {
    private List<Meme> memes;

    public MemesLists() {
        memes = new ArrayList<>();
    }

    public void addMeme(String postLink, String subreddit, String title, String url, boolean nsfw, boolean spoiler, String author, int ups) {
        memes.add(new Meme(postLink, subreddit, title, url, nsfw, spoiler, author, ups));
    }

    public List<Meme> getMemes() {
        return memes;
    }
}
