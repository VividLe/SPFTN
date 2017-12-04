propath='H:\mcc\image\train\wormnew\gt\';
rgbimgpath='H:\mcc\test\result\wormnew\result_r\';
selectedrgbpath='H:\mcc\test\result\wormnew\train_test\';

imgfolder=dir([propath,'*.png']);
[imgnum,~]=size(imgfolder);

for iimg=1:imgnum
    imgname=imgfolder(iimg).name;
    im=imread([rgbimgpath,imgname]);
    imwrite(im,[selectedrgbpath,imgname],'png');
end