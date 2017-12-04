function pro_f = project_f(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,gap)
%

%前一帧向该帧投影
img_f=imread([imgfolder_dir,imgfolder(iimg+gap).name]);
opflowdir_f=[opticalflowdir,imgfolder(iimg+gap).name,'_to_',imgfolder(iimg).name,'.opticalflow.mat'];
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
pro_f=im2bw(track_object_OF(img_f,2,1,opticalFlows_f),0.5);


end

