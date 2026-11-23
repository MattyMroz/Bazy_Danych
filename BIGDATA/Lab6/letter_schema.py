from pyspark.sql.types import StructType, StructField, StringType, IntegerType

FEATURES = ["x_box", "y_box", "width", "high", "onpix", "x_bar", "y_bar", "x2bar",
            "y2bar", "xybar", "x2ybr", "xy2br", "x_ege", "xegvy", "y_ege", "yegvx"]

schema = StructType([StructField("lettr", StringType(), True)] +
                    [StructField(c, IntegerType(), True) for c in FEATURES])


def load_model(path):
    from pyspark.ml import PipelineModel

    model = PipelineModel.load(path)
    for stage in model.stages:
        for param in list(stage._defaultParamMap):
            if param.name == "pruneTree":
                del stage._defaultParamMap[param]
    return model
