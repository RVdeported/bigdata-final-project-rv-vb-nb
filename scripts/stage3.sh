#!/bin/bash

mkdir /project/
hdfs dfs -get \
    /project/snapshots.avsc \
    /project/

spark-submit \
--jars /usr/hdp/current/hive-client/lib/hive-metastore-1.2.1000.2.6.5.0-292.jar,/usr/hdp/current/hive-client/lib/hive-exec-1.2.1000.2.6.5.0-292.jar \
--packages org.apache.spark:spark-avro_2.12:3.0.3 \
scripts/stage3.py &> ./logs


cat /project/output/features_full/* > \
    ./output/features_full.csv
cat /project/output/features_short/* > \
    ./output/features_short.csv
cat /project/output/predictions_gbc/* > \
    ./output/predictions_gbc.csv
cat /project/output/predictions_svc/* > \
    ./output/predictions_svc.csv
cat /project/output/predictions_mpc/* > \
    ./output/predictions_mpc.csv

cp -R /project/models/* ./models/
