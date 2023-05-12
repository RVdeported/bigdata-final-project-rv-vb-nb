import streamlit as st
import pandas as pd
import altair as alt
import numpy as np
from sklearn.metrics import confusion_matrix as cm

# =============Intro===============
st.title("Price trend prediction using the high-frequence Limited Order book data")
st.write("_Nikita Bogomazov, Vyacheslav Blinov, Roman Vetrin_")

st.write('''This section will present the results of Explorational Data Analysis and Predictive Data Analysis.\n
We will illustrate key insights from the data aquired as well as models considers and their results.''')

# ============= EDA - 1 ===============

st.write("# Exploratory Data Analysis")
st.write('''
    Our data represent snapshots from a bitcoin order book downloaded from the Binance exchange for one day.
    The order bool contains a price and volume for each of a 5 levels of all bids and asks at the given timestamp.
    In order to have overall view on the data, we reconstructed the popular "candlestick" chart below:
    ''')

ochl = pd.read_csv("./output/q1.csv")

# st.table(ochl.head())
                                 
base = alt.Chart(ochl).encode(
    alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    color=alt.condition("datum.open <= datum.close",
                        alt.value("#06982d"), alt.value("#ae1325"))
)
rule = base.mark_rule().encode(
    alt.Y('low:Q', 
        title='Price',
        scale=alt.Scale(zero=False)), 
    alt.Y2('high:Q'))
bar = base.mark_bar().encode(alt.Y('open:Q'), alt.Y2('close:Q'))

st.subheader('Plot 1: Reconstructed candlestick chart')
st.altair_chart(rule + bar, use_container_width=True)
st.write('''
    As we may observe, the price changes wichin appx. 5% margin within the day which is quite high comparing to
    less volitile assets. Further we will take a closer look into the order book microstructure. 
    ''')

# ============= EDA - 2 ===============

diffs_df = pd.read_csv("./output/q2.csv")
base_1 = alt.Chart(diffs_df).encode(
    alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    alt.Y("diff_p_lvl1", title="abs diff"),
    color=alt.value("#06982d"),
).mark_line()

base_2 = alt.Chart(diffs_df).encode(
    x = alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    y = alt.Y("diff_p_lvl2", title=""),
    color=alt.value("#ae1325")
).mark_line()

base_3 = alt.Chart(diffs_df).encode(
    x = alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    y = alt.Y("diff_p_lvl3", title="")
).mark_line()

l = alt.layer(base_1, base_2 + base_3).resolve_scale(
    y='independent'
)
st.write('''
    First, we may look into differencies between bid and ask prices on various levels.
    Potentially, huge difference between prices should indicate unpredictability in future mid price which
    we could use as a valuable feature.
    ''')
st.subheader('Plot 2: Difference between price levels 1(green, secondary axis), 2(red) and 3(blue)')
st.altair_chart(l, use_container_width=True)
st.write('''
    The plot above demonstrates that few sudden changes in candlestick graph corresponds to jumps 
    in price difference between bids and asks. Such feature can be useful in the final model.
    ''')

# ============= EDA - 3 ===============

base_1 = alt.Chart(diffs_df).encode(
    alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    alt.Y("diff_q_lvl1", title="abs diff"),
    color=alt.value("#06982d"),
).mark_line()

base_2 = alt.Chart(diffs_df).encode(
    x = alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    y = alt.Y("diff_q_lvl2", title=""),
    color=alt.value("#ae1325")
).mark_line()

base_3 = alt.Chart(diffs_df).encode(
    x = alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    y = alt.Y("diff_q_lvl3", title="")
).mark_line()

l = alt.layer(base_1, base_2 + base_3).resolve_scale(
    y='independent'
)

st.write('''
    Additionally, we can take a look into difference between amount of coin available at each level.
    Shortage of the asset on the first levels should signify a price change in the following periods.
    ''')
st.subheader('Plot 3: Difference between quantity levels 1(green, secondary axis), 2(red) and 3(blue)')
st.altair_chart(l, use_container_width=True)
st.write('''
    As is shown on the plot, some pikes in quantity difference correspond with future highly volitile
    displayed on the Plot 1. Further we used such feature during the model training.
    ''')
# ============= EDA - 4 ===============

vol_df = pd.read_csv("./output/q4.csv")
base_1 = alt.Chart(vol_df).encode(
    alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    alt.Y("volatility", title="volatility"),
    color=alt.value("#06982d"),
).mark_line()

st.write('''
    Next we will take a look into volatility estimation of a given trend. This is one of the parameters to
    which should define the current trend and ensure that it is feasable to divide the timeseries into
    train and test dataset saving the overall trend properties.
    ''')
st.subheader('Plot 4: Volatility value')
st.altair_chart(base_1, use_container_width=True)
st.write('''
    According to the volatility values, it is feasable to divide the trend into the two parts as the
    levels seems overall constant throught the day.
    ''')

# ============= EDA - 5 ===============

m_avg_df = pd.read_csv("./output/q3.csv")
base_1 = alt.Chart(m_avg_df).encode(
    alt.X('timestamp:T', axis=alt.Axis(labelAngle=-45)),
    alt.Y("m_avg", title="moving average", scale=alt.Scale(zero=False)),
    color=alt.value("#06982d"),
).mark_line()

st.write('''
    Our task will be generation of a feature, signifying the ovarall trend direction.
    In order to achieve this, we will predict the moving average value 1s ahead of the given tick and
    output the corresponding binary signal. The overall moving average value is displayed below:
    ''')
st.subheader('Plot 5: Moving average')
st.altair_chart(base_1, use_container_width=True)
st.write('''
    Prediction of the moving average allow us to output useful feature for overall trend direction.
    ''')

# ============= PDA ===============


st.write("# PDA analysis")

st.write('''
    In this section we will take a look into features and aspects related to the model training and evaluation.
    ''')

feat_i = pd.read_csv("./output/features_full.csv")
feat_i['value'] = feat_i['value']
base_1 = alt.Chart(feat_i)\
    .mark_bar()\
    .encode(
        x='feature',
        y='value'
    ).properties(
    height=400
)
st.write('''
    In order to evaluate existing and generated features we trained a Gradient Boosting Classifier Tree
    and extrated information on feature importance. The result is presented below:
    ''')
st.subheader('Plot 6: Feature importance')
st.altair_chart(base_1, use_container_width=True)
st.write('''
    We may observe that a number of proposed features indeed evulated as quite important.
    However, a lot of features seems not to be important for our goals.
    In order to reduce dimensionality, we will extract key vectors from those features via PCA algorithm.
    We selected 10 top features for direct usage and PCAed the rest of features transforming them into
    two dimensions. Then we reevaluated importance of the new features and ended up with the following
    imoprtance distribution:
    ''')

feat_i = pd.read_csv("./output/features_short.csv")
feat_i['value'] = feat_i['value']
base_1 = alt.Chart(feat_i)\
    .mark_bar()\
    .encode(
        x='feature',
        y='value'
    ).properties(
    height=400
)
st.subheader('Plot 7: Feature importance after PCA')
st.altair_chart(base_1, use_container_width=True)
st.write('''
    Thus, we kept the mos important features and combined the rest in the PCA vectors.
    As we may observe from the plot, the first PCA vector should represent an important feature.
    ''')

source = pd.DataFrame({
    "label": ["positive trend", "negative trend"], 
    "count": [163046, 176753]
    })

base_1 = alt.Chart(source)\
    .mark_bar()\
    .encode(
        x='label',
        y='count'
    ).properties(
    height=400
)

st.write('''
    As we transformed our task into the classification problem, it is important to asses label imbalance
    as it may affect the further training process. As demonstrated on the plot below,
    the labels are balanced thus there is limited threat of our metrics' validity.
    ''')
st.subheader('Plot 8: Distribution of labels (test data)')
st.altair_chart(base_1, use_container_width=True)

# ============= Model eval ===============

st.write("# Final model results")
st.write('''
    We evaluated performance of the three models: Gradient Bosting Classifier Tree, Supported Vector Machine and 
    Multilayer Perceptron Classification model. According to our analysis, the Supported Vector machine performed
    better than the other and thus we use this model as the primary one. We used the following
    model parametrs during the training stage:
    ''')
st.subheader('Final model key parametrs')
st.table(pd.DataFrame([
    ['maxIter', 30], 
    ['aggregationDepth', 4], 
    ['tol',1e-04]]
    , columns = ['setting', 'value']))


svc_res = pd.read_csv("./output/predictions_svc.csv")
matrix = cm(
    svc_res["label"].values, 
    svc_res["prediction"].values
    )

matrix = pd.DataFrame(
    {
        "x": [1,0,1,0],
        "y": [1,1,0,0],
        "score":matrix.ravel().astype(np.float32) / svc_res.shape[0]
    }
)
base_1 = alt.Chart(matrix).mark_rect().encode(
    x='x:O',
    y='y:O',
    color='score:Q'
).properties(
    height=400)

text = base_1.mark_text(baseline='middle',fontSize=24).encode(
    alt.Text('score:Q', format=".2f"),
    color=alt.condition(
        alt.datum.score > 0.2,
        alt.value('white'),
        alt.value('black')
    ),
    
)

st.write('''
    Overall we achieved 64 percent of accracy which exceeds the result of a random coin toss.
    As we may observe from the confusion matrix below, we achieved stable result without imbalance in
    recall or precision metrics.
    ''')
st.subheader('Plot 9: Confusion matrix')
st.altair_chart(base_1 + text, use_container_width=True)


