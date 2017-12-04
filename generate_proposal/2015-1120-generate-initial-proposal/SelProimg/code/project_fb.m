function [pro_f,pro_b]=project_fb(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg)
%将前一帧后一帧向该帧投影

%前一帧向该帧投影
img_f=imread([imgfolder_dir,imgfolder(iimg-1).name]);
opflowdir_f=[opticalflowdir,imgfolder(iimg-1).name,'_to_',imgfolder(iimg).name,'.opticalflow.mat'];
if exist(opflowdir_f,'file')
    load(opflowdir_f,'vx','vy');
else
    rgbimg_f=imread([rgbimgfolder_dir,imgfolder(iimg-1).name]);
    rgbimg_c=imread([rgbimgfolder_dir,imgfolder(iimg).name]);
    im1=double(rgbimg_f);
    im2=double(rgbimg_c);
    flow = mex_LDOF(im1,im2);
    vx = flow(:,:,1);
    vy = flow(:,:,2);
    save('-v7',opflowdir_f,'vx','vy');
end
opticalFlows_f=load(opflowdir_f);
pro_f=im2bw(track_object_OF(img_f,2,3,opticalFlows_f),0.5);
%后一帧向该帧投影
img_b=imread([imgfolder_dir,imgfolder(iimg+1).name]);
opflowdir_b=[opticalflowdir,imgfolder(iimg).name,'_to_',imgfolder(iimg+1).name,'.opticalflow.mat'];
if exist(opflowdir_b,'file')
    load(opflowdir_b,'vx','vy');
else
    rgbimg_c=imread([rgbimgfolder_dir,imgfolder(iimg).name]);
    rgbimg_b=imread([rgbimgfolder_dir,imgfolder(iimg+1).name]);
    im1=double(rgbimg_c);
    im2=double(rgbimg_b);
    flow = mex_LDOF(im1,im2);
    vx = flow(:,:,1);
    vy = flow(:,:,2);
    save('-v7',opflowdir_b,'vx','vy');
end
opticalFlows_b=load(opflowdir_b);
pro_b=im2bw(track_object_OF(img_b,2,1,opticalFlows_b),0.5);

end

