# !/bin/bash

#python3 -m pip install colored polygraphy --extra-index-url https://pypi.ngc.nvidia.com
export POLYGRAPHY_AUTOINSTALL_DEPS=1  #let polygraphy install missing modules automatically

#model_list="yolov5n yolov5s yolov5m yolov5n6 yolov5s6 yolov5m6"
model_list="yolov8n"

for model in $model_list
do
    echo "==================== $model.pt to $model.onnx ===================="
    python3 pt2plan.py --weights $model.pt --include onnx
    echo "==================== $model.onnx to $model.plan ===================="
    /usr/src/tensorrt/bin/trtexec --onnx=$model.onnx --saveEngine=./plan/$model.plan --fp16
    echo "==================== folding $model.onnx to $model\_folded.onnx ===================="
    polygraphy surgeon sanitize $model.onnx --fold-constants --output $model\_folded.onnx    
    echo "==================== send $model\_folded.onnx to nano-2 ===================="
    scp $model\_folded.onnx nvidia@192.168.0.102:/home/nvidia/software/otherdisk/yolov5
done

