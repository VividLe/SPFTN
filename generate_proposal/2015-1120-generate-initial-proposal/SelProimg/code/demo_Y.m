clear
clc

%添加路径，设置参数
%计算hypothesis
addpath(genpath('G:\yangle\weakly video segmentation\keysegments\code\'));
skip = 1;
numTopRegions = 10;
knn = 5;
IMSHOW = 1;
hypothesisNum = 1;
%选择帧时的参数
thlow=0.4;
thhigh=0.85;

datasetpath='H:\yangle\YouTube\YouTube_1\';
regionsetpath='H:\yangle\YouTube\regionproposals\';
opsetpath='H:\yangle\YouTube\opticalflow\';
resultpath='H:\yangle\YouTube\result_1\';

folderfile=dir(datasetpath);
[foldernum,~]=size(folderfile);
for ifol=3:foldernum    
    videoclassfolder=folderfile(ifol).name;
    fprintf('%s\r\n',videoclassfolder);
    
    videoorderdir=[datasetpath,videoclassfolder,'\'];
    regionorderdir=[regionsetpath,videoclassfolder,'\'];
    oporderdir=[opsetpath,videoclassfolder,'\'];
    resvideoorderdir=[resultpath,videoclassfolder,'\'];
    videoimgfile=dir(videoorderdir);
    [ordernum,~]=size(videoimgfile);
    for ividfol=ordernum:ordernum
        videoordername=videoimgfile(ividfol).name;
        fprintf('%s\r\n',videoordername);
        %0001层各个文件的目录
        imdir=[videoorderdir,videoordername,'\']; 
        regiondir=[regionorderdir,videoordername,'\'];
        opticalflowdir_old=[oporderdir,videoordername,'\'];
        resultdatasetdir=[resvideoorderdir,videoordername,'\'];
        
        tic;
        %计算hyp
        fprintf('calculate hypothesis\r');
        [A Segs imNdx scores hypotheses] = getRegionAffinitiesMotion(imdir, regiondir, opticalflowdir_old, skip, numTopRegions, knn);
        toc;
        
        %产生proposal图像
        fprintf('write hypothesis\r');
        writeproposal(Segs,imdir,resultdatasetdir);
        
        %逐个文件夹逐帧处理图片，注意计算不存在的opticalflow
        imgvideodir=resultdatasetdir;
        opticalflowdir=opticalflowdir_old;
        imgfolder=dir([imgvideodir,'1\']);
        [imgnum,~]=size(imgfolder);
        changelable_now=zeros(1,imgnum-2);
        isstill=1;
        count=0;
        %第一次选择
        fprintf('select first time\r');
        while isstill==1
            count=count+1;
            isstill=0;    
            believelable=-1*ones(1,imgnum-2);
            changelable_last=changelable_now;
            rgbimgfolder_dir=imdir;
            believelable=IniBelJudge(believelable,imgvideodir,opticalflowdir,rgbimgfolder_dir);
            [believelable]=RefineInBelLable(believelable,imgvideodir,opticalflowdir,rgbimgfolder_dir);
            [believelable,changelable_now]=SelectIniFrame(believelable,changelable_last,imgvideodir,opticalflowdir,rgbimgfolder_dir);
            %检查是否有变化
            for ic=1:imgnum-2
                if changelable_last(ic)~=changelable_now(ic)
                   isstill=1;
                   fprintf('%s circle %d\r\n',videoordername,count);
                   break;
                end
            end
        end
        %第二次选择
        fprintf('select second time\r');
        while isstill==1
            count=count+1;
            isstill=0;
            changelable_last=changelable_now;
            globalinilable=ones(1,imgnum-2);
            globalinilable=IniGlobalJudge(globalinilable,imgvideodir,thlow,thhigh);
            [globalinilable,changelable_now]=SelectIniFrame(globalinilable,changelable_last,imgvideodir,opticalflowdir,rgbimgfolder_dir);
            for ic=1:imgnum-2
                if changelable_last(ic)~=changelable_now(ic)
                   isstill=1;
                   break;
                end
            end
        end
        
    end          
end



