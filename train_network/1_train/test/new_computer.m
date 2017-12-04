clear
clc

imgpath = 'H:\mcc\taskIII\new\worm\new';
gtpath = 'H:\mcc\image\GroundTruth\worm';

imgpath = [imgpath '\'];
gtpath = [gtpath '\'];

imgfolder = dir(imgpath);
imgnum = length(imgfolder);
errsum = 0;
for iimg = 3:imgnum
        imgname = imgfolder(iimg).name;
        img = imread([imgpath,imgname]);
        gt = imread([gtpath,imgname]);
        gt = rgb2gray(gt);
        errsum = errsum+sum(sum(xor(img,gt)));    
     fprintf('%d\n',iimg-2);
end
result = errsum/(imgnum-2)