DROP DATABASE IF EXISTS quantdb CASCADE;
CREATE DATABASE quantdb;
USE quantdb;

SET mapreduce.map.output.compress = true;
SET mapreduce.map.output.compress.codec = org.apache.hadoop.io.compress.SnappyCodec;
SET hive.enforce.bucketing=true;

set hive.execution.engine=tez;
set hive.auto.convert.join=true;
set hive.auto.convert.join.noconditionaltask=true;
set hive.auto.convert.join.noconditionaltask.size=105306368;
set hive.vectorized.execution.enabled=true;
set hive.vectorized.execution.reduce.enabled =true;
set hive.cbo.enable=true;
set hive.compute.query.using.stats=true;
set hive.stats.fetch.column.stats=true;
set hive.stats.fetch.partition.stats=true;
set hive.merge.mapfiles =true;
set hive.merge.mapredfiles=true;
set hive.merge.size.per.task=154217728;
set hive.merge.smallfiles.avgsize=144739242;
set mapreduce.job.reduce.slowstart.completedmaps=0.8;

CREATE EXTERNAL TABLE snapshots 
STORED AS AVRO LOCATION '/project/snapshots/' 
TBLPROPERTIES ('avro.schema.url'='/project/snapshots.avsc')
TBLPROPERTIES ('AVRO.COMPRESS'='SNAPPY');

