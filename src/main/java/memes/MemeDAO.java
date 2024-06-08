/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package memes;

import MongoConfig.MongoDBConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import java.util.ArrayList;
import java.util.List;

public class MemeDAO {

    private static final MongoDatabase database = MongoDBConnection.getDatabase();
    private static final MongoCollection<Document> collection = database.getCollection("memes");

    public static List<Document> getAllMemes() {
        List<Document> memes = new ArrayList<>();
        collection.find().iterator().forEachRemaining(memes::add);
        
        return memes;
    }

    public static Document getMemeById(String memeId) {
        return collection.find(new Document("_id", new ObjectId(memeId))).first();
    }

    public static boolean updateMeme(String memeId, String title, String author, String url, String subreddit, int upVotes) {
        try {
            Document query = new Document("_id", new ObjectId(memeId));
            Document updatedMeme = new Document("$set", new Document("title", title)
                    .append("Author", author)
                    .append("Url", url)
                    .append("Subreddit", subreddit)
                    .append("UpVotes", upVotes));
            UpdateResult result = collection.updateOne(query, updatedMeme);
            return result.getModifiedCount() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteMeme(String memeId) {
        try {
            Document query = new Document("_id", new ObjectId(memeId));
            DeleteResult result = collection.deleteOne(query);
            return result.getDeletedCount() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
