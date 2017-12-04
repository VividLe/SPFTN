clear
clc

addpath(genpath('grabcut'));

videoname='parachute';
imgrootpath=['/home/yangle/work/RefineEdge/dataset/image/',videoname,'/'];
matrootpath=['/home/yangle/work/RefineEdge/dataset/mat/',videoname,'/'];
maskrootpath=['/home/yangle/work/RefineEdge/dataset/mask/',videoname,'/'];
segresrootpath=['/home/yangle/work/RefineEdge/dataset/result/',videoname,'/seg/'];
gtrootpath=['/home/yangle/work/RefineEdge/dataset/gt/',videoname,'/'];

imgset=dir([imgrootpath,'*.png']);
imgnum=length(imgset);
imgsize=imread([imgrootpath,imgset(1).name]);
[rows,cols,~]=size(imgsize);
maxIterations=10;
ErrCount=zeros(1,imgnum);
BinarythRec=zeros(1,imgnum);

for iimg=1:imgnum
    disp(iimg);
    imgname=imgset(iimg).name;
    img=imread([imgrootpath,imgname]);
    matname0=imgname(1:length(imgname)-3);
    matname=[matname0,'mat'];
    aload=load([matrootpath,matname]);
    salmap=double(aload.salmap);
    salmap=imresize(salmap,[rows,cols],'bilinear');
    
    %refine foreground
    salmap(salmap>0)=0;
    salmap=salmap/(min(min(salmap)));
    %save mask image??
    salmapwri=uint8(salmap*255);
    salmapwri(salmapwri==255)=254;
    salmapwri(salmapwri==0)=255;
    salmapwri(salmapwri<255)=0;
    imwrite(salmapwri,[maskrootpath,imgname],'png');    
    mask=salmap;
%     threshold = graythresh(mask);
    threshold = 0.5;
    BinarythRec(iimg)=threshold;
    seg = st_segment(img,mask,threshold,maxIterations);
    
    seg=uint8(double(seg)*255);
    seg(seg==255)=254;
    seg(seg==0)=255;
    seg(seg<255)=0;    
    imwrite(seg,[segresrootpath,imgname],'png');
    
    gt=imread([gtrootpath,imgname]);
    gt=rgb2gray(gt);
    ErrCount(iimg)=sum(sum(xor(seg,gt)));
    
    
end
