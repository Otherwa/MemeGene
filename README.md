# Recommended Memes Web Application

This web application displays a collection of memes retrieved from Reddit, along with their metadata such as title, author, subreddit, and upvotes. It uses machine learning models to perform sentiment analysis on the memes and provides an option to download the meme data as a CSV file.

## Technologies Used

- **JSP (JavaServer Pages)**: For server-side rendering of HTML content.
- **JSTL (JSP Standard Tag Library)**: For iteration and conditional logic in JSP.
- **Flowbite**: A UI library for designing responsive web interfaces.
- **ml5.js**: A machine learning library for sentiment analysis.
- **Tesseract.js**: An OCR (Optical Character Recognition) library to extract text from meme images.
- **Java (HttpURLConnection, JSON)**: For backend logic to fetch memes from Reddit using a public API.

## Features

1. **Meme Display**: Displays memes with details like title, author, subreddit, and upvotes.
2. **Sentiment Analysis**: Uses `ml5.js` to analyze the sentiment of meme titles and image text.
3. **OCR Integration**: Uses `Tesseract.js` to extract text from meme images.
4. **Download CSV**: Allows users to download the meme data in CSV format.

## Setup and Installation

### Prerequisites

- Ensure you have a web server that supports JSP, such as Apache Tomcat.
- Java Development Kit (JDK) installed.

### Steps

1. **Clone the repository**:
    ```sh
    git clone <repository-url>
    ```
2. **Navigate to the project directory**:
    ```sh
    cd <project-directory>
    ```
3. **Deploy the project to your web server**:
    - Copy the project files to the webapps directory of your server.
    - Start your server (e.g., `catalina.bat run` for Tomcat on Windows).

## Project Structure

- **index.jsp**: The main JSP file that renders the HTML content.
- **WEB-INF/**: Contains configuration files and libraries.
- **css/**: Contains CSS files for styling.
- **js/**: Contains JavaScript files for client-side functionalities.
- **SubRedditer/**: Contains Java classes for fetching meme data.

## Detailed Explanation

### index.jsp

This is the main JSP file that renders the HTML content using JSTL to iterate over a list of meme objects and display their details.

```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Recommended Memes</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.css"  rel="stylesheet" />
        <!-- ml5 -->
        <script src="https://unpkg.com/ml5@latest/dist/ml5.min.js"></script>
        <!--ORC-->
        <!-- v5 -->
        <script src='https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js'></script>
    </head>
    <body class="p-4">
        <h1 class="flex items-center text-5xl font-extrabold dark:text-white">Recommended Memes</h1>
        <br/>
        <div class="p-4">
            <button class="py-2.5 px-5 me-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700" onclick="convertHTMLToCSVAndDownload()">Download</button>

        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 p-4">           
            <c:forEach var="meme" items="${redditPosts}">
                <div class="gap-2 p-5 border border-green-300 rounded">                    
                    <div class="code p-2">
                        <img class="h-80 max-w-full rounded-lg memeurl" src="${meme.getUrl()}" alt="${meme.title}">
                        <p class="ms-2 font-semibold text-gray-500 dark:text-gray-400 memeauthor">Author: ${meme.getAuthor()}</p>
                        <code class="title memetitle">Title: ${meme.getTitle()}</code>
                        <p class="memesub">Subreddit: ${meme.getSubreddit()}</p>
                        <p class="sentiment"></p>
                        <p class="sentiment-label"></p>
                        <p class="upvotes bg-green-100 text-green-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-green-400 border border-green-400">UpVotes: ${meme.getUps()}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>
        <script type="text/javascript">
                console.log('ml5 version:', ml5.version);

                const sentiment = ml5.sentiment('movieReviews', modelReady);

                function modelReady() {
                    console.log('Model Loaded!');
                    classifyMemes();
                }

                async function classifyMemes() {
                    const memeElements = document.querySelectorAll('.code');
                    console.log(memeElements);

                    // Initialize Tesseract.js worker
                    const worker = await Tesseract.createWorker();
                    await worker.load();
                    await worker.loadLanguage('eng');
                    await worker.initialize('eng');

                    for (const memeElement of memeElements) {
                        // Get the image URL from the meme element
                        const imageURL = memeElement.querySelector('img').src;
                        let text_title = memeElement.querySelector('.title').innerText;
                        text_title = text_title.replace("Title:", "").trim();
                        console.log(imageURL);

                        try {
                            // Perform OCR on the image
                            const {data: {text}} = await worker.recognize(imageURL);
                            console.log("OCR Text:", text_title + " " + text);

                            let prediction = sentiment.predict(text);
                            console.log("Sentiment Prediction:", prediction);

                            const sentimentElement = memeElement.querySelector('.sentiment');
                            sentimentElement.innerText = "Sentiment: " + prediction.score;

                            //upvotes
                            let upvotes = memeElement.querySelector('.upvotes').innerText;
                            upvotes = upvotes.replace('UpVotes:', "").trim()

                            console.log(upvotes)
                            const sentimentLabel = calculateAverageLabel(prediction.score, upvotes);
                            const sentimentLabelElement = memeElement.querySelector('.sentiment-label');
                            sentimentLabelElement.innerText = "Sentiment Label: " + sentimentLabel;
                        } catch (error) {
                            console.error("Error processing meme:", error);
                        }
                    }

                    // Terminate the Tesseract.js worker
                    await worker.terminate();
                }

                // Function to get sentiment label based on score
                function getSentimentLabel(score) {
                    if (score > 0.8) {
                        return "Strongly Positive";
                    } else if (score > 0.6) {
                        return "Positive";
                    } else if (score < 0.3) {
                        return "Strongly Negative";
                    } else if (score < 0.5) {
                        return "Negative";
                    } else {
                        return "Neutral";
                    }
                }

                function getUpvoteLabel(upvotes) {
                    if (upvotes > 150) {
                        return "Highly Upvoted";
                    } else if (upvotes > 100) {
                        return "Moderately Upvoted";
                    } else if (upvotes < 50) {
                        return "Lowly Upvoted";
                    } else {
                        return "Average Upvoted";
                    }
                }

                function calculateAverageLabel(score, upvotes) {
                    const sentimentLabel = getSentimentLabel(score);
                    const upvoteLabel = getUpvoteLabel(upvotes);

                    const scoreMap = {
                        "Strongly Positive & Highly Upvoted": 0.9,
                        "Positive & Moderately Upvoted": 0.7,
                        "Neutral & Average Upvoted": 0.5,
                        "Negative & Lowly Upvoted": 0.3,
                        "Strongly Negative & Lowly Upvoted": 0.1
                    };

                    const fixedScore = scoreMap[sentimentLabel + " & " + upvoteLabel];

                    return (fixedScore !== undefined ? fixedScore : 0.5) + " " + sentimentLabel + " " + upvoteLabel;
                }

                function convertHTMLToCSVAndDownload() {
                    let memeDivs = document.querySelectorAll('.code');

                    // Constructing CSV string
                    let csvContent = `"Title","Author","Url","Subreddit","UpVotes","Sentiment","Sentiment Label"\n`;
                    console.log(memeDivs)

                    memeDivs.forEach(memeDiv => {
                        console.log(memeDiv)
                        let author = memeDiv.querySelector('.memeauthor').innerText;
                        author = author.replace("Author:", "");
                        let title = memeDiv.querySelector('.title').innerText;
                        title = title.replace("Title:", "");
                        let url =

 memeDiv.querySelector('.memeurl').src;
                        let subreddit = memeDiv.querySelector('.memesub').innerText;
                        subreddit = subreddit.replace("Subreddit:", "");
                        let upvotes = memeDiv.querySelector('.upvotes').innerText;
                        upvotes = upvotes.replace("UpVotes:", "");
                        let sentiment = memeDiv.querySelector('.sentiment').innerText;
                        sentiment = sentiment.replace("Sentiment:", "");
                        let sentiment_label = memeDiv.querySelector('.sentiment-label').innerText;
                        sentiment_label = sentiment_label.replace("Sentiment Label:", "");

                        // Append each meme data to CSV content
                        csvContent += `"${title}","${author}","${url}","${subreddit}","${upvotes}","${sentiment}","${sentiment_label}"\n`;
                    });

                    // Creating a Blob with CSV content
                    let blob = new Blob([csvContent], {type: "text/csv"});

                    // Creating an anchor element to trigger the download
                    let a = document.createElement("a");
                    a.href = URL.createObjectURL(blob);
                    a.download = "meme_data.csv";
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                }
        </script>
    </body>
</html>
```

### MemeScrapper.java

The `MemeScrapper` class is responsible for fetching memes from various subreddits using a public meme API. It randomly selects a subreddit API endpoint from a predefined list, sends an HTTP GET request to the selected endpoint, parses the JSON response, and returns a list of `Meme` objects.

```java
package SubRedditer;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import memes.Meme;
import org.json.JSONArray;
import org.json.JSONObject;

public class MemeScrapper {

    public static List<Meme> getRedditmemes() throws IOException {
        String[] apiUrl = {
            "https://meme-api.com/gimme/catmemes/13",
            "https://meme-api.com/gimme/wholesomememes/13",
            "https://meme-api.com/gimme/dankmemes/13",
        };

        Random random = new Random();
        int randomIndex = random.nextInt(apiUrl.length);
        
        URL url = new URL(apiUrl[randomIndex]);

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

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

        conn.disconnect();

        return memeList;
    }
}
```

### Meme.java

The `Meme` class is a simple POJO (Plain Old Java Object) that holds the data for a meme, such as the post link, subreddit, title, URL, NSFW status, spoiler status, author, and upvotes.

```java
package memes;

public class Meme {
    private String postLink;
    private String subreddit;
    private String title;
    private String url;
    private boolean nsfw;
    private boolean spoiler;
    private String author;
    private int ups;

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
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

## Contact

For any questions or feedback, feel free to reach out to the project maintainer.

---
