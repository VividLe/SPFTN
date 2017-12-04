1. 使用的caffemodel是预训练好的model，本train过程就是对此model进行fine-tune，使得model适合本次任务


2. 训练之前，需要将图片转换为lmdb格式，使用程序creat_set，具体步骤如下：

（1）如果训练图片不足，需要对数据进行扩充，使用程序 data augmentation

（2）将图片的名称加标签后保存在txt文件中，使用file list

（3）使用creat_set将图片转换为lmdb格式，注意groundtruth与彩色图像的差别


3. 使用train_cnn进行训练

（1）需要更改的数据包括：
train_rgbd_so.sh：caffe的路径，训练阶段.prototxt文件的路径，已有caffemodel的位置
SO_rgbd_global_vgg_solver.prototxt：训练过程参数设置文件，主要需调整学习率，其它参数需继续了解
SO_rgbd_global_vgg_train_val.prototxt：训练参数设置，网络结构说明
    需要设置的路径包括：原图像和groundtruth的lmdb格式
    网络结构具体阐释了网络中各层的结构，可根据需要修改