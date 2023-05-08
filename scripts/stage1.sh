#!/bin/bash

su postgres -c "psql -U postgres -c 'DROP DATABASE IF EXISTS quant_pr;'"
su postgres -c "psql -U postgres -c 'CREATE DATABASE quant_pr;'"

echo "Reading data to postgres..."
su postgres -c "psql -U postgres -d quant_pr -f ./sql/db.sql" 
