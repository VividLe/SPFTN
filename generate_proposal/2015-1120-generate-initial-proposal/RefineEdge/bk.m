clear
clc
%old result 1492
addpath(genpath('grabcut'));
videoname='bird_of_paradise';
imgrootpath=['/home/yangle/work/RefineEdge/dataset/image/',videoname,'/'];
gtrootpath=['/home/yangle/work/RefineEdge/dataset/gt/',videoname,'/'];
matrootpath=['/home/yangle/work/RefineEdge/dataset/mat/',videoname,'/'];
segresrootpath=['/home/yangle/work/RefineEdge/dataset/result/',videoname,'/seg/'];
bwrootpath=['/home/yangle/work/RefineEdge/dataset/result/',videoname,'/bw/'];

maxIterations=10;

imgset=dir([imgrootpath,'*.png']);

imgsize=imread([imgrootpath,imgset(1).name]);
[rows,cols,~]=size(imgsize);

imgnum=length(imgset);
ErrCount=zeros(1,imgnum);
BinarythRec=zeros(1,imgnum);

for ima=1:imgnum
    disp(ima);
    imgname=imgset(ima).name;
    img=imread([imgrootpath,imgname]);
    matname0=imgname(1:length(imgname)-3);
    matname=[matname0,'mat'];
    aload=load([matrootpath,matname]);
    salmap=double(aload.salmap);
%     salmap=imresize(salmap,[rows,cols],'bilinear');
    
%     minval=min(min(salmap));
%     maxval=max(max(salmap));
%     dataspan=maxval-minval;
%     mask=(salmap-minval)/dataspan;    
    salmap(salmap<0)=0;
    salmap(salmap>0)=1;
    mask=salmap;
    
%     threshold = graythresh(mask);
    threshold = 0.5;
    bwimg=im2bw(mask,threshold);
    imwrite(bwimg,[bwrootpath,imgname],'png');
    BinarythRec(ima)=threshold;
    seg = st_segment(img,mask,threshold,maxIterations);
    imwrite(seg,[segresrootpath,imgname],'png');
    gt=imread([gtrootpath,imgname]);
    gt=rgb2gray(gt);
    ErrCount(ima)=sum(sum(xor(seg,gt)));
end
