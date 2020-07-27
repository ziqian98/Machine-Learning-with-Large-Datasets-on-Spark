#!/bin/bash
input="/home/ubuntu/.aws/credentials"
access_key="aws_access_key_id=(.+)"
secret_key="aws_secret_access_key=([*]+)"
session_token="aws_session_token=([*]+)"
while read -r; do
    if [[ $REPLY =~ $access_key ]]; then
        export AWS_ACCESS_KEY_ID=${BASH_REMATCH[1]}
        echo $AWS_ACCESS_KEY_ID
    elif [[ $REPLY =~ $secret_key ]]; then
        export AWS_SECRET_ACCESS_KEY=${BASH_REMATCH[1]}
    elif [[ $REPLY =~ $session_token ]]; then
        export AWS_SECURITY_TOKEN=${BASH_REMATCH[1]}
    fi
done < "$input"