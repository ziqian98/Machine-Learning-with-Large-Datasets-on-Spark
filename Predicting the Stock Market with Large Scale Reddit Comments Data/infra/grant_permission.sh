#!/bin/bash

dir=reddit_senti_
file0=/part-0000
file1=/part-000

for i in $(seq 2007 2015)
do
    aws s3api put-object-acl --bucket ml-team15 --key $dir${i}/_SUCCESS --grant-full-control id="1c7dc07bd01b6fc210e2c2bec4616609943a69caa12bddb1be0b9ab7db7aafa8"
    for j in $(seq 0 9)
    do
        aws s3api put-object-acl --bucket ml-team15 --key $dir$i$file0$j --grant-full-control id="1c7dc07bd01b6fc210e2c2bec4616609943a69caa12bddb1be0b9ab7db7aafa8"
        echo "$dir$i$file0$j"
    done
    for j in $(seq 10 79)
    do
        aws s3api put-object-acl --bucket ml-team15 --key $dir$i$file1$j --grant-full-control id="1c7dc07bd01b6fc210e2c2bec4616609943a69caa12bddb1be0b9ab7db7aafa8"
        echo "$dir$i$file1$j"
    done
done