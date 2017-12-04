function IsFrameBelievable = CheckFrameBelievable( IsFrameBelievable_old,allpixnum,iimg,imgnum,img_c,believelable,imgfolder_dir,imgfolder,opticalflowdir,rgbimgfolder_dir)
%根据前后帧之间的投影，检查某一帧是否可信
%输入参数：
  %IsFrameBelievable_old：修正前的信任度标签
  %errth:[阈值]最高错误率；  allpixnum：图片含有的像素点数目；  iimg：（在dir中）目前图像的位置；
  %imgnum：图像总数；  img_c：目前需要判定的图片帧；  believelable：信任度标签
  %imgfolder_dir，imgfolder：文件夹及包含的文件；  
  %opticalflowdir：光流目录
%输出参数：
  %IsFrameBelievable该帧是否可信
  
%设阈值检查两个投影结果是否一致
% consth=0.1;
  
IsFrameBelievable=IsFrameBelievable_old;
searchindex=[-3,-2,-1,1,2,3];

%记录哪一帧可信，及其相对位置
belindex=zeros(2,6);
belindex(2,:)=searchindex;
for ibeli=1:6
    csindex=iimg+searchindex(ibeli)-2;
    %搜索到达边界
    if csindex<1 || csindex>imgnum-2
       continue; 
    else
       if believelable(csindex)==1
           belindex(1,ibeli)=1;
       end           
    end        
end

%按照优先级进行查找
sindexorder=[3,4,2,5,1,6];
if sum(belindex(1,:))>=2
    %可以修正该帧
    chnum=0;
    im_p=cell(1,2);
%     fprintf('check reliable for frame %d with frame \r',iimg-2);
    for ich=1:6
        %此处可以优化
        if belindex(1,sindexorder(ich))==1 & chnum<2
            %可计算投影
            chnum=chnum+1;
            %图片的相对位置
            p_img=belindex(2,sindexorder(ich));
            if p_img<0
                %向前投影
                im_p{chnum}=project_f(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,p_img);
%                 fprintf('%d ',iimg+p_img-2);
            else
                %向后投影
                im_p{chnum}=project_b(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,p_img);
%                 fprintf('%d ',iimg+p_img-2);
            end   
        end           
%         fprintf('\r');
    end 
    
    iscon=IsConsistent(allpixnum,im_p{1},im_p{2});
    if iscon==1
        isbel=IsBelievable(img_c,im_p{1},im_p{2},allpixnum); 
    else
        %需要比较仔细的判定
        
        chnum=0;
        im_p=cell(1,3);
    %     fprintf('check reliable for frame %d with frame \r',iimg-2);
        for ich=1:2:5
            %此处可以优化
            if belindex(1,sindexorder(ich))==1
                %可计算投影
                chnum=chnum+1;
                %图片的相对位置
                p_img=belindex(2,sindexorder(ich));
                im_p{chnum}=project_f(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,p_img);
            end      
        end         
        [rows,cols]=size(img_c);
        pro_res_f=zeros(rows,cols);
        for ipf=1:3
            im_p_c=im_p{ipf};
            if isempty(im_p_c)
               continue; 
            end
            for irow=1:rows
                for jcol=1:cols
                    if im_p_c(irow,jcol)==1
                       pro_res_f(irow,jcol)=pro_res_f(irow,jcol)+255;
                    end
                end
            end
            
        end
        pro_res_f=uint8(pro_res_f);
        isbel=IsBelievable(img_c,pro_res_f,pro_res_f,allpixnum); 
        
    end
      
    if isbel==1
        IsFrameBelievable=1;
    else
        IsFrameBelievable=0;
    end
    
    

end

end

