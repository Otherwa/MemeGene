/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package SubRedditer;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import memes.Meme;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author athar
 */
public class MemeScrapper {
    
   public static List<Meme> getRedditmemes() throws IOException {
    String[] apiUrl = {
        "https://meme-api.com/gimme/catmemes/13",
        "https://meme-api.com/gimme/wholesomememes/13",
        "https://meme-api.com/gimme/dankmemes/13",
    };

    Random random = new Random();
    int randomIndex = random.nextInt(apiUrl.length);
    
    // URL object
    URL url;
    url = new URL(apiUrl[randomIndex]);

    // HttpURLConnection
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");

    // response
    InputStream inputStream = conn.getInputStream();
    StringBuilder stringBuilder;
    try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream))) {
        stringBuilder = new StringBuilder();
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            stringBuilder.append(line);
        }
    }
    String jsonResponse = stringBuilder.toString();

    // Parse JSON response
    JSONArray memesArray = new JSONObject(jsonResponse).getJSONArray("memes");

    List<Meme> memeList = new ArrayList<>();
    for (int i = 0; i < memesArray.length(); i++) {
        JSONObject memeObject = memesArray.getJSONObject(i);

        String postLink = memeObject.getString("postLink");
        String subreddit = memeObject.getString("subreddit");
        String title = memeObject.getString("title");
        String urls = memeObject.getString("url");
        boolean nsfw = memeObject.getBoolean("nsfw");
        boolean spoiler = memeObject.getBoolean("spoiler");
        String author = memeObject.getString("author");
        int ups = memeObject.getInt("ups");

        memeList.add(new Meme(postLink, subreddit, title, urls, nsfw, spoiler, author, ups));
    }

    // Close connection
    conn.disconnect();

    return memeList;
}

}
