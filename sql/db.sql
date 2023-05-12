\c quant_pr;

DROP TABLE IF EXISTS snapshots;

CREATE TABLE IF NOT EXISTS snapshots(
  tstamp TIMESTAMP, 
  last_update_id BIGINT PRIMARY KEY, 

  bid_level_1_price DOUBLE PRECISION, 
  bid_level_2_price DOUBLE PRECISION, 
  bid_level_3_price DOUBLE PRECISION,
  bid_level_4_price DOUBLE PRECISION, 
  bid_level_5_price DOUBLE PRECISION, 

  bid_level_1_quantity DOUBLE PRECISION, 
  bid_level_2_quantity DOUBLE PRECISION, 
  bid_level_3_quantity DOUBLE PRECISION, 
  bid_level_4_quantity DOUBLE PRECISION, 
  bid_level_5_quantity DOUBLE PRECISION, 

  ask_level_1_price DOUBLE PRECISION, 
  ask_level_2_price DOUBLE PRECISION, 
  ask_level_3_price DOUBLE PRECISION, 
  ask_level_4_price DOUBLE PRECISION, 
  ask_level_5_price DOUBLE PRECISION, 

  ask_level_1_quantity DOUBLE PRECISION, 
  ask_level_2_quantity DOUBLE PRECISION, 
  ask_level_3_quantity DOUBLE PRECISION, 
  ask_level_4_quantity DOUBLE PRECISION, 
  ask_level_5_quantity DOUBLE PRECISION
);

\COPY snapshots FROM 'data/questdb-query-1683731860412.csv' DELIMITER ',' CSV HEADER;


