##
## makefile
##

PWD := $(shell pwd)
DARKNET := ${PWD}/darknet

DARKNET_TINYV2_WEIGHTS := ${PWD}/darknet/yolov2-tiny-voc.weights
DARKNET_TINYV2_CONFIG := ${DARKNET}/cfg/yolov2-tiny-voc.cfg
DARKNET_TINYV2_DATA := ${DARKNET}/cfg/voc.data
DARKNET_TINYV2_WEIGHTS_URL := http://pjreddie.com/media/files/yolov2-tiny-voc.weights
DARKNET_TINYV2_WEIGHTS_MD5 := fca33deaff44dec1750a34df42d2807e

DARKNET_TINYV3_WEIGHTS := ${PWD}/darknet/yolov3-tiny.weights
DARKNET_TINYV3_CONFIG := ${DARKNET}/cfg/yolov3-tiny.cfg
DARKNET_TINYV3_DATA := ${DARKNET}/cfg/coco.data
DARKNET_TINYV3_WEIGHTS_URL := http://pjreddie.com/media/files/yolov3-tiny.weights
DARKNET_TINYV3_WEIGHTS_MD5 := 3bcd6b390912c18924b46b26a9e7ff53

DARKNET_V2_WEIGHTS := ${PWD}/darknet/yolov2.weights
DARKNET_V2_CONFIG := ${DARKNET}/cfg/yolov2.cfg
DARKNET_V2_DATA := ${DARKNET}/cfg/coco.data
DARKNET_V2_WEIGHTS_URL := https://pjreddie.com/media/files/yolov2.weights
DARKNET_V2_WEIGHTS_MD5 := 70d89ba2e180739a1c700a9ff238e354

DARKNET_V3_WEIGHTS := ${PWD}/darknet/yolov3.weights
DARKNET_V3_CONFIG := ${DARKNET}/cfg/yolov3.cfg
DARKNET_V3_DATA := ${DARKNET}/cfg/coco.data
DARKNET_V3_WEIGHTS_URL := https://pjreddie.com/media/files/yolov3.weights
DARKNET_V3_WEIGHTS_MD5 := c84e5b99d0e52cd466ae710cadf6d84c

default: all

all: build test

build:
	make -C darknet

${DARKNET_TINYV2_WEIGHTS}: 
	@echo "Downloading: $@ ..."
	curl -sSL ${DARKNET_TINYV2_WEIGHTS_URL} -o $@

${DARKNET_TINYV3_WEIGHTS}: 
	@echo "Downloading: $@ ..."
	curl -sSL ${DARKNET_TINYV3_WEIGHTS_URL} -o $@

${DARKNET_V2_WEIGHTS}: 
	@echo "Downloading: $@ ..."
	curl -sSL ${DARKNET_V2_WEIGHTS_URL} -o $@

${DARKNET_V3_WEIGHTS}: 
	@echo "Downloading: $@ ..."
	curl -sSL ${DARKNET_V3_WEIGHTS_URL} -o $@

test: test-tinyv2 test-tinyv3 test-v2 test-v3

test-tinyv2: ${DARKNET_TINYV2_WEIGHTS}
	export \
	  DARKNET_WEIGHTS=${DARKNET_TINYV2_WEIGHTS} \
	  DARKNET_CONFIG=${DARKNET_TINYV2_CONFIG} \
	  DARKNET_DATA=${DARKNET_TINYV2_DATA} \
	  && \
	  ./example/test-yolo.sh

test-tinyv3: ${DARKNET_TINYV3_WEIGHTS}
	export \
	  DARKNET_WEIGHTS=${DARKNET_TINYV3_WEIGHTS} \
	  DARKNET_CONFIG=${DARKNET_TINYV3_CONFIG} \
	  DARKNET_DATA=${DARKNET_TINYV3_DATA} \
	  && \
	  ./example/test-yolo.sh

test-v2: ${DARKNET_V2_WEIGHTS}
	export \
	  DARKNET_WEIGHTS=${DARKNET_V2_WEIGHTS} \
	  DARKNET_CONFIG=${DARKNET_V2_CONFIG} \
	  DARKNET_DATA=${DARKNET_V2_DATA} \
	  && \
	  ./example/test-yolo.sh

test-v3: ${DARKNET_V3_WEIGHTS}
	export \
	  DARKNET_WEIGHTS=${DARKNET_V3_WEIGHTS} \
	  DARKNET_CONFIG=${DARKNET_V3_CONFIG} \
	  DARKNET_DATA=${DARKNET_V3_DATA} \
	  && \
	  ./example/test-yolo.sh

.PHONY: test-v2 test-v3 test-v2 test-v3
