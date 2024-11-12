#!/bin/bash
cargo build --release
NUM_GPUS=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
echo "Detected $NUM_GPUS GPUs."
for i in $(seq 0 $(($NUM_GPUS - 1))); do
  LOG_FILE="crunch$i.log"
  echo "Starting uni-crunch for GPU $i, logging to $LOG_FILE"
  ./target/release/create2crunch \
      0x48E516B34A1274f49457b9C6182097796D0498Cb \
      0x2c8B14A270eb080c2662A12936BB6B2BaBF15BF8 \
      0x94d114296a5af85c1fd2dc039cdaa32f1ed4b0fe0868f02d888bfc91feb645d9 \
      "https://manyzeros.xyz/api/uni?api_key=Ph7U8QfwNz_xfs6VkJG3qgJa7Jmmfb" $i 3 255 \
    > $LOG_FILE 2>&1 &
done
sleep 15
while true; do
  echo "=================================================================="
  for i in $(seq 0 $(($NUM_GPUS - 1))); do
    cat crunch$i.log | tail -5
  done
  sleep 120
done
