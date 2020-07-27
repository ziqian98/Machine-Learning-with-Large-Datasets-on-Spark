#!/bin/bash

LOCAL_GO="/home/ubuntu/go/bin/"
URL="https://archive.org/download/2015_reddit_comments_corpus/reddit_data/"
YEAR=2007
BUCKET_NAME="ml-team15"
BUCKET_OBJECT_PRE="2015_reddit_comments_corpus/reddit_data"
export GO15VENDOREXPERIMENT=1
export GOPATH="/home/ubuntu/go"

mkdir $GOPATH
sudo apt update
sudo apt -y install golang-go
go get github.com/rlmcpherson/s3gof3r/gof3r

# Setup Keys from ~/.aws/credentials
input="/home/ubuntu/.aws/credentials"
access_key="aws_access_key_id=(.+)"
secret_key="aws_secret_access_key=(.+)"
session_token="aws_session_token=(.+)"
while read -r; do
    if [[ $REPLY =~ $access_key ]]; then
        export AWS_ACCESS_KEY_ID=${BASH_REMATCH[1]}
    elif [[ $REPLY =~ $secret_key ]]; then
        export AWS_SECRET_ACCESS_KEY=${BASH_REMATCH[1]}
    elif [[ $REPLY =~ $session_token ]]; then
        export AWS_SECURITY_TOKEN=${BASH_REMATCH[1]}
    fi
done < "$input"

s3_file_size() {
    if command -v aws &> /dev/null; then
        echo "$(aws s3 ls "${1}" --summarize | grep "Total.*Size" | grep -o -E '[0-9]+')"
    fi
}

s3_does_file_exist() {
    if command -v aws &> /dev/null; then
        [[ $(s3_file_size "${1}") -lt 1 ]] && return 0 || return 1
    else
        echo "Warn-${FUNCNAME[0]}, AWS command missing."
        return 1
    fi
}

if [ "$1" != "" ]; then
    START_YEAR=$1
    START_MONTH=$2
    END_YEAR=$3
    END_MONTH=$4
else
    START_YEAR=2007
    START_MONTH=10
    END_YEAR=2015
    END_MONTH=6
fi

YEAR=$START_YEAR

while [ $YEAR -lt $(( $END_YEAR+1 )) ]; do
    MONTH=1
    while [ $MONTH -lt 13 ]; do
        if [ $YEAR -eq $START_YEAR ] && [ $MONTH -eq 1 ]; then
            MONTH=$START_MONTH
        fi

        if [ $YEAR -eq $END_YEAR ] && [ $MONTH -eq $END_MONTH ]; then
            break
        fi

        if [ $MONTH -lt 10 ]; then
            CMONTH="0$MONTH"
        else
            CMONTH="$MONTH"
        fi
        echo "GET $URL$YEAR/RC_$YEAR-$CMONTH.bz2"
        s3_does_file_exist "s3://$BUCKET_NAME/$BUCKET_OBJECT_PRE/$YEAR/RC_$YEAR-$CMONTH.bz2"
        if [[ $? -lt 1 ]]; then
            echo "it does not exist in s3, try download"
            if [ "$5" == "local" ]; then
                curl -L "$URL$YEAR/RC_$YEAR-$CMONTH.bz2" -o "/tmp/RC_$YEAR-$CMONTH.bz2"
                aws configure set region us-east-1 --profile default
                aws s3 cp "/tmp/RC_$YEAR-$CMONTH.bz2" "s3://$BUCKET_NAME/$BUCKET_OBJECT_PRE/$YEAR/RC_$YEAR-$CMONTH.bz2"
            else
                curl -L "$URL$YEAR/RC_$YEAR-$CMONTH.bz2" | "${LOCAL_GO}gof3r" put -b $BUCKET_NAME -k "$BUCKET_OBJECT_PRE/$YEAR/RC_$YEAR-$CMONTH.bz2"
            fi
        else
            echo "it exists"
        fi

        let "MONTH++"
    done
    let "YEAR++"
done
