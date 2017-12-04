#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

EXAMPLE=/disk3/yangle/vgg/result/lmdbimg/orig
DATA=/disk3/yangle/vgg/dataset/txtdoc/orig
TOOLS=/home/server/software/caffe-master/build/tools

# TRAIN_DATA_ROOT=/disk1/chenhao/data_process/trainset
TRAIN_DATA_ROOT=/disk3/yangle/vgg/dataset/seg_track_v2/groundtruth/orig
# VAL_DATA_ROOT=/disk1/chenhao/data_process/valset

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
  RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=56
  RESIZE_WIDTH=56
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


echo "Creating train rgb leveldb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    $TRAIN_DATA_ROOT/worm/ \
    $DATA/worm_gt.txt \
    $EXAMPLE/worm_gt

echo "Done."
