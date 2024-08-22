#!/usr/bin/env bash
#
# usage of this file:
#  ./run.sh --input in.onnx --output out.onnx

input=
output=
bath_dim=N
source ./parse_options.sh

if [ -z $input ]; then
  echo 'Please provide input model filename'
  exit 1
fi

if [ -z $output ]; then
  echo 'Please provide output model filename'
  exit 1
fi

echo "input: $input"
echo "output: $output"

python3 -m onnxruntime.quantization.preprocess --input $input --output tmp.infer.onnx
python3 -m onnxruntime.tools.make_dynamic_shape_fixed --dim_param $batch_dim --dim_value 1 tmp.infer.onnx tmp.infer.fixed.onnx
python3 ./dynamic_quantization.py --input tmp.infer.fixed.onnx --output $output

ls -lh $input tmp.infer.onnx tmp.infer.fixed.onnx $output

rm tmp.infer.onnx tmp.infer.fixed.onnx
