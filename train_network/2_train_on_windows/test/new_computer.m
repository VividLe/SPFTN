clear
clc

imgpath = 'H:\mcc\image\proposal\worm';
gtpath = 'H:\mcc\image\GroundTruth\worm';

imgpath = [imgpath '\'];
gtpath = [gtpath '\'];

imgfolder = dir(imgpath);
imgnum = length(imgfolder);
errsum = 0;
for iimg = 3:imgnum
        imgname = imgfolder(iimg).name;
        img = imread([imgpath,imgname]);
        gtname = [imgname(1:end-3) 'png'];
        gt = imread([gtpath,gtname]);
        gt = rgb2gray(gt);
        errsum = errsum+sum(sum(xor(img,gt)));    
     fprintf('%d\n',iimg-2);
end
result = errsum/(imgnum-2)