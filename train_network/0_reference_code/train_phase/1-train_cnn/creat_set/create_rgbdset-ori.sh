#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

EXAMPLE=/disk1/chenhao/data_process
DATA=/disk1/chenhao/data_process
TOOLS=/home/server/software/caffe-master/build/tools

TRAIN_DATA_ROOT=/disk1/chenhao/data_process/trainset
VAL_DATA_ROOT=/disk1/chenhao/data_process/valset

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

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

if [ ! -d "$VAL_DATA_ROOT" ]; then
  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
  echo "Set the VAL_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet validation data is stored."
  exit 1
fi

echo "Creating train rgb leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $TRAIN_DATA_ROOT/rgb/ \
    $DATA/train7800_rgb_list.txt \
    $EXAMPLE/train7800_rgbupdate_lmdb

echo "Creating train hha leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $TRAIN_DATA_ROOT/hha/ \
    $DATA/train7800_hha_list.txt \
    $EXAMPLE/train7800_hhaupdate_lmdb

echo "Creating train gt leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    $TRAIN_DATA_ROOT/gt/ \
    $DATA/train7800_gt_list.txt \
    $EXAMPLE/train7800_gtupdate_lmdb

echo "Creating val rgb leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $VAL_DATA_ROOT/rgb/ \
    $DATA/val600_rgb_list.txt \
    $EXAMPLE/val600_rgbupdate_lmdb

echo "Creating val hha leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $VAL_DATA_ROOT/hha/ \
    $DATA/val600_hha_list.txt \
    $EXAMPLE/val600_hhaupdate_lmdb

echo "Creating val gt leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    $VAL_DATA_ROOT/gt/ \
    $DATA/val600_gt_list.txt \
    $EXAMPLE/val600_gtupdate_lmdb

echo "Done."
