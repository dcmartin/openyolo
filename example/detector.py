#!/usr/bin/python

## system
import sys,os
sys.path.append(os.path.join(os.getcwd(),'python/'))

## why?
import pdb

import json, codecs

## darknet
import darknet as dn

dn.set_gpu(0)
net = dn.load_net("cfg/yolov3-tiny.cfg", "yolov3-tiny.weights", 0)
meta = dn.load_meta("cfg/coco.data")

## input
narg = len(sys.argv)

if narg > 1:
  filename = sys.argv[1]
else:
  filename = "data/horses.jpg"

if narg > 2:
  threshold = float(sys.argv[2])
else:
  threshold = 0.5

raw = dn.detect(net, meta, filename, threshold)

result = {}
result['net'] = "cfg/yolov3-tiny.cfg"
result['weights'] = "yolov3-tiny.weights"
result['meta'] = "coco.data"
result['threshold'] = threshold
result['file'] = filename

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
