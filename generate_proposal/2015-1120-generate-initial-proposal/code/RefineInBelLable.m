function [believelable_out] = RefineInBelLable(believelable_in,imdatasetdir,opticalflowdir,rgbimgfolder_dir)
%修正初始的信任度表
%输入参数：
  %
%输出参数：
  %

%参数
% errth=0.1;

imgfolder_1_dir=[imdatasetdir,'1\'];
imgfolder_1=dir(imgfolder_1_dir);
[imgnum,~]=size(imgfolder_1);

cimg=imread([imdatasetdir,'1\',imgfolder_1(3).name]);
[imgrows,imgcols]=size(cimg);
allpixnum=imgrows*imgcols;


for iimg=3:imgnum
    
    %检查不可信的、不确定的帧
    if believelable_in(iimg-2)==-1 || believelable_in(iimg-2)==0
%         fprintf('check changed');
        IsFrameBelievable_old=believelable_in(iimg-2);
        img_c=imread([imgfolder_1_dir,imgfolder_1(iimg).name]);
        IsBel = CheckFrameBelievable( IsFrameBelievable_old,allpixnum,iimg,imgnum,img_c,believelable_in,imgfolder_1_dir,imgfolder_1,opticalflowdir,rgbimgfolder_dir);
        if IsBel==1
            believelable_in(iimg-2)=1;
        else
            
        end
    end
% if iimg==3
%    fprintf('here'); 
% end
end
believelable_out=believelable_in;



end

