<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Recommended Memes</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.css" rel="stylesheet" />
            <!-- ml5 -->
            <script src="https://unpkg.com/ml5@latest/dist/ml5.min.js"></script>
            <!--ORC-->
            <!-- v5 -->
            <script src='https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js'></script>
        </head>

        <body class="p-4">
            <h1 class="flex items-center text-5xl font-extrabold dark:text-white">Recommended Memes</h1>
            <br />
            <div class="p-4">
                <button
                    class="py-2.5 px-5 me-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                    onclick="convertHTMLToCSVAndDownload()">Download</button>

            </div>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 p-4">
                <c:forEach var="meme" items="${redditPosts}">
                    <div class="gap-2 p-5 border border-green-300 rounded">
                        <div class="code p-2">
                            <img class="h-80 max-w-full rounded-lg memeurl" src="${meme.getUrl()}" alt="${meme.title}">
                            <p class="ms-2 font-semibold text-gray-500 dark:text-gray-400 memeauthor">Author:
                                ${meme.getAuthor()}</p>
                            <code class="title memetitle">Title: ${meme.getTitle()}</code>
                            <p class="memesub">Subreddit: ${meme.getSubreddit()}</p>
                            <p class="sentiment"></p>
                            <p class="sentiment-label"></p>
                            <p
                                class="upvotes bg-green-100 text-green-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-green-400 border border-green-400">
                                UpVotes: ${meme.getUps()}</p>
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
                            const { data: { text } } = await worker.recognize(imageURL);
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
                        let url = memeDiv.querySelector('.memeurl').src;
                        let subreddit = memeDiv.querySelector('.memesub').innerText;
                        subreddit = subreddit.replace("Subreddit:", "");
                        let upvotes = memeDiv.querySelector('.upvotes').innerText;
                        upvotes = upvotes.replace("UpVotes:", "")
                        let sentiment = memeDiv.querySelector('.sentiment').innerText;
                        sentiment = sentiment.replace("Sentiment:", "");
                        let sentimentLabel = memeDiv.querySelector('.sentiment-label').innerText;
                        sentimentLabel.replace("Sentiment Label: ", "");

                        csvContent += '"' + title + '","' + author + '","' + url + '","' + subreddit + '",' + upvotes + ',' + sentiment + ',"' + sentimentLabel + '"\n';

                        console.log(csvContent);
                    });


                    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
                    const link = document.createElement("a");
                    if (link.download !== undefined) {
                        const url = URL.createObjectURL(blob);
                        link.setAttribute("href", url);
                        link.setAttribute("download", "downloads");
                        link.style.visibility = 'hidden';
                        document.body.appendChild(link);
                        link.click();
                        document.body.removeChild(link);
                    }
                }



            </script>
        </body>

        </html>