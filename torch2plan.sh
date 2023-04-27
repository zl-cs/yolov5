# !/bin/bash

model_list="yolov5n yolov5s yolov5m yolov5n6 yolov5s6 yolov5m6"

for model in $model_list
do
    echo "==================== $model.pt to $model.onnx ===================="
    python3 pt2plan.py --weights $model.pt --include onnx
    echo "==================== $model.onnx to $model.plan ===================="
    /usr/src/tensorrt/bin/trtexec --onnx=$model.onnx --saveEngine=./plan/$model.plan --fp16
done

