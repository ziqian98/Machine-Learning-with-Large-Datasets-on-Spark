#!/bin/bash

URL="https://archive.org/download/2015_reddit_comments_corpus/reddit_data/"
YEAR=2007
BUCKET_NAME="ml-team15"
BUCKET_OBJECT_PRE="2015_reddit_comments_corpus/reddit_data"
TMP_DIR="/data"

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
        echo "it exists"
        aws configure set region us-east-1 --profile default
        aws s3 cp "s3://$BUCKET_NAME/$BUCKET_OBJECT_PRE/$YEAR/RC_$YEAR-$CMONTH.bz2" "$TMP_DIR/RC_$YEAR-$CMONTH.bz2"
        md5sum -c "/home/ubuntu/spring2020_10605_project/infra/md5.txt" --ignore-missing
        if [[ $? -eq 0 ]]; then
            echo "md5sum OK"
            bzip2 -d "$TMP_DIR/RC_$YEAR-$CMONTH.bz2"
            aws s3 cp "$TMP_DIR/RC_$YEAR-$CMONTH" "s3://$BUCKET_NAME/$BUCKET_OBJECT_PRE/$YEAR/RC_$YEAR-$CMONTH"
            rm "$TMP_DIR/RC_$YEAR-$CMONTH"
        else
            echo "s3://$BUCKET_NAME/$BUCKET_OBJECT_PRE/$YEAR/RC_$YEAR-$CMONTH.bz2 is corrupted"
        fi

        let "MONTH++"
    done
    let "YEAR++"
done