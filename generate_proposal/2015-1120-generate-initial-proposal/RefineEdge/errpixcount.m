%ͳ�ƽ���е����������
clear
clc

addpath(genpath('./'));

videoname='parachute';
imgrootpath=['/home/yangle/work/RefineEdge/dataset/image/',videoname,'/'];
maskrootpath=['/home/yangle/work/RefineEdge/dataset/mask/',videoname,'/'];
gtrootpath=['/home/yangle/work/RefineEdge/dataset/gt/',videoname,'/'];
moreimgrootpath=['/home/yangle/work/RefineEdge/dataset/result/',videoname,'/more/'];
lessimgrootpath=['/home/yangle/work/RefineEdge/dataset/result/',videoname,'/less/'];
errimgrootpath=['/home/yangle/work/RefineEdge/dataset/result/',videoname,'/err/'];


imgfolder=dir([maskrootpath,'*.png']);
imgnum=length(imgfolder);

redpixnum=zeros(3,imgnum);
maxIterations=10;

for  iimg=1:imgnum
    disp(iimg);
    imgname=imgfolder(iimg).name;
    img=imread([maskrootpath,imgname]);
    mask=imread([maskrootpath,imgname]);
    mask=double(rgb2gray(mask))/255;
    threshold = graythresh(mask);
    seg = st_segment(img,mask,threshold,maxIterations);
    
    seg=uint8(double(seg)*255);
    gt=imread([gtrootpath,imgname]);
    gt=rgb2gray(gt);
    gt=255*gt;        
    
    imgmore=logical(seg-gt);
    redpixnum(1,iimg)=sum(sum(imgmore));
    imwrite(imgmore,[moreimgrootpath,imgname],'png');   
    imgless=logical(gt-seg);
    redpixnum(2,iimg)=sum(sum(imgless));
    imwrite(imgless,[lessimgrootpath,imgname],'png');
    imgerr=xor(gt,seg);
    redpixnum(3,iimg)=sum(sum(imgerr)); 
    imwrite(imgerr,[errimgrootpath,imgname],'png');
    
end
% mean(redpixnum)
fprintf('per frame more pix num is %f\r',mean(redpixnum(1,:)));
fprintf('per frame less pix num is %f\r',mean(redpixnum(2,:)));
fprintf('per frame err pix num is %f\r',mean(redpixnum(3,:)));
