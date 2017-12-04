#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

echo "Begining..."

EXAMPLE=/disk3/yangle/vgg/dataset/lmdb/frog
DATA=/disk3/yangle/vgg/dataset/frog
TOOLS=/home/server/software/caffe-master/build/tools
DATA_ROOT=/disk3/yangle/vgg/dataset/frog

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=false
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

if [ ! -d "$DATA_ROOT" ]; then
  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
  echo "Set the VAL_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet validation data is stored."
  exit 1
fi

echo "Creating train rgb leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    #-backend="leveldb" 
    $DATA_ROOT/train_rgb/ \
    $DATA/train_rgb.txt \
    $EXAMPLE/train_rgb


echo "Creating train gt leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    #-backend="leveldb" 
    $DATA_ROOT/train_gt/ \
    $DATA/train_gt.txt \
    $EXAMPLE/train_gt

echo "Creating val rgb leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    #-backend="leveldb" 
    $DATA_ROOT/val_rgb/ \
    $DATA/val_rgb.txt \
    $EXAMPLE/val_rgb


echo "Creating val gt leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    #-backend="leveldb" 
    $DATA_ROOT/val_gt/ \
    $DATA/val_gt.txt \
    $EXAMPLE/val_gt

echo "Done."
