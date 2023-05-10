DROP DATABASE IF EXISTS quantdb CASCADE;
CREATE DATABASE quantdb;
USE quantdb;

SET mapreduce.map.output.compress = true;
SET mapreduce.map.output.compress.codec = org.apache.hadoop.io.compress.SnappyCodec;

CREATE EXTERNAL TABLE snapshots 
STORED AS AVRO LOCATION '/project/snapshots/' 
TBLPROPERTIES ('avro.schema.url'='/project/snapshots.avsc');

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
SET hive.enforce.bucketing=true;

set hive.execution.engine=tez;
set hive.auto.convert.join=true;
set hive.auto.convert.join.noconditionaltask=true;
set hive.auto.convert.join.noconditionaltask.size=1005306368;
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

set hive.vectorized.execution.enabled=false;
set hive.vectorized.execution.reduce.enabled=false;

SELECT * from snapshots limit 10;

DROP TAble IF EXISTS snapshots_part_buck;
CREATE EXTERNAL TABLE snapshots_part_buck(
    `exchange` varchar(50),
    `tstamp` BIGINT,
    l_tstamp BIGINT,
    
    asks_01_price DECIMAL(7, 2),
    asks_01_amount INT,
    bids_01_price DECIMAL(7, 2),
    bids_01_amount INT ,
    
    asks_02_price DECIMAL(7, 2),
    asks_02_amount INT ,
    bids_02_price DECIMAL(7, 2),
    bids_02_amount INT ,
    
    asks_03_price DECIMAL(7, 2),
    asks_03_amount INT ,
    bids_03_price DECIMAL(7, 2),
    bids_03_amount INT ,
    
    asks_04_price DECIMAL(7, 2),
    asks_04_amount INT ,
    bids_04_price DECIMAL(7, 2),
    bids_04_amount INT ,
    
    asks_05_price DECIMAL(7, 2),
    asks_05_amount INT ,
    bids_05_price DECIMAL(7, 2),
    bids_05_amount INT ,
    
    asks_06_price DECIMAL(7, 2),
    asks_06_amount INT ,
    bids_06_price DECIMAL(7, 2),
    bids_06_amount INT ,
    
    asks_07_price DECIMAL(7, 2),
    asks_07_amount INT ,
    bids_07_price DECIMAL(7, 2),
    bids_07_amount INT ,
    
    asks_08_price DECIMAL(7, 2),
    asks_08_amount INT ,
    bids_08_price DECIMAL(7, 2),
    bids_08_amount INT ,
    
    asks_09_price DECIMAL(7, 2),
    asks_09_amount INT ,
    bids_09_price DECIMAL(7, 2),
    bids_09_amount INT ,
    
    asks_10_price DECIMAL(7, 2),
    asks_10_amount INT ,
    bids_10_price DECIMAL(7, 2),
    bids_10_amount INT ,
    
    asks_11_price DECIMAL(7, 2),
    asks_11_amount INT ,
    bids_11_price DECIMAL(7, 2),
    bids_11_amount INT ,
    
    asks_12_price DECIMAL(7, 2),
    asks_12_amount INT ,
    bids_12_price DECIMAL(7, 2),
    bids_12_amount INT ,
    
    asks_13_price DECIMAL(7, 2),
    asks_13_amount INT ,
    bids_13_price DECIMAL(7, 2),
    bids_13_amount INT ,
    
    asks_14_price DECIMAL(7, 2),
    asks_14_amount INT ,
    bids_14_price DECIMAL(7, 2),
    bids_14_amount INT ,
    
    asks_15_price DECIMAL(7, 2),
    asks_15_amount INT ,
    bids_15_price DECIMAL(7, 2),
    bids_15_amount INT ,
    
    asks_16_price DECIMAL(7, 2),
    asks_16_amount INT ,
    bids_16_price DECIMAL(7, 2),
    bids_16_amount INT ,
    
    asks_17_price DECIMAL(7, 2),
    asks_17_amount INT ,
    bids_17_price DECIMAL(7, 2),
    bids_17_amount INT ,
    
    asks_18_price DECIMAL(7, 2),
    asks_18_amount INT ,
    bids_18_price DECIMAL(7, 2),
    bids_18_amount INT ,
    
    asks_19_price DECIMAL(7, 2),
    asks_19_amount INT ,
    bids_19_price DECIMAL(7, 2),
    bids_19_amount INT ,
    
    asks_20_price DECIMAL(7, 2),
    asks_20_amount INT ,
    bids_20_price DECIMAL(7, 2),
    bids_20_amount INT ,
    
    asks_21_price DECIMAL(7, 2),
    asks_21_amount INT ,
    bids_21price DECIMAL(7, 2),
    bids_21_amount INT ,
    
    asks_22_price DECIMAL(7, 2),
    asks_22_amount INT ,
    bids_22_price DECIMAL(7, 2),
    bids_22_amount INT ,
    
    asks_23_price DECIMAL(7, 2),
    asks_23_amount INT ,
    bids_23_price DECIMAL(7, 2),
    bids_23_amount INT ,
    
    asks_24_price DECIMAL(7, 2),
    asks_24_amount INT ,
    bids_24_price DECIMAL(7, 2),
    bids_24_amount INT ,
    
    asks_25_price DECIMAL(7, 2),
    asks_25_amount INT ,
    bids_25_price DECIMAL(7, 2),
    bids_25_amount INT 
) 
PARTITIONED BY (tstamp BIGINT) 
CLUSTERED BY (l_tstamp) into 12 buckets
STORED AS AVRO LOCATION '/project/snapshots_part_buck' 
TBLPROPERTIES ('AVRO.COMPRESS'='SNAPPY');

INSERT INTO snapshots_part_buck PARTITION (tstamp) SELECT * FROM snapshots;

