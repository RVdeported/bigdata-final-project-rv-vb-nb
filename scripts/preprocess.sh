#!/bin/bash

echo "Unzipping the data..."

FILE=./data/questdb-query-1683731860412.csv
if [ -f "$FILE" ]
then
    echo "File is unzipped, skipping..."
else
    unzip ./data/binance_btcusdt_5_100.zip -d ./data/
fi



