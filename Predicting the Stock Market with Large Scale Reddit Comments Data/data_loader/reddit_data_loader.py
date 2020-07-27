import pyspark
import json
import boto3

MIN_THERSHOLD = 11
MAX_THERSHOLD = 5000
data_path = 's3://ml-team15/2015_reddit_comments_corpus/reddit_data/2007/RC_2007-10.bz2'

def filter_patition(chunks):
    filtered = []
    batch = []
    client = boto3.client('comprehend')
    for chunk in chunks:
        json_data = json.loads(chunk)
        if "created_utc" not in json_data or "subreddit" not in json_data or "body" not in json_data:
            continue
        # if not checkEn(json_data["subreddit"]):
        #     filtered.append(json_data["subreddit"])
        #     continue
        # if not checkEn(json_data["body"]):
        #     continue
        if len(json_data["body"]) < MIN_THERSHOLD or len(json_data["body"]) >= MAX_THERSHOLD:
            continue
        batch.append(json_data["body"])
        if len(batch) == 25:
            respond = client.batch_detect_sentiment(TextList=batch, LanguageCode='en')
            if len(respond['ErrorList']) != 0:
                error_index = set()
                for the_error in respond['ErrorList']:
                    error_index.append(the_error['Index'])
                for i in range(25):
                    if i not in error_index:
                        filtered.append((json_data["created_utc"], json_data["subreddit"], \
                            (respond['ResultList'][i]['Sentiment'], respond['ResultList'][i]['SentimentScore'])))
            else:
                for i in range(25):
                    filtered.append((json_data["created_utc"], json_data["subreddit"], \
                        (respond['ResultList'][i]['Sentiment'], respond['ResultList'][i]['SentimentScore'])))

            batch=[]
   
    return filtered

if __name__=="__main__":
    num_cores = 8
    num_partitions = num_cores * 100
    conf = pyspark.SparkConf().setAppName("RedditDataLoder")
    sc = pyspark.SparkContext(conf=conf)

    data = sc.textFile(data_path, minPartitions=num_partitions).mapPartitions(filter_patition)
    lenngths = data.collect()
    print(len(lenngths), ' ', lenngths[:100])
    # data = sc.textFile(data_path, minPartitions=num_partitions)
    # print(data.count())