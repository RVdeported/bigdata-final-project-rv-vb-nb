#!/bin/bash

pip install -r ./requirements.txt

su postgres -c "psql -U postgres -c 'DROP DATABASE IF EXISTS quant_pr;'"
su postgres -c "psql -U postgres -c 'CREATE DATABASE quant_pr;'"

echo "Reading data to postgres..."
su postgres -c "psql -U postgres -d quant_pr -f ./sql/db.sql" 

echo "Transffering data to Hadoop"
hdfs dfs -rm -r /project
sqoop import-all-tables -Dmapreduce.job.user.classpath.first=true \
    --connect jdbc:postgresql://0.0.0.0/quant_pr \
    --username postgres \
    --warehouse-dir /project \
    --as-avrodatafile \
    --compression-codec=snappy \
    --outdir /project/avsc \
    --m 12
hdfs dfs -put /project/avsc/snapshots.avsc /project/
rm -rf /project/
