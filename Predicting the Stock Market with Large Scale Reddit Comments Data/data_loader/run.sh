
PY_SCRIPT="/home/hadoop/spring2020_10605_project/data_loader/reddit_data_loader.py"
SPARK_SUBMIT="spark-submit"
master_url=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`
 #   --master spark://$master_url:7077 \

$SPARK_SUBMIT \
    --conf "spark.eventLog.enabled=true" \
    --conf "spark.memory.fraction=0.8"\
    --conf "spark.memory.storageFraction=0.3" \
    --conf "spark.broadcast.compress=true" \
    --conf "spark.executor.instances=4" \
    --master yarn \
    --deploy-mode client \
    --executor-cores 4 \
    --executor-memory 9g \
    --driver-memory 9g \
    $PY_SCRIPT \
    $1 \
    $2 \
    $3 \
    $4 \
    $5 \
    $6