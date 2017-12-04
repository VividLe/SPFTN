function globalinilable_out = IniGlobalJudge( globalinilable_in,imgvideodir,thlow,thhigh )
%根据全局信息判断某一帧是否可信

imdir=[imgvideodir,'1\'];
imgfolder=dir(imdir);
[imgnum,~]=size(imgfolder);
pixsum=zeros(1,imgnum-2);
for i=3:imgnum
    cimg=imread([imdir,imgfolder(i).name]);
    pixsum(i-2)=sum(sum(cimg))/255;
end
[rows,cols]=size(cimg);
allpixnum=rows*cols;
pixratio=pixsum/allpixnum;
meanpix=mean(pixratio);
if meanpix<thlow
    for iimg=3:imgnum
        if pixratio(iimg-2)>thhigh
            globalinilable_in(iimg-2)=0;
        end
    end
else
%    fprintf('this class is unjudged\r\n'); 
end
globalinilable_out=globalinilable_in;

end

