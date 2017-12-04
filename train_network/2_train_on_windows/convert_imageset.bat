SET GLOG_logtostderr=1
set caffe_path=E:\NianLiu\Deep_Learning_codes\caffe\caffe-master
rem %caffe_path%\bin\convert_imageset.exe   -backend="leveldb"  C:\Users\yangle\Desktop\frog\augimg\ C:\Users\yangle\Desktop\frog\frog.txt  C:\Users\yangle\Desktop\frog\image_leveldb
 %caffe_path%\bin\convert_imageset.exe   -gray=true -backend="leveldb"  C:\Users\yangle\Desktop\frog\auggt\ C:\Users\yangle\Desktop\frog\frog.txt  C:\Users\yangle\Desktop\frog\mask_leveldb

rem %caffe_path%\bin\convert_imageset.exe   -backend="leveldb"  ../test/img/ ../test/test_img_list.txt  SO_test_img_leveldb
rem %caffe_path%\bin\convert_imageset.exe   -gray=true -backend="leveldb"  ../test/mask/ ../test/test_mask_list.txt  SO_test_mask_leveldb
rem %caffe_path%\bin\convert_imageset.exe   -gray=true -backend="leveldb"  ../train/mask2/ ../train/train_mask_list.txt  SO_train_mask2_leveldb
rem %caffe_path%\bin\convert_imageset.exe   -gray=true -backend="leveldb"  ../train/global_predict/ ../train/train_mask_list.txt  SO_train_gp_leveldb

rem %caffe_path%\bin\convert_imageset.exe   -gray=true -backend="leveldb"  ../test/mask2/ ../test/test_mask_list.txt  SO_test_mask2_leveldb
rem %caffe_path%\bin\convert_imageset.exe   -gray=true -backend="leveldb"  ../test/global_predict/ ../test/test_mask_list.txt  SO_test_gp_leveldb
pause