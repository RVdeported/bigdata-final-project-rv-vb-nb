\c quant_pr;

DROP TABLE IF EXISTS snapshots;

CREATE TABLE snapshots (
  --  tick_id SERIAL NOT NULL ,
    exchange VARCHAR (50),
    symbol VARCHAR (50) NOT NULL,
    tstamp BIGINT NOT NULL PRIMARY KEY,
    l_tstamp BIGINT NOT NULL,
    
    asks_01_price REAL NOT NULL,
    asks_01_amount INTEGER NOT NULL,
    bids_01_price REAL NOT NULL,
    bids_01_amount INTEGER NOT NULL,
    
    asks_02_price REAL NOT NULL,
    asks_02_amount INTEGER NOT NULL,
    bids_02_price REAL NOT NULL,
    bids_02_amount INTEGER NOT NULL,
    
    asks_03_price REAL NOT NULL,
    asks_03_amount INTEGER NOT NULL,
    bids_03_price REAL NOT NULL,
    bids_03_amount INTEGER NOT NULL,
    
    asks_04_price REAL NOT NULL,
    asks_04_amount INTEGER NOT NULL,
    bids_04_price REAL NOT NULL,
    bids_04_amount INTEGER NOT NULL,
    
    asks_05_price REAL NOT NULL,
    asks_05_amount INTEGER NOT NULL,
    bids_05_price REAL NOT NULL,
    bids_05_amount INTEGER NOT NULL,
    
    asks_06_price REAL NOT NULL,
    asks_06_amount INTEGER NOT NULL,
    bids_06_price REAL NOT NULL,
    bids_06_amount INTEGER NOT NULL,
    
    asks_07_price REAL NOT NULL,
    asks_07_amount INTEGER NOT NULL,
    bids_07_price REAL NOT NULL,
    bids_07_amount INTEGER NOT NULL,
    
    asks_08_price REAL NOT NULL,
    asks_08_amount INTEGER NOT NULL,
    bids_08_price REAL NOT NULL,
    bids_08_amount INTEGER NOT NULL,
    
    asks_09_price REAL NOT NULL,
    asks_09_amount INTEGER NOT NULL,
    bids_09_price REAL NOT NULL,
    bids_09_amount INTEGER NOT NULL,
    
    asks_10_price REAL NOT NULL,
    asks_10_amount INTEGER NOT NULL,
    bids_10_price REAL NOT NULL,
    bids_10_amount INTEGER NOT NULL,
    
    asks_11_price REAL NOT NULL,
    asks_11_amount INTEGER NOT NULL,
    bids_11_price REAL NOT NULL,
    bids_11_amount INTEGER NOT NULL,
    
    asks_12_price REAL NOT NULL,
    asks_12_amount INTEGER NOT NULL,
    bids_12_price REAL NOT NULL,
    bids_12_amount INTEGER NOT NULL,
    
    asks_13_price REAL NOT NULL,
    asks_13_amount INTEGER NOT NULL,
    bids_13_price REAL NOT NULL,
    bids_13_amount INTEGER NOT NULL,
    
    asks_14_price REAL NOT NULL,
    asks_14_amount INTEGER NOT NULL,
    bids_14_price REAL NOT NULL,
    bids_14_amount INTEGER NOT NULL,
    
    asks_15_price REAL NOT NULL,
    asks_15_amount INTEGER NOT NULL,
    bids_15_price REAL NOT NULL,
    bids_15_amount INTEGER NOT NULL,
    
    asks_16_price REAL NOT NULL,
    asks_16_amount INTEGER NOT NULL,
    bids_16_price REAL NOT NULL,
    bids_16_amount INTEGER NOT NULL,
    
    asks_17_price REAL NOT NULL,
    asks_17_amount INTEGER NOT NULL,
    bids_17_price REAL NOT NULL,
    bids_17_amount INTEGER NOT NULL,
    
    asks_18_price REAL NOT NULL,
    asks_18_amount INTEGER NOT NULL,
    bids_18_price REAL NOT NULL,
    bids_18_amount INTEGER NOT NULL,
    
    asks_19_price REAL NOT NULL,
    asks_19_amount INTEGER NOT NULL,
    bids_19_price REAL NOT NULL,
    bids_19_amount INTEGER NOT NULL,
    
    asks_20_price REAL NOT NULL,
    asks_20_amount INTEGER NOT NULL,
    bids_20_price REAL NOT NULL,
    bids_20_amount INTEGER NOT NULL,
    
    asks_21_price REAL NOT NULL,
    asks_21_amount INTEGER NOT NULL,
    bids_21price REAL NOT NULL,
    bids_21_amount INTEGER NOT NULL,
    
    asks_22_price REAL NOT NULL,
    asks_22_amount INTEGER NOT NULL,
    bids_22_price REAL NOT NULL,
    bids_22_amount INTEGER NOT NULL,
    
    asks_23_price REAL NOT NULL,
    asks_23_amount INTEGER NOT NULL,
    bids_23_price REAL NOT NULL,
    bids_23_amount INTEGER NOT NULL,
    
    asks_24_price REAL NOT NULL,
    asks_24_amount INTEGER NOT NULL,
    bids_24_price REAL NOT NULL,
    bids_24_amount INTEGER NOT NULL,
    
    asks_25_price REAL NOT NULL,
    asks_25_amount INTEGER NOT NULL,
    bids_25_price REAL NOT NULL,
    bids_25_amount INTEGER NOT NULL
);

\COPY snapshots FROM 'data/bitmex_book_snapshot_25_2020-09-01_XBTUSD.csv' DELIMITER ',' CSV HEADER;


