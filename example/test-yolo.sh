#!/bin/bash

DARKNET=${DARKNET:-$(pwd)/darknet}
DARKNET_WEIGHTS="${DARKNET_WEIGHTS:-$(pwd)/yolov3-tiny.weights}"
DARKNET_CONFIG="${DARKNET_CONFIG:-${DARKNET}/cfg/yolov3-tiny.cfg}"
DARKNET_DATA="${DARKNET_DATA:-${DARKNET}/cfg/coco.data}"

if [ ! -s "${DARKNET_WEIGHTS}" ]; then
  echo "Cannot locate weights; file: ${DARKNET_WEIGHTS}" &> /dev/stderr
  exit 1
fi

if [ ! -s "${DARKNET_CONFIG}" ]; then
  echo "Cannot locate config; file: ${DARKNET_CONFIG}" &> /dev/stderr
  exit 1
fi

if [ ! -s "${DARKNET_DATA}" ]; then
  echo "Cannot locate data; file: ${DARKNET_DATA}" &> /dev/stderr
  exit 1
fi

JPEG="${1:-$(pwd)/data/horses.jpg}"
if [ ! -s "${DARKNET}" ]; then
  echo "Cannot locate image; file: ${JPEG}" &> /dev/stderr
  exit 1
fi

./darknet/darknet detector test ${DARKNET_DATA} ${DARKNET_CONFIG} ${DARKNET_WEIGHTS} ${JPEG} -thresh ${threshold:-0.5}
