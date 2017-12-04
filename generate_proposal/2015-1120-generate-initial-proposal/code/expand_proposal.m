%检查结果中错误像素点的个数
clear
clc

exapimgdir='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\KeySegments\IniSeg\dataset\image\proresult\girl\examplar\';
imgdatasetdir='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\KeySegments\IniSeg\dataset\image\proresult\girl\';
opticalflowdir='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\KeySegments\IniSeg\dataset\feature\opticalflow\girl\';
exapimgfolder=dir(exapimgdir);
[imgnum,~]=size(exapimgfolder);
img_c=imread([exapimgdir,exapimgfolder(3).name]);
[rows,cols]=size(img_c);
allpixelnum=rows*cols;

errth=0.3;

bellable=zeros(imgnum-2,10);
%初始判断每一帧能否用于投影
for iimg=3:imgnum  
    frameindex=iimg-2;
    imgname=exapimgfolder(iimg).name;
    img_expa=imread([exapimgdir,imgname]);
    for ihyp=1:10
        hypfolderdir=[imgdatasetdir,num2str(ihyp),'\'];        
        img_hyp=imread([hypfolderdir,imgname]);
        errpixsum=sum(sum(xor(img_expa,img_hyp)));

        if (errpixsum/allpixelnum)<errth
            bellable(frameindex,ihyp)=1; 
        end
    end
end

%利用光流投影，进行扩充
searchindex=[-3,-2,-1,1,2,3];
mulproers=cell(6,1);
%重叠率大于0.8时接受
recth=0.8;
% imgnum

for iimg=3:imgnum
    iimg
    ischanged=0;
%     %记录哪一帧可信，及其相对位置
% belindex=zeros(2,6);
% belindex(2,:)=searchindex;
    for ibeli=1:6
        csindex=iimg+searchindex(ibeli)-2;
        %搜索到达边界
        if csindex<1 || csindex>imgnum-2
           continue; 
        else
            %投影
            p_img=searchindex(ibeli);
             if p_img<0
                %向前投影
                mulproers{ibeli}=project_f(exapimgdir,exapimgfolder,opticalflowdir,iimg,p_img);
            else
                %向后投影
                mulproers{ibeli}=project_b(exapimgdir,exapimgfolder,opticalflowdir,iimg,p_img);
            end  
        end        
    end
     
    pro_base=zeros(rows,cols);
    %此处程序需要优化
    for ibeli=1:6
        a_pro=mulproers{ibeli};
        if isempty(a_pro)
            continue;
        else
           
            for ipro=1:rows
                for jpro=1:cols                    
                    if  a_pro(ipro,jpro)==1
                        pro_base(ipro,jpro)=pro_base(ipro,jpro)+1;
                    end
                end
            end            
        end
    end
    
    %一致投影的数目，设置为2
    pro_res=zeros(rows,cols);
    pro_res=uint8(pro_res);
    conproth=2;
    for irow=1:rows
        for jcol=1:cols
            if pro_base(irow,jcol) >= 2
                pro_res(irow,jcol)=255;
            end
        end
    end
    
    %小区域投影，判断可信性
    %初始判断每一帧能否用于投影
    for iimg_c=3:imgnum  
        frameindex=iimg_c-2;
        imgname=exapimgfolder(iimg_c).name;
        img_expa=imread([exapimgdir,imgname]);
        for ihyp=1:10
            hypfolderdir=[imgdatasetdir,num2str(ihyp),'\'];        
            img_hyp=imread([hypfolderdir,imgname]);
            
            img_overlap=bitand(pro_res,img_hyp);
            overtario=sum(sum(img_overlap))/sum(sum(img_hyp));
            if overtario>recth
                %扩中hyp
                img_expa=bitor(img_expa,img_hyp);
                imwrite(img_expa,[exapimgdir,imgname],'bmp');
                ischanged=1;
            end

        end

    end
    if ischanged==1
        fprintf('changed\r\n');
    end
    
end


