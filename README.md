# &#128064; `openyolo` - Object detection and classification
This repository is a fork of the [primary repository](http://github.com/pjreddie/darknet) with minor modifications to run on Raspian Buster and Ubuntu 18+ with OpenCV. The [Open Horizon](http://github.com/dcmartin/open-horizon) _service_ [`yolo`](http://github.com/dcmartin/open-horizon/tree/master/yolo/README.md)  utilizes this repository to build Docker containers.  Please refer to the [Dockerfile](http://github.com/dcmartin/open-horizon/tree/master/yolo/Dockerfile) for details.

## About
OpenYOLO is an open source *object detection and classification* library written in C with bindings in Python.  The library analyzes images and video streams to identify objects and classify them according to a dictionary of eighty (80) entities.

## Installation
Outside of use in building the [`yolo`](http://github.com/dcmartin/open-horizon/tree/master/yolo/README.md) _service_, run `make` in the top-level directory to build the `darknet/` directory as well as test each version (`tiny-v2`,`tiny-v3`,`v2`,`v3`); for example (_edited for length_):

```
% git clone http://github.com/dcmartin/openyolo
% cd openyolo
% export DARKNET=$(pwd)/darknet
% make
make -C darknet
... lots of lines deleted ...
```

## Usage
Weights for the neural network must be downloaded and made available in the local filesystem; the weights files may be downloaded from the original source:

+ `tiny`, `tiny-v2` - [`http://pjreddie.com/media/files/yolov2-tiny-voc.weights`](http://pjreddie.com/media/files/yolov2-tiny-voc.weights)
+ `tiny-v3` - [`http://pjreddie.com/media/files/yolov3-tiny.weights`](http://pjreddie.com/media/files/yolov3-tiny.weights)
+ `v2` - [`https://pjreddie.com/media/files/yolov2.weights`](https://pjreddie.com/media/files/yolov2.weights)
+ `v3` - [`https://pjreddie.com/media/files/yolov3.weights`](https://pjreddie.com/media/files/yolov3.weights)

The weights should be downloaded and stored in the top-level directory; for example:

```
curl -sSL -o ${DARKNET}/yolov2-tiny-voc.weights http://pjreddie.com/media/files/yolov2-tiny-voc.weights
```

## Testing
When the `make` command completes (successfully), test the build; for example:

```
% export \
	  DARKNET_WEIGHTS=${OPENYOLO}/yolov2-tiny-voc.weights \
	  DARKNET_CONFIG=${DARKNET}/cfg/yolov2-tiny-voc.cfg \
	  DARKNET_DATA=${DARKNET}/cfg/voc.data \
	  && \
	  ./example/test-yolo.sh
layer     filters    size              input                output
    0 conv     16  3 x 3 / 1   416 x 416 x   3   ->   416 x 416 x  16  0.150 BFLOPs
    1 max          2 x 2 / 2   416 x 416 x  16   ->   208 x 208 x  16
    2 conv     32  3 x 3 / 1   208 x 208 x  16   ->   208 x 208 x  32  0.399 BFLOPs
    3 max          2 x 2 / 2   208 x 208 x  32   ->   104 x 104 x  32
    4 conv     64  3 x 3 / 1   104 x 104 x  32   ->   104 x 104 x  64  0.399 BFLOPs
    5 max          2 x 2 / 2   104 x 104 x  64   ->    52 x  52 x  64
    6 conv    128  3 x 3 / 1    52 x  52 x  64   ->    52 x  52 x 128  0.399 BFLOPs
    7 max          2 x 2 / 2    52 x  52 x 128   ->    26 x  26 x 128
    8 conv    256  3 x 3 / 1    26 x  26 x 128   ->    26 x  26 x 256  0.399 BFLOPs
    9 max          2 x 2 / 2    26 x  26 x 256   ->    13 x  13 x 256
   10 conv    512  3 x 3 / 1    13 x  13 x 256   ->    13 x  13 x 512  0.399 BFLOPs
   11 max          2 x 2 / 1    13 x  13 x 512   ->    13 x  13 x 512
   12 conv   1024  3 x 3 / 1    13 x  13 x 512   ->    13 x  13 x1024  1.595 BFLOPs
   13 conv   1024  3 x 3 / 1    13 x  13 x1024   ->    13 x  13 x1024  3.190 BFLOPs
   14 conv    125  1 x 1 / 1    13 x  13 x1024   ->    13 x  13 x 125  0.043 BFLOPs
   15 detection
mask_scale: Using default '1.000000'
Loading weights from /Volumes/dcmartin/GIT/openyolo/yolov2-tiny-voc.weights...Done!
/Volumes/dcmartin/GIT/openyolo/data/horses.jpg: Predicted in 0.865594 seconds.
cow: 75%
```

## `detector.py` script
OpenYOLO includes the Python script [`example/detector.py`](example/detector.py) to run the `YOLO` algorithm on a specified image; options may be specified for a variety of needs.  The Python script takes three arguments (n.b. two and three are optional):

 + `<JPEG file>`- JPEG image file to process
 + `<config>` - may be `tiny-v2`, `tiny-v3`, `v2`, or `v3`; default: `tiny-v2` (**optional**)
 + `#.##` - minimum value for a positive match; range: [0.0,1.0]; default: `0.25` (**optional**)

## Example
After successfully building the `darknet` executable  use the Python script [detector.py](example/detector.py) to detect entities in the original image; for example:

```
% ./example/detector.py example/horses.jpg | tee example/horses.json | jq '.'
layer     filters    size              input                output
    0 conv     16  3 x 3 / 1   416 x 416 x   3   ->   416 x 416 x  16  0.150 BFLOPs
    1 max          2 x 2 / 2   416 x 416 x  16   ->   208 x 208 x  16
    2 conv     32  3 x 3 / 1   208 x 208 x  16   ->   208 x 208 x  32  0.399 BFLOPs
    3 max          2 x 2 / 2   208 x 208 x  32   ->   104 x 104 x  32
    4 conv     64  3 x 3 / 1   104 x 104 x  32   ->   104 x 104 x  64  0.399 BFLOPs
    5 max          2 x 2 / 2   104 x 104 x  64   ->    52 x  52 x  64
    6 conv    128  3 x 3 / 1    52 x  52 x  64   ->    52 x  52 x 128  0.399 BFLOPs
    7 max          2 x 2 / 2    52 x  52 x 128   ->    26 x  26 x 128
    8 conv    256  3 x 3 / 1    26 x  26 x 128   ->    26 x  26 x 256  0.399 BFLOPs
    9 max          2 x 2 / 2    26 x  26 x 256   ->    13 x  13 x 256
   10 conv    512  3 x 3 / 1    13 x  13 x 256   ->    13 x  13 x 512  0.399 BFLOPs
   11 max          2 x 2 / 1    13 x  13 x 512   ->    13 x  13 x 512
   12 conv   1024  3 x 3 / 1    13 x  13 x 512   ->    13 x  13 x1024  1.595 BFLOPs
   13 conv    256  1 x 1 / 1    13 x  13 x1024   ->    13 x  13 x 256  0.089 BFLOPs
   14 conv    512  3 x 3 / 1    13 x  13 x 256   ->    13 x  13 x 512  0.399 BFLOPs
   15 conv    255  1 x 1 / 1    13 x  13 x 512   ->    13 x  13 x 255  0.044 BFLOPs
   16 yolo
   17 route  13
   18 conv    128  1 x 1 / 1    13 x  13 x 256   ->    13 x  13 x 128  0.011 BFLOPs
   19 upsample            2x    13 x  13 x 128   ->    26 x  26 x 128
   20 route  19 8
   21 conv    256  3 x 3 / 1    26 x  26 x 384   ->    26 x  26 x 256  1.196 BFLOPs
   22 conv    255  1 x 1 / 1    26 x  26 x 256   ->    26 x  26 x 255  0.088 BFLOPs
   23 yolo
Loading weights from yolov3-tiny.weights...Done!
{
  "file":"data/horses.jpg",
  "meta":"coco.data",
  "net":"cfg/yolov3-tiny.cfg",
  "results":[
    {
      "center":{
        "x":515,
        "y":279
      },
      "confidence":55.9509813785553,
      "entity":"cow",
      "height":143,
      "id":"0",
      "width":180
    },
    {
      "center":{
        "x":85,
        "y":245
      },
      "confidence":55.62857985496521,
      "entity":"horse",
      "height":140,
      "id":"1",
      "width":184
    },
    {
      "center":{
        "x":515,
        "y":282
      },
      "confidence":54.17007803916931,
      "entity":"cow",
      "height":95,
      "id":"2",
      "width":78
    }
  ],
  "threshold":0.5,
  "weights":"yolov3-tiny.weights"
}
```

## `yoloanno.sh` script
Annotates the original image using the [`yoloanno.sh`](example/yoloanno.sh) script.  The script requires [ImageMagick](https://imagemagick.org/index.php) and [`jq`](https://stedolan.github.io/jq/) software; to install on Debian LINUX: 

```
sudo apt update -qq -y && sudo apt install -qq -y imagemagick jq
```

Use the the shell script to annotate the image with the expectation of both `<example>.jpg` and `<example>.json` exist; for example:

```
% ./yoloanno.sh example/horses
example/horses-yolo.jpg
```
The annotated image is stored using the `<example>-yolo.json` name.

### Output
![](example/horses-yolo.jpg?raw=true "EA7THE")

# Changelog & Releases

Releases are based on Semantic Versioning, and use the format
of ``MAJOR.MINOR.PATCH``. In a nutshell, the version will be incremented
based on the following:

- ``MAJOR``: Incompatible or major changes.
- ``MINOR``: Backwards-compatible new features and enhancements.
- ``PATCH``: Backwards-compatible bugfixes and package updates.

# Authors & contributors

David C Martin (github@dcmartin.com)
