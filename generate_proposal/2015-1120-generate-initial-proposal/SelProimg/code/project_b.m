function pro_b = project_b(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,gap)
%后一帧向该帧投影
img_b=imread([imgfolder_dir,imgfolder(iimg+gap).name]);
opflowdir_b=[opticalflowdir,imgfolder(iimg).name,'_to_',imgfolder(iimg+gap).name,'.opticalflow.mat'];
if exist(opflowdir_b,'file')
    load(opflowdir_b,'vx','vy');
else
    rgbimg_b=imread([rgbimgfolder_dir,imgfolder(iimg+gap).name]);
    rgbimg_c=imread([rgbimgfolder_dir,imgfolder(iimg).name]);
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

