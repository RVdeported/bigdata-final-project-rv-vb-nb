#!/bin/bash

hive -f ./sql/import.hql
hive -f ./sql/eda.hql

echo "timestamp,\
high,\
low,\
open,\
close"\
 > ./output/q1.csv

cat /root/q1/* >> ./output/q1.csv

echo "timestamp,\
diff_p_lvl1,\
diff_p_lvl2,\
diff_p_lvl3,\
diff_p_lvl4,\
diff_p_lvl5,\
diff_q_lvl1,\
diff_q_lvl2,\
diff_q_lvl3,\
diff_q_lvl4,\
diff_q_lvl5"\
 > ./output/q2.csv

cat /root/q2/* >> ./output/q2.csv

echo "timestamp,\
m_avg"\
 > ./output/q3.csv

 cat /root/q3/* >> ./output/q3.csv

echo "timestamp,\
volatility"\
 > ./output/q4.csv

 cat /root/q4/* >> ./output/q4.csv

