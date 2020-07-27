# Predicting the Stock Market with Large Scale Reddit Comments Data 

## Datasets
- [Complete Public Reddit Comments Corpus (150GB compressed)](https://archive.org/details/2015_reddit_comments_corpus)
- [Huge Stock Market Dataset](https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stocks-etfs)
- [SentiWordNet 3.0](https://github.com/aesuli/sentiwordnet)
## EC2 Access
### Enviorment
- Python 3.6
- Java 8
- Spark 2.4.5
- Scala 2.11
- jupyter-notebook 6.0.3
### Log into EC2
```shell
ssh -i <private_key_path> ubuntu@ec2-54-161-173-79.compute-1.amazonaws.com
```
### EC2 Conda enviornment
```shell
conda activate 10605
```
### Log into Jupyter Notebook
```shell
ssh -i <your_private_key> -L 8888:localhost:8888 ubuntu@ec2-54-161-173-79.compute-1.amazonaws.com
```
Then open your browser and go to localhost:8888. The password is 10605.

## S3 Access

```shell
sudo apt install awscli
# Copy keys to ~/.aws/credenticals
aws configure # Set default region to us-east-1
aws s3api list-buckets # Tell ruobing your ID

aws s3 ls s3://ml-team15
```

## Help with download
```shell
git clone https://github.com/fangzhouxie/spring2020_10605_project.git

sudo apt update
sudo apt -y install awscli
mkdir ~/.aws
vim ~/.aws/credentials
# MUST DO IT! Copy credentials from the webpage.

# If you first help with download, do the following block otherwise skip it
aws configure # Set default region to us-east-1, format to json
aws s3api list-buckets # Tell ruobing your ID

# Download 12 datasets from 2012/01 to 2012/12, the four parameters are 2012 1 2013 1 (2013 1 is exclusive and REMEMBER NOT TO USE SOMETHING LIKE 01 JUST USE 1)
./spring2020_10605_project/infra/get-datasets.sh START_YEAR START_MONTH END_YEAR END_MONTH 
```
