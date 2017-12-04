function believelable_out=IniBelJudge(believelable_in,imdatasetdir,opticalflowdir,rgbimgfolder_dir)
%初始判断每一帧是否可信
%输入参数：
  %believelable_in：初始信任度表
  %imdatasetdir：存放每一类下面各个子文件夹（1、2、3等）的目录
  %opticalflowdir：光流的目录
%输出参数：
  %believelable_out：计算过的信任度表

imgfolder_1_dir=[imdatasetdir,'1\'];
imgfolder_2_dir=[imdatasetdir,'2\'];
imgfolder_3_dir=[imdatasetdir,'3\'];    

imgfolder_1=dir(imgfolder_1_dir);
[imgnum,~]=size(imgfolder_1);

%设阈值，判断两种投影结果是否一致
% consth=0.10;  
%设阈值，判断当前帧是否可信
errth=0.10; 

%从第二帧到倒数第二帧
cimg=imread([imdatasetdir,'1\',imgfolder_1(3).name]);
[imgrows,imgcols]=size(cimg);
allpixnum=imgrows*imgcols;
for iimg=4:imgnum-1
    frameindex=iimg-2;
    img_c=imread([imgfolder_1_dir,imgfolder_1(iimg).name]); 
    [pro_f,pro_b]=project_fb(imgfolder_1_dir,rgbimgfolder_dir,imgfolder_1,opticalflowdir,iimg);   
    
    iscons=IsConsistent(allpixnum,pro_f,pro_b);       
    if iscons==1
        %投影可信，判断目前帧是否与投影一致
        isbel=IsBelievable(img_c,pro_f,pro_b,allpixnum);        
        if isbel==1
            %当前帧不用修正
            believelable_in(frameindex)=1;
        else
            %需要修正
%             fprintf('the proposal %s is unbelievable\r',imgfolder_1(iimg).name);
            believelable_in(frameindex)=0;                     
        end        
    else
        %检查一致性
        conslable=zeros(1,3);
        %hypothesis1投影不可信,检查hypothesis中2,3的投影结果
%         fprintf('frame %d %s the project results are inconstistent\r',iimg-2,imgfolder_1(iimg).name);
        %hypothesis2，3的结果
        [pro_f_2,pro_b_2]=project_fb(imgfolder_2_dir,rgbimgfolder_dir,imgfolder_1,opticalflowdir,iimg); 
        conslable(2)=IsConsistent(allpixnum,pro_f_2,pro_b_2);   
        [pro_f_3,pro_b_3]=project_fb(imgfolder_3_dir,rgbimgfolder_dir,imgfolder_1,opticalflowdir,iimg); 
        conslable(3)=IsConsistent(allpixnum,pro_f_3,pro_b_3);  
        
        %用conslable标记3个hypothesis下面投影结果是否一致，对011情况，用投影替代原图像
        if sum(conslable)==2
            %可以得到当前帧比较可信的投影结果
            if believelable_in(frameindex-1)==0 || believelable_in(frameindex+1)==0
%                 fprintf('re-judje frame %d\r',frameindex);
                newpro_2=bitand(pro_f_2,pro_b_2);
                newpro_3=bitand(pro_f_3,pro_b_3);
                newpro_1=bitor(newpro_2,newpro_3);
                
                errorratio=sum(sum(xor(img_c,newpro_1)))/allpixnum;
                if errorratio<errth
                    believelable_in(frameindex)=1;
                else
                    believelable_in(frameindex)=0;
                end
           
            end
          
        end
        
    end   
    
end
    believelable_out=believelable_in;

end

