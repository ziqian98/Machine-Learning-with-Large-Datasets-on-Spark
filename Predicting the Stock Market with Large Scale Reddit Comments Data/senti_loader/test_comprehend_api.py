import boto3
import time

client = boto3.client('comprehend')

list_of_sentence=[]
with open('tune.tsv', 'r') as textfile:
    lines = textfile.readlines()
    for line in lines:
        list_of_sentence.append(line.replace('\'', ''))

time_takes = []
for i in range(200):
    start=i*25
    end = (i+1)*25
    t = time.time()
    return_dict = client.batch_detect_sentiment(TextList=list_of_sentence[start:end], LanguageCode='en')
    end = time.time()
    time_takes.append(end-t)
    if i % 50 == 0:
        print(return_dict)

print('mean ', sum(time_takes)/len(time_takes))