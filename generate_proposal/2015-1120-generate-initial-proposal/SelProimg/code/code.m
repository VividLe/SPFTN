% clear
% clc

imgpath='H:\mcc\test\result\wormnew\1_15000\';
resultpath='H:\mcc\test\result\wormnew\1_15000_r\';
gtpath='H:\yangle\SegTrack\SegTrackv2\GroundTruth\worm\';
imgfolder=dir([imgpath,'*.png']);
meanerr=zeros(1,31);
imgnum=length(imgfolder);
for bfth=85:115
    bfth
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
    meanerr(bfth-84)=mean(errpix);
    
end