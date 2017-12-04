clear
clc
addpath(genpath('grabcut'));
videoname='aeroplane';
imgrootpath=['/home/yangle/work/RefineEdge/dataset/image/',videoname,'/'];
gtrootpath=['/home/yangle/work/RefineEdge/dataset/gt/',videoname,'/'];
maskrootpath=['/home/yangle/work/RefineEdge/dataset/mask/',videoname,'/'];
segresrootpath=['/home/yangle/work/RefineEdge/dataset/result/',videoname,'/seg/'];

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
    mask=imread([maskrootpath,imgname]);
    mask=double(mask)/255;
    
%     threshold = graythresh(mask);
    threshold = 0.5;
    bwimg=im2bw(mask,threshold);
    BinarythRec(ima)=threshold;
    seg = st_segment(img,mask,threshold,maxIterations);
    imwrite(seg,[segresrootpath,imgname],'png');
    gt=imread([gtrootpath,imgname]);
%     gt=rgb2gray(gt);
    ErrCount(ima)=sum(sum(xor(seg,gt)));
end
