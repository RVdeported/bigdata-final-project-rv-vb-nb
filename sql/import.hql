DROP DATABASE IF EXISTS quantdb CASCADE;
CREATE DATABASE quantdb;
USE quantdb;

SET mapreduce.map.output.compress = true;
SET mapreduce.map.output.compress.codec = org.apache.hadoop.io.compress.SnappyCodec;
SET hive.enforce.bucketing=true;

SET hive.exec.dynamic.partition = false;
-- SET hive.exec.dynamic.partition.mode = nonstrict;

-- set hive.execution.engine=tez;
-- set hive.auto.convert.join=true;
-- set hive.auto.convert.join.noconditionaltask=true;
-- set hive.auto.convert.join.noconditionaltask.size=105306368;
-- set hive.vectorized.execution.enabled=true;
-- set hive.vectorized.execution.reduce.enabled =true;
-- set hive.cbo.enable=true;
-- set hive.compute.query.using.stats=true;
-- set hive.stats.fetch.column.stats=true;
-- set hive.stats.fetch.partition.stats=true;
-- set hive.merge.mapfiles =true;
-- set hive.merge.mapredfiles=true;
-- set hive.merge.size.per.task=154217728;
-- set hive.merge.smallfiles.avgsize=144739242;
-- set mapreduce.job.reduce.slowstart.completedmaps=0.8;
-- set hive.exec.dynamic.partition.mode=nonstrict;

DROP TABLE IF EXISTS snapshots;
CREATE EXTERNAL TABLE snapshots 
STORED AS AVRO LOCATION '/project/snapshots/' 
TBLPROPERTIES ('avro.schema.url'='/project/snapshots.avsc',
                'AVRO.COMPRESS'='SNAPPY');

-- DROP TAble IF EXISTS snapshots_part_buck;
-- CREATE EXTERNAL TABLE snapshots_part_buck(
--     `timestamp` TIMESTAMP, 
--     last_update_id LONG, 

--   bid_level_1_price FLOAT, 
--   bid_level_2_price FLOAT, 
--   bid_level_3_price FLOAT,
--   bid_level_4_price FLOAT, 
--   bid_level_5_price FLOAT, 

--   bid_level_1_quantity FLOAT, 
--   bid_level_2_quantity FLOAT, 
--   bid_level_3_quantity FLOAT, 
--   bid_level_4_quantity FLOAT, 
--   bid_level_5_quantity FLOAT, 

--   ask_level_1_price FLOAT, 
--   ask_level_2_price FLOAT, 
--   ask_level_3_price FLOAT, 
--   ask_level_4_price FLOAT, 
--   ask_level_5_price FLOAT, 

--   ask_level_1_quantity FLOAT, 
--   ask_level_2_quantity FLOAT, 
--   ask_level_3_quantity FLOAT, 
--   ask_level_4_quantity FLOAT, 
--   ask_level_5_quantity FLOAT
-- ) 
-- PARTITIONED BY (`symbol` varchar(50))
-- CLUSTERED BY (tstamp) into 512 buckets
-- STORED AS AVRO LOCATION '/project/snapshots_part_buck' 
-- TBLPROPERTIES ('AVRO.COMPRESS'='SNAPPY');

-- INSERT INTO snapshots_part_buck PARTITION (`symbol` = 'XBTUSD') 
-- SELECT 
--     --`five_minutes` BIGINT,
--     --`symbol` varchar(50),
--     `exchange`,
--     `tstamp`,
--     l_tstamp ,
    
--     asks_01_price ,
--     asks_01_amount ,
--     bids_01_price ,
--     bids_01_amount  ,
    
--     asks_02_price ,
--     asks_02_amount  ,
--     bids_02_price ,
--     bids_02_amount  ,
    
--     asks_03_price ,
--     asks_03_amount  ,
--     bids_03_price ,
--     bids_03_amount  ,
    
--     asks_04_price ,
--     asks_04_amount  ,
--     bids_04_price ,
--     bids_04_amount  ,
    
--     asks_05_price ,
--     asks_05_amount  ,
--     bids_05_price ,
--     bids_05_amount  ,
    
--     asks_06_price ,
--     asks_06_amount  ,
--     bids_06_price ,
--     bids_06_amount  ,
    
--     asks_07_price ,
--     asks_07_amount  ,
--     bids_07_price ,
--     bids_07_amount  ,
    
--     asks_08_price ,
--     asks_08_amount  ,
--     bids_08_price ,
--     bids_08_amount  ,
    
--     asks_09_price ,
--     asks_09_amount  ,
--     bids_09_price ,
--     bids_09_amount  ,
    
--     asks_10_price ,
--     asks_10_amount  ,
--     bids_10_price ,
--     bids_10_amount  ,
    
--     asks_11_price ,
--     asks_11_amount  ,
--     bids_11_price ,
--     bids_11_amount  ,
    
--     asks_12_price ,
--     asks_12_amount  ,
--     bids_12_price ,
--     bids_12_amount  ,
    
--     asks_13_price ,
--     asks_13_amount  ,
--     bids_13_price ,
--     bids_13_amount  ,
    
--     asks_14_price ,
--     asks_14_amount  ,
--     bids_14_price ,
--     bids_14_amount  ,
    
--     asks_15_price ,
--     asks_15_amount  ,
--     bids_15_price ,
--     bids_15_amount  ,
    
--     asks_16_price ,
--     asks_16_amount  ,
--     bids_16_price ,
--     bids_16_amount  ,
    
--     asks_17_price ,
--     asks_17_amount  ,
--     bids_17_price ,
--     bids_17_amount  ,
    
--     asks_18_price ,
--     asks_18_amount  ,
--     bids_18_price ,
--     bids_18_amount  ,
    
--     asks_19_price ,
--     asks_19_amount  ,
--     bids_19_price ,
--     bids_19_amount  ,
    
--     asks_20_price ,
--     asks_20_amount  ,
--     bids_20_price ,
--     bids_20_amount  ,
    
--     asks_21_price ,
--     asks_21_amount  ,
--     bids_21price ,
--     bids_21_amount  ,
    
--     asks_22_price ,
--     asks_22_amount  ,
--     bids_22_price ,
--     bids_22_amount  ,
    
--     asks_23_price ,
--     asks_23_amount  ,
--     bids_23_price ,
--     bids_23_amount  ,
    
--     asks_24_price ,
--     asks_24_amount  ,
--     bids_24_price ,
--     bids_24_amount  ,
    
--     asks_25_price ,
--     asks_25_amount  ,
--     bids_25_price ,
--     bids_25_amount  
--  FROM snapshots;
