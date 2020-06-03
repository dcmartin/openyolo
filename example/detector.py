#!/usr/bin/python

## system
import sys,os
sys.path.append(os.path.join(os.getcwd(),'python/'))

## why?
import pdb

import json, codecs

## darknet
import darknet as dn

## input
narg = len(sys.argv)

if narg > 1:
  filename = sys.argv[1]
else:
  filename = "data/horses.jpg"

if narg > 2:
  config = sys.argv[2]
else:
  config = "tiny-v2"

if narg > 3:
  threshold = float(sys.argv[3])
else:
  threshold = 0.5

if config == "tiny-v2":
  cfg = "darknet/cfg/yolov2-tiny-voc.cfg"
  weights = "darknet/yolov2-tiny-voc.weights"
  data = "darknet/cfg/voc.data"

if config == "tiny-v3":
  cfg = "darknet/cfg/yolov3-tiny.cfg"
  weights = "darknet/yolov3-tiny.weights"
  data = "darknet/cfg/coco.data"

if config == "v2":
  cfg = "darknet/cfg/yolov2.cfg"
  weights = "darknet/yolov2.weights"
  data = "darknet/cfg/coco.data"

if config == "v3":
  cfg = "darknet/cfg/yolov3.cfg"
  weights = "darknet/yolov3.weights"
  data = "darknet/cfg/coco.data"

print cfg, weights, data

dn.set_gpu(0)
net = dn.load_net(cfg, weights, 0)
meta = dn.load_meta(data)

raw = dn.detect(net, meta, filename, threshold)

result = {}
result['cfg'] = cfg
result['weights'] = weights
result['data'] = data
result['threshold'] = threshold
result['filename'] = filename
result['count'] = len(raw)


entities = []
for k in range(len(raw)):
  # Prepare info for the prediction image
  record = {}
  record['id'] = str(k)
  record['entity'] = raw[k][0]
  record['confidence'] = raw[k][1] * 100.0

  center = {}
  center['x'] = int(raw[k][2][0])
  center['y'] = int(raw[k][2][1])
  record['center'] = center
  record['width'] = int(raw[k][2][2])
  record['height'] = int(raw[k][2][3])

  entities.append(record)

result['results'] = entities

json.dump(result, codecs.open('/dev/stdout', 'w', encoding='utf-8'), separators=(',', ':'), sort_keys=True, indent=2)
