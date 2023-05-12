USE quantdb;

DROP VIEW IF EXISTS binance_btcusdt_5_100_timestamp_extract;
CREATE VIEW binance_btcusdt_5_100_timestamp_extract AS
SELECT 
	from_unixtime(BIGINT(tstamp / 1000)) as tstamp_f,
	day(from_unixtime(BIGINT(tstamp / 1000))) AS day,
	month(from_unixtime(BIGINT(tstamp / 1000))) AS month,
	year(from_unixtime(BIGINT(tstamp / 1000))) AS year,
	hour(from_unixtime(BIGINT(tstamp / 1000))) AS hour,
	minute(from_unixtime(BIGINT(tstamp / 1000))) AS minute,
   floor(minute(from_unixtime(BIGINT(tstamp / 1000))) / 20) AS twenty_minute,
	second(from_unixtime(BIGINT(tstamp / 1000))) AS second,
   (bid_level_1_price + ask_level_1_price) / 2 AS mid_price,
	*
  FROM 
  	snapshots;

INSERT OVERWRITE LOCAL DIRECTORY '/root/q1'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
SELECT DISTINCT
   first_value(tstamp_f) OVER w AS tstamp_f,
	max(mid_price) OVER w AS High,
   min(mid_price) OVER w AS Low,
   first_value(mid_price) OVER w AS `Open`,
   last_value(mid_price) OVER w AS `Close`
FROM binance_btcusdt_5_100_timestamp_extract
  WINDOW w AS (PARTITION BY 
			   binance_btcusdt_5_100_timestamp_extract.day, 
			   binance_btcusdt_5_100_timestamp_extract.month, 
			   binance_btcusdt_5_100_timestamp_extract.year, 
			   binance_btcusdt_5_100_timestamp_extract.hour, 
			   binance_btcusdt_5_100_timestamp_extract.twenty_minute
			  );

INSERT OVERWRITE LOCAL DIRECTORY '/root/q2'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
SELECT 
   min(tstamp_f),
   avg(ask_level_1_price - bid_level_1_price) AS diff_p_lvl1,
   avg(ask_level_2_price - bid_level_2_price) AS diff_p_lvl2,
   avg(ask_level_3_price - bid_level_3_price) AS diff_p_lvl3,
   avg(ask_level_4_price - bid_level_4_price) AS diff_p_lvl4,
   avg(ask_level_5_price - bid_level_5_price) AS diff_p_lvl5,
   avg(abs(bid_level_1_quantity - ask_level_1_quantity)) AS diff_q_lvl1,
   avg(abs(bid_level_2_quantity - ask_level_2_quantity)) AS diff_q_lvl2,
   avg(abs(bid_level_3_quantity - ask_level_3_quantity)) AS diff_q_lvl3,
   avg(abs(bid_level_4_quantity - ask_level_4_quantity)) AS diff_q_lvl4,
   avg(abs(bid_level_5_quantity - ask_level_5_quantity)) AS diff_q_lvl5
FROM binance_btcusdt_5_100_timestamp_extract
GROUP BY
	binance_btcusdt_5_100_timestamp_extract.day, 
	binance_btcusdt_5_100_timestamp_extract.month, 
	binance_btcusdt_5_100_timestamp_extract.year, 
	binance_btcusdt_5_100_timestamp_extract.hour, 
	binance_btcusdt_5_100_timestamp_extract.twenty_minute;


DROP VIEW IF EXISTS moving_avg;
CREATE VIEW moving_avg AS
SELECT
   tstamp_f,
   AVG(mid_price) OVER w AS m_avg,
   binance_btcusdt_5_100_timestamp_extract.day AS day,
   binance_btcusdt_5_100_timestamp_extract.month AS month,
   binance_btcusdt_5_100_timestamp_extract.year AS year,
   binance_btcusdt_5_100_timestamp_extract.hour AS hour,
   binance_btcusdt_5_100_timestamp_extract.minute AS minute,
   binance_btcusdt_5_100_timestamp_extract.twenty_minute AS twenty_minute
FROM binance_btcusdt_5_100_timestamp_extract
WINDOW w AS (ORDER BY tstamp_f ROWS BETWEEN 1 FOLLOWING AND 10 FOLLOWING);

INSERT OVERWRITE LOCAL DIRECTORY '/root/q3'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
SELECT 
	MAX(tstamp_f),
	AVG(m_avg) 
FROM moving_avg
GROUP BY 
	year,
	month,
	day,
	hour,
	twenty_minute;


INSERT OVERWRITE LOCAL DIRECTORY '/root/q4'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
SELECT 
	MAX(tstamp_f),
	STDDEV(mid_price) 
FROM binance_btcusdt_5_100_timestamp_extract
GROUP BY 
	year,
	month,
	day,
	hour,
	twenty_minute;
