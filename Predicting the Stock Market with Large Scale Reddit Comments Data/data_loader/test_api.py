import json
import boto3
import time

client = boto3.client('comprehend')

body = []
with open('/home/hadoop/spring2020_10605_project/RC_2007-10', 'r') as json_file:
    lines=json_file.readlines()
    for line in lines:
        json_data = json.loads(line)
        body.append(json_data["body"])
    
for i in range(100):
    start = i*25
    end = (i+1)*25
    t1 = time.time()
    respons = client.batch_detect_sentiment(TextList=body[start:end], LanguageCode='en')
    if i == 0:
        print(respons)
    print(time.time()-t1)
    if len(respons['ErrorList']) != 0:
        print('error')
