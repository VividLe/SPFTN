imgpath = 'H:\mcc\model_yl\frog\2\50000\oriimage';
resultpath = 'H:\mcc\model_yl\frog\2\50000\binimage';
gtpath = 'H:\mcc\image\GroundTruth\frog';

imgpath = [imgpath '\'];
resultpath = [resultpath '\'];
gtpath = [gtpath '\'];


% % 
imgfolder=dir(imgpath);
imgnum=length(imgfolder);

binerr=zeros(1,51);
for BinTh=70:120
    fprintf('%d\r',BinTh);
    errsum=0;
    for iimg=3:imgnum
        imgname=imgfolder(iimg).name;
        img=imread([imgpath,imgname]);
        img=img-BinTh;
        img=img*255;
        gt=imread([gtpath,imgname]);
        gt=rgb2gray(gt);
        errsum=errsum+sum(sum(xor(img,gt)));    
    end
    binerr(BinTh-69)=errsum/(imgnum-2);    
end

% 
% chosebinth=97;
% for iimg=3:imgnum
%         imgname=imgfolder(iimg).name;
%         img=imread([imgpath,imgname]);
%         img=img-chosebinth;
%         img=img*255;
%         imwrite(img,[resultpath,imgname]);
% end
% 



