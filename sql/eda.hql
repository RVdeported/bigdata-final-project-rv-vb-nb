USE quantdb;

DROP VIEW IF EXISTS time_aggr_mid_p;
CREATE VIEW IF NOT EXISTS time_aggr_mid_p
AS SELECT 
    floor((tstamp - 1598918402683390) / 1000000) as seconds,
    floor((tstamp - 1598918402683390) / 60000000) as `minutes`,
    floor((tstamp - 1598918402683390) / 300000000) as five_minutes,
    (asks_01_price + bids_01_price) / 2 as mid_price,
    *
FROM snapshots_part_buck
ORDER BY tstamp DESC;

SELECT 
    five_minutes,
    MAX(mid_price)          OVER (PARTITION BY five_minutes ORDER BY tstamp) AS `max`,
    MIN(mid_price)          OVER (PARTITION BY five_minutes ORDER BY tstamp) AS `min`
FROM time_aggr_mid_p;

-- SELECT five_minutes, AVG(mid_price)
-- FROM time_aggr_mid_p
-- GROUP BY five_minutes;