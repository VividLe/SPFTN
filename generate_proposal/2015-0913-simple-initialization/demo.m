clear
clc

datasetpath='G:\yangle\weakly video segmentation\initialization\dataset\';
resultpath='G:\yangle\weakly video segmentation\initialization\result\';

addpath(genpath('G:\yangle\weakly video segmentation\initialization\superpixel'));
addpath(genpath('G:\yangle\weakly video segmentation\initialization\opticalflow'));

%产生超像素分割的参数
seg_para.sigma = 1.5;   
seg_para.k     = 120;    
seg_para.min_size = 200; 

%提取optical flow特征的参数
alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

folderfile=dir(datasetpath);
[foldernum,~]=size(folderfile);
for ifol=3:foldernum
    ifol
    filename=folderfile(ifol).name;
    imgsetpath=[datasetpath,filename,'\'];
    imagefile=dir(imgsetpath);
    [imgnum,~]=size(imagefile);
    %保存的文件夹
     resultfile=[resultpath,filename];
    if ~exist(resultfile,'dir')
        mkdir(resultfile);
    end
    for iimg=3:imgnum-1
        imgname1=[imgsetpath,imagefile(iimg).name];
        img1=imread(imgname1);
        imgname2=[imgsetpath,imagefile(iimg+1).name];
        img2=imread(imgname2);        
        %产生超像素分割
        imsegs = im2superpixels(img1, 'pedro',seg_para );
        %提取optical flow特征
        im1 = im2double(img1);
        im2 = im2double(img2);
        [vx,vy,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
        clear flow;
        flow(:,:,1) = vx;
        flow(:,:,2) = vy;
        %求每个proposals的特征
        imgpro = feaext(imsegs,flow);  
        
        imagename=imagefile(iimg).name;
        lengthname=length(imagename);
        imagename=imagename(1:lengthname-4);      
        imgproname=[imagename,'_','imgpro.mat'];
        save([resultfile,'\',imgproname],'imgpro');        
    end    
end



