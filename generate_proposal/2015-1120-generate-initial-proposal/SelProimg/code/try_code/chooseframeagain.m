clear
clc

imgpath='H:\yangle\SegTrack\datasetnow\result\monkeydog\';
resultpath='H:\yangle\SegTrack\datasetnow\result\monkeydog_2\';
rgbimgfolderpath='H:\yangle\SegTrack\SegTrackv2\JPEGImages\monkeydog\';
opticalflowdir='H:\yangle\SegTrack\opticalflow\frame-10\monkeydog\';

imgfolder=dir(imgpath);
imgfolder=imgfolder(3:length(imgfolder));
[imgnum,~]=size(imgfolder);
framelable=zeros(1,imgnum);
%阈值：判别是否一致
consth=0.25;
connumth=3;
%首尾3帧最先没有考虑
for iimg=4:imgnum-3
    fprintf('%d\r',iimg);
    searchindex=[-3,-2,-1,1,2,3];
    convote=0;
    cimg=imread([imgpath,imgfolder(iimg).name]);
    for ipro=1:6
        gap=searchindex(ipro);
        if gap<0
            proimg = project_f(imgpath,rgbimgfolderpath,imgfolder,opticalflowdir,iimg,gap);
        else
            proimg = project_b(imgpath,rgbimgfolderpath,imgfolder,opticalflowdir,iimg,gap);
        end
        %交比并表示错误率
        consrate=sum(sum(bitand(cimg,proimg)))/sum(sum(bitor(cimg,proimg)));
        if consrate>consth
            convote=convote+1;
        end
    end
    if convote>=connumth
        framelable(iimg)=1;
    end
    
end

imgorder=find(framelable==1);
for iimg=1:length(imgorder)
   imgname=imgfolder(imgorder(iimg)).name; 
   im=imread([imgpath,imgname]);
   imwrite(im,[resultpath,imgname],'png');
end





