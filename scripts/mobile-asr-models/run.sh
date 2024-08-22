#!/usr/bin/env bash

set -ex

curl -SL -O https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20.tar.bz2
tar xvf sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20.tar.bz2
rm sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20.tar.bz2

src=sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20
dst=$src-mobile

mkdir -p $dst

for m in encoder joiner; do
  ./run-impl.sh \
    --input $src/$m-epoch-99-avg-1.onnx
    --output $dst/$m-epoch-99-avg-1.int8.onnx
done

cp -v $src/tokens.txt $dst/
cp -av $src/test_wavs $dst/
cp -v $src/decoder-epoch-99-avg-1.onnx $dst/

rm -rf $src
  cat > $dst/notes.md <<EOF
# Introduction
This model is converted from
https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20.tar.bz2
and it supports only batch size equal to 1.
EOF

ls -lh $dst
