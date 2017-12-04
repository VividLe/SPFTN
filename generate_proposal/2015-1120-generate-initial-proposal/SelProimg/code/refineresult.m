imgpath='H:\mcc\DONEWORK\test\result\bird_of_2\';
resultpath='H:\mcc\DONEWORK\test\result\bird_of_2_r\';
gtpath='H:\yangle\SegTrack\SegTrackv2\GroundTruth\bird_of_paradise\';
imgfolder=dir([imgpath,'*.png']);
%设阈值，将图像二值化
bfth=135;
imgnum=length(imgfolder);
for iimg=1:imgnum
    imgname=imgfolder(iimg).name;
    im=imread([imgpath,imgname]);
    im=im-bfth;
    im=im*255;
    imwrite(im,[resultpath,imgname],'png');    
end
imgfolder=dir([resultpath,'*.png']);
imgnum=length(imgfolder);
errpix=zeros(1,imgnum);
for iimg=1:imgnum
    imgname=imgfolder(iimg).name;
    gtim=imread([gtpath,imgname]);
    gtim=rgb2gray(gtim);
    testim=imread([resultpath,imgname]);
    errpix(iimg)=sum(sum(xor(gtim,testim)));
end
meanerr=mean(errpix);
