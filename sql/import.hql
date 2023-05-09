DROP DATABASE IF EXISTS quantdb;
CREATE DATABASE quantdb;
USE quantdb;

SET mapreduce.map.output.compress = true;
SET mapreduce.map.output.compress.codec = org.apache.hadoop.io.compress.SnappyCodec;

