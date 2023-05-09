#!/bin/bash

echo "Unzipping the data..."

FILE=./data/bitmex_book_snapshot_25_2020-09-01_XBTUSD.csv
if [ -f "$FILE" ]
then
    echo "File is unzipped, skipping..."
else
    unzip ./data/quant_data.zip -d ./data/
fi



