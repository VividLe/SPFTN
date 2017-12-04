gtpath='H:\yangle\SegTrack\SegTrackv2\GroundTruth\worm\';
resultpath='H:\mcc\test\result\wormnew\2_r\';
imgfolder=dir([resultpath,'*.png']);
imgnum=length(imgfolder);
errpix=zeros(1,imgnum);
for iimg=1:imgnum
%     iimg
    imgname=imgfolder(iimg).name;
    gtim=imread([gtpath,imgname]);
    gtim=rgb2gray(gtim);
    testim=imread([resultpath,imgname]);
    errpix(iimg)=sum(sum(xor(gtim,testim)));
end
meanerr=mean(errpix);



