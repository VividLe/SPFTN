%视频的每个hypothesis已经存在，挑选生产合适的hypothesis

clear
clc

imdatasetdir='H:\yangle\YouTube\newdataset\result\';
opticalflowsetdir='H:\yangle\YouTube\newdataset\opticalflow\';

classfolder=dir(imdatasetdir);
[classnum,~]=size(classfolder);
for icla=3:classnum
    tic
    videoname=classfolder(icla).name;
    fprintf('%s',videoname);
    imgvideodir=[imdatasetdir,videoname,'\'];
    opticalflowdir=[opticalflowsetdir,videoname,'\'];
    
    imgfolder=dir([imgvideodir,'1\']);
    [imgnum,~]=size(imgfolder);
    changelable_now=zeros(1,imgnum-2);
    isstill=1;
    count=0;
    while isstill==1
        count=count+1;
        isstill=0;    
        believelable=-1*ones(1,imgnum-2);
        changelable_last=changelable_now;
        believelable=IniBelJudge(believelable,imgvideodir,opticalflowdir);
        [believelable]=RefineInBelLable(believelable,imgvideodir,opticalflowdir);
        [believelable,changelable_now]=SelectIniFrame(believelable,changelable_last,imgvideodir,opticalflowdir);
        %检查是否有变化
        for ic=1:imgnum-2
            if changelable_last(ic)~=changelable_now(ic)
               isstill=1;
               fprintf('%s circle %d\r\n',videoname,count);
               break;
            end
        end
    end
%    
thlow=0.4;
thhigh=0.85;
while isstill==1
    count=count+1;
    isstill=0;
    changelable_last=changelable_now;
    globalinilable=ones(1,imgnum-2);
    globalinilable=IniGlobalJudge(globalinilable,imgvideodir,thlow,thhigh);
    [globalinilable,changelable_now]=SelectIniFrame(globalinilable,changelable_last,imgvideodir,opticalflowdir);
    for ic=1:imgnum-2
        if changelable_last(ic)~=changelable_now(ic)
           isstill=1;
           break;
        end
    end
end

end
