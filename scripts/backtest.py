import pandas as pd
import numpy as np


STEP = 30
BUY = 1
SELL_R = 0.5
COMMISSION = 0.0001

def backtest():
    df1 = pd.read_csv("/root/bigdata-final-project-rv-vb-nb/output/predictions_mpc.csv")
    assets = 0
    balance = 1000000
    last_price = 0
    required_investments = 0
    actions_done = 0
    last_buys = 0
    last_sells = 0

    out = pd.DataFrame([], 
        columns = [
            "tstamp",
            "balance",
            "action"
        ]
        )

    for i, row in df1.iterrows():
        if i % STEP != 0:
            continue
        
        actions_done+=1
        action = row["prediction"]
        if not action:
            last_sells = 0
            if last_buys > 5:
                assets += BUY
                balance -= BUY * row["mid_price"] * (1.0 + COMMISSION)
            if balance < required_investments:
                required_investments = balance
            last_buys += 1
        elif action:
            last_buys = 0
            if last_sells > 0:
                balance += row["mid_price"] * assets * SELL_R * (1.0 - COMMISSION)
                assets -= assets * SELL_R
            last_sells += 1
        else:
            print("ERROR no action selected")

        last_price = row["mid_price"]

        out = out.append({
            "timestamp" : row["tstamp"],
            "balance" : balance + assets * row["mid_price"] * (1.0 - COMMISSION),
            "action" : action
        }, ignore_index=True)



    # print("actions done {}".format(actions_done))
    # print("rest is {}".format(assets))
    balance += assets * last_price * (1.0-COMMISSION)
    # print(balance, -required_investments, balance / -required_investments)
    # print("{:.3f}%".format(balance / -required_investments * 100 * 5 * 30))
    
    out = out.append({
            "timestamp" : df1.iloc[-1]["tstamp"],
            "balance" : balance,
            "action" : 0
        }, ignore_index=True)
    return out

