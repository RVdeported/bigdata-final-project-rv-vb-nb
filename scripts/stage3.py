import pyspark.sql.functions as F
from pyspark.sql import SparkSession
from pyspark.ml import Pipeline
from pyspark.sql.window import Window

from pyspark.ml.classification import GBTClassifier, LinearSVC, MultilayerPerceptronClassifier
from pyspark.ml.evaluation import BinaryClassificationEvaluator as BCE
from pyspark.ml.feature import PCA

from pyspark.sql.types import StructType,StructField, StringType, DoubleType
from datetime import datetime

from functools import reduce
from operator import add

spark = SparkSession.builder\
    .appName("BDT Project")\
    .master("local[*]")\
    .config("hive.metastore.uris", "thrift://sandbox-hdp.hortonworks.com:9083")\
    .config("spark.sql.catalogImplementation","hive")\
    .config("spark.sql.avro.compression.codec", "snappy")\
    .config("spark.jars", "file:///usr/hdp/current/hive-client/lib/hive-metastore-1.2.1000.2.6.5.0-292.jar,file:///usr/hdp/current/hive-client/lib/hive-exec-1.2.1000.2.6.5.0-292.jar")\
    .config("spark.jars.packages","org.apache.spark:spark-avro_2.12:3.0.3")\
    .config("spark.driver.memory", "1g")\
    .enableHiveSupport()\
    .getOrCreate()

sc = spark.sparkContext

data = spark.read.format("avro").table('quantdb.snapshots')

#=================definition of constants============

TOTAL_LEVELS = 5
LOOK_FWD = 80


features_for_training = [
    "bid_level_1_price",
    "bid_level_2_price",
    "bid_level_3_price",
    "bid_level_4_price",
    "bid_level_5_price",
    
    "ask_level_1_price",
    "ask_level_2_price",
    "ask_level_3_price",
    "ask_level_4_price",
    "ask_level_5_price",
    
    "bid_level_1_quantity",
    "bid_level_2_quantity",
    "bid_level_3_quantity",
    "bid_level_4_quantity",
    "bid_level_5_quantity",
    
    "ask_level_1_quantity",
    "ask_level_2_quantity",
    "ask_level_3_quantity",
    "ask_level_4_quantity",
    "ask_level_5_quantity",
    ]



#================feature extraction===================


data = spark.read\
    .format("avro")\
    .table('quantdb.snapshots')\
    .sort("tstamp")
    
# data = spark.sql('''SELECT *, ((bid_level_1_price + ask_level_1_price) / 2) as mid_price FROM quantdb.snapshots''')

# generating mid price value
data = data\
    .withColumn(
        "mid_price", 
        (data.bid_level_1_price + data.ask_level_1_price) / 2)
features_for_training.append("mid_price")

# generating price level diffs
for level in range(TOTAL_LEVELS):
    name = "level_{}_diff".format(level+1)
    features_for_training.append(name)
    data = data\
        .withColumn(
            name, 
            (data["ask_level_{}_price".format(level+1)] + data["bid_level_{}_price".format(level+1)]))


# generating diff between subsequent levels for asks and bids
for level in range(TOTAL_LEVELS - 1):  
    name = "ask_level_{}_price - ask_level_{}_price".format(level+2, level+1)
    features_for_training.append(name)
    data = data\
        .withColumn(
            name, 
            (data["ask_level_{}_price".format(level+2)] - data["ask_level_{}_price".format(level+1)]))
    
    name = "bid_level_{}_price - bid_level_{}_price".format(level+1, level+2)
    features_for_training.append(name)
    data = data\
        .withColumn(
            name, 
            (data["bid_level_{}_price".format(level+1)] - data["bid_level_{}_price".format(level+2)]))

    
# generating diff between level 1 price and other levels for bids and asks
for level in range(1, TOTAL_LEVELS):
    name = "ask_level_{}_price - ask_level_1_price".format(level+1)
    features_for_training.append(name)
    data = data\
        .withColumn(
            name, 
            (data["ask_level_{}_price".format(level+1)] - data["ask_level_1_price"]))
    
    name = "bid_level_1_price - bid_level_{}_price".format(level+1)
    features_for_training.append(name)
    data = data\
        .withColumn(
            name, 
            (data["ask_level_{}_price".format(level+1)] - data["ask_level_1_price"]))

# average asks price
data = data\
    .withColumn(
        'avg_asks_price',
        reduce(
            add, [data["ask_level_{}_price".format(level + 1)] for level in range(TOTAL_LEVELS)]
            ) / TOTAL_LEVELS
    )
features_for_training.append('avg_asks_price')

# average asks volume
data = data\
    .withColumn(
        'avg_asks_quantity',
        reduce(
            add, [data["ask_level_{}_quantity".format(level + 1)] for level in range(TOTAL_LEVELS)]
            ) / TOTAL_LEVELS
    )
features_for_training.append('avg_asks_quantity')

# average bids price
data = data\
    .withColumn(
        'avg_bids_price',
        reduce(
            add, [data["bid_level_{}_price".format(level + 1)] for level in range(TOTAL_LEVELS)]
            ) / TOTAL_LEVELS
    )
features_for_training.append('avg_bids_price')

# average bids volume
data = data\
    .withColumn(
        'avg_bids_quantity',
        reduce(
            add, [data["bid_level_{}_quantity".format(level + 1)] for level in range(TOTAL_LEVELS)]
            ) / TOTAL_LEVELS
    )
features_for_training.append('avg_bids_quantity')

# sum of quantity diffs among all levels
data = data\
    .withColumn(
        'level_diff_quantity_sum',
        reduce(
            add, [
                data["ask_level_{}_quantity".format(level + 1)] - 
                data["bid_level_{}_quantity".format(level + 1)
                ] for level in range(TOTAL_LEVELS)]
            )
        )
features_for_training.append('level_diff_quantity_sum')

# sum of price diffs among all levels
data = data\
    .withColumn(
        'level_diff_price_sum',
        reduce(
            add, [
                data["ask_level_{}_price".format(level + 1)] - 
                data["bid_level_{}_price".format(level + 1)
                ] for level in range(TOTAL_LEVELS)]
            )
        )
features_for_training.append('level_diff_price_sum')

# extracting the future moving mean
w = Window.orderBy("tstamp").rowsBetween(1, LOOK_FWD)
data_w_labels = data.withColumn(
    "f_price",
    F.avg(data.mid_price).over(w)
    ).limit(data.count() - LOOK_FWD)

# extracting the price trend label
data_w_labels = data_w_labels.withColumn(
    "label",
    (data_w_labels.mid_price > data_w_labels.f_price)\
        .cast('integer')
    )\
    .drop(data_w_labels.f_price)

w = Window.orderBy("tstamp")
data_w_labels = data_w_labels.withColumn(
    "index",
    F.row_number().over(w)
    )
    
data_w_labels = data_w_labels\
    .where(data_w_labels.index % 3 == 0)


#================Data preprocessing===================
from pyspark.ml import Pipeline
from pyspark.ml.feature import MinMaxScaler, VectorAssembler

split_point = int(data_w_labels.count() * 0.8)
raw_train_data = data_w_labels\
    .where(data_w_labels.index < split_point)
raw_test_data = data_w_labels\
    .where(data_w_labels.index >= split_point)

# (train_data, test_data) = data_w_labels.randomSplit([0.8, 0.2])

assembler = VectorAssembler(inputCols=features_for_training, outputCol= "features")
mmScaler= MinMaxScaler(inputCol = "features", outputCol = "scaled_features")   

pipe = Pipeline(stages = [assembler, mmScaler])

pipe = pipe.fit(raw_train_data)
train_data = pipe.transform(raw_train_data)
test_data = pipe.transform(raw_test_data)


def eval_m(model, train_data, test_data, evaluator):
    start = datetime.now()
    _train_data = model.transform(train_data)
    _test_data = model.transform(test_data)
    print("Predict time:{}".format((datetime.now()-start).total_seconds()))
    out = (evaluator.evaluate(_train_data), evaluator.evaluate(_test_data))
    print("Eval results RP curve train_test: {} / {}".format(
        out[0], 
        out[1])
    )
    return out

#================GBTC training=================
evaluator = BCE(rawPredictionCol='prediction', labelCol='label')
model_gbt = GBTClassifier(
    maxDepth=5, 
    maxMemoryInMB=512,
    maxBins=64,
    stepSize=0.05
)

print("===========gbt eval=================")
start = datetime.now()
model_gbt = model_gbt.fit(train_data)
print("Train time:{}".format((datetime.now()-start).total_seconds()))
scores_gbt = eval_m(model_gbt, train_data, test_data, evaluator)


#===================feature importance save and filter=======================

importance = model_gbt.featureImportances
fi = [(feature, float(val)) for feature, val in zip(features_for_training, importance)]
fi_df = spark.createDataFrame(data=fi, schema=StructType([
     StructField("feature",StringType(),True),
     StructField("value",DoubleType(),True)
    ]))

fi_df.coalesce(1)\
    .select("feature",'value')\
    .write\
    .mode("overwrite")\
    .format("csv")\
    .option("sep", ",")\
    .option("header","true")\
    .csv("/project/output/features_full")
    
features_pca = [n[0] for n in sorted(fi, key=lambda x: x[1], reverse=True)[10:]]
features_main = [n[0] for n in sorted(fi, key=lambda x: x[1], reverse=True)[:10]]

#=================preprocessing with PCA===================
from pyspark.ml.feature import PCA

# train_data = train_data.drop(["features", "raw_pca_features", "scaled_pca_features", "pca_features", "raw_main_features", "scaled_main_features"])

assembler_pca = VectorAssembler(inputCols=features_pca, outputCol= "raw_pca_features")
mmScaler_pca= MinMaxScaler(inputCol = "raw_pca_features", outputCol = "scaled_pca_features")   
pca = PCA(k=2, inputCol="scaled_pca_features", outputCol="pca_features")

assembler_main = VectorAssembler(inputCols=features_main, outputCol= "raw_main_features")
mmScaler_main= MinMaxScaler(inputCol = "raw_main_features", outputCol = "scaled_main_features")

assembler_final = VectorAssembler(inputCols=["scaled_main_features", "pca_features"], outputCol= "features")

pipe = Pipeline(stages = [
    assembler_pca, 
    mmScaler_pca,
    pca,
    assembler_main,
    mmScaler_main,
    assembler_final
    ])

pipe = pipe.fit(raw_train_data)
train_data = pipe.transform(raw_train_data)
test_data = pipe.transform(raw_test_data)

#================GBTC training on PCAed data=================
evaluator = BCE(rawPredictionCol='prediction', labelCol='label')
model_gbt = GBTClassifier(
    maxDepth=5, 
    maxMemoryInMB=512,
    maxBins=64,
    stepSize=0.05
)

print("===========gbt eval=================")
start = datetime.now()
model_gbt = model_gbt.fit(train_data)
print("Train time:{}".format((datetime.now()-start).total_seconds()))
scores_gbt = eval_m(model_gbt, train_data, test_data, evaluator)


#===================saving new feature importance====================

importance = model_gbt.featureImportances
fi = [(feature, float(val)) for feature, val in zip(features_main + ['pca_1', 'pca_2'], importance)]
fi_df = spark.createDataFrame(data=fi, schema=StructType([
     StructField("feature",StringType(),True),
     StructField("value",DoubleType(),True)
    ]))

fi_df.coalesce(1)\
    .select("feature",'value')\
    .write\
    .mode("overwrite")\
    .format("csv")\
    .option("sep", ",")\
    .option("header","true")\
    .csv("/project/output/features_short")
    
#====================SVC training====================

model_svc = LinearSVC(
    featuresCol="features",
    maxIter=30, 
    aggregationDepth=4
)

print("===========vsc eval=================")
start = datetime.now()
model_svc = model_svc.fit(train_data)
print("Train time:{}".format((datetime.now()-start).total_seconds()))
scores_svc = eval_m(model_svc, train_data, test_data, evaluator)

#====================MPC training====================
model_mpc = MultilayerPerceptronClassifier(
    featuresCol="features",
    maxIter=40,
    layers=[len(features_main) + 2, 512,128,2]
)

print("===========mpc eval=================")
start = datetime.now()
model_mpc = model_mpc.fit(train_data)
print("Train time:{}".format((datetime.now()-start).total_seconds()))
scores_mpc = eval_m(model_mpc, train_data, test_data, evaluator)

#================saving the test predictions==================
for model in zip(
        [model_gbt, model_mpc, model_svc],
        ["gbc", "mpc", "svc"]
    ):
    test_data_out=model[0].transform(test_data)
    test_data_out.coalesce(1)\
        .select("tstamp",'mid_price','label','prediction')\
        .write\
        .mode("overwrite")\
        .format("csv")\
        .option("sep", ",")\
        .option("header","true")\
        .csv("/project/output/predictions_{}".format(model[1]))
    model[0].save("/project/models/model_{}".format(model[1]))