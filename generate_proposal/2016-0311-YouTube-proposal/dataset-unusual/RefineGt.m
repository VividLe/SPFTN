%refine YouTube mask annotation
clear
clc

gtsetpath='I:\dataset\Youtube\7-Evaluation\OriginalMask\';
resultpath='I:\dataset\Youtube\7-Evaluation\GroundTruth\';
gtset=dir(gtsetpath);

for icla=3:length(gtset);
    videoname=gtset(icla).name;
    fprintf('%s',videoname);
    imagepath=[gtsetpath,videoname,'\'];
    refinegtpath=[resultpath,videoname,'\'];
    if ~exist(refinegtpath,'dir')
        mkdir(refinegtpath);
    end       
    imageset=dir([imagepath,'*.png']);
    for iimg=1:length(imageset)
        imagename=imageset(iimg).name;
        img=imread([imagepath,imagename]);
        img(img<30)=0;
        img(img>=30)=255;
        imwrite(img,[refinegtpath,imagename],'png');
    end    
end