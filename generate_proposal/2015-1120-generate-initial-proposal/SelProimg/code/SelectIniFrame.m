function [believelable_out,changelable_out]=SelectIniFrame(believelable_in,changelable_in,imdatasetdir,opticalflowdir,rgbimgfolder_dir)
%从hypothesis1,2,3中选择出最值得信赖的部分

% errth=0.2;
imgfolder_1_dir=[imdatasetdir,'1\'];
imgfolder_1=dir(imgfolder_1_dir);
[imgnum,~]=size(imgfolder_1);
cimg=imread([imdatasetdir,'1\',imgfolder_1(3).name]);
[imgrows,imgcols]=size(cimg);
allpixnum=imgrows*imgcols;

for iimg=3:imgnum
    frameindex=iimg-2;
    imgname=imgfolder_1(iimg).name;
    if (believelable_in(frameindex)==1)     
%         fprintf('the frame %d is unchange\r',iimg-2);
    else
        %对于0或-1查找hypothesis1,2,3是否可信
        hypbellable=zeros(1,3);
        for ihbl=1:3
            ihblorder=num2str(ihbl);
            imgfolder_dir=[imdatasetdir,ihblorder,'\'];
            img_c=imread([imgfolder_dir,imgfolder_1(iimg).name]);
            IsFrameBelievable_old=believelable_in(frameindex);
            IsFrameBelievable=CheckFrameBelievable( IsFrameBelievable_old,allpixnum,iimg,imgnum,img_c,believelable_in,imgfolder_1_dir,imgfolder_1,opticalflowdir,rgbimgfolder_dir);

            if IsFrameBelievable==1
                hypbellable(ihbl)=1;
            end            
        end
        iffound=sum(hypbellable);
        if iffound==0
%             changelable_in(frameindex)=1;  
%             fprintf('the 3 hypothesis for frame %d are all unbelievable\r',iimg-2);
            believelable_in(frameindex)=0;
        elseif iffound==1
            foundorder=find(hypbellable==1);
            %找到一帧可信的
            believelable_in(frameindex)=1;            
            if foundorder~=1
                changelable_in(frameindex)=1;
%                 fprintf('the replecement for frame %d is %d\r',iimg-2,foundorder);
                im_move=imread([imdatasetdir,num2str(foundorder),'\',imgname]);
                imwrite(im_move,[imgfolder_1_dir,imgname],'bmp');
%                 isstill_in=1;
            else
%                 fprintf('the frame %d is unchange\r',iimg-2);
            end            
        elseif iffound==2
            %2个可信，选择最大的一个
%             fprintf('2 hypothesises found\r');
            imgname=imgfolder_1(iimg).name;
            hyporder=find(hypbellable==1);
            sel_res_1=imread([imdatasetdir,num2str(hyporder(1)),'\',imgname]);
            sel_res_2=imread([imdatasetdir,num2str(hyporder(2)),'\',imgname]);
            if sum(sum(sel_res_1)) > sum(sum(sel_res_2))     
                if hyporder(1)~= 1
                    imwrite(sel_res_1,[imgfolder_1_dir,imgname],'bmp');
%                     fprintf('the replecement for frame %d is %d\r',iimg-2,hyporder(1));
                    changelable_in(frameindex)=1;
                else
%                     fprintf('the frame %d is unchange\r',iimg-2);
                end      
            else
                if hyporder(2)~=1
                    imwrite(sel_res_2,[imgfolder_1_dir,imgname],'bmp');
%                     fprintf('the replecement for frame %d is %d\r',iimg-2,hyporder(2));
                    changelable_in(frameindex)=1;
                else
%                     fprintf('the frame %d is unchange\r',iimg-2);
                end
%                  
            end
                believelable_in(frameindex)=1;
        else
            %3个可信，选择最大的一个
%             fprintf('3 hypothesises found\r');
            pro_res=zeros(1,3);
            sel_res_1=imread([imdatasetdir,num2str(1),'\',imgname]);
            sel_res_2=imread([imdatasetdir,num2str(2),'\',imgname]);
            sel_res_3=imread([imdatasetdir,num2str(3),'\',imgname]);
            pro_res(1)=sum(sum(sel_res_1));
            pro_res(2)=sum(sum(sel_res_2));
            pro_res(3)=sum(sum(sel_res_3));
            if pro_res(3)>pro_res(2) & pro_res(3)>pro_res(1)
                imwrite(sel_res_3,[imgfolder_1_dir,imgname],'bmp');
%                 fprintf('the replecement frame for %d is 3\r',iimg-2);
                changelable_in(frameindex)=1;
            elseif pro_res(2)>pro_res(3) & pro_res(2)>pro_res(1)
                imwrite(sel_res_2,[imgfolder_1_dir,imgname],'bmp');
%                 fprintf('the replecement frame for %d is 3\r',iimg-2);
                changelable_in(frameindex)=1;
            else
%                 fprintf('the frame %d is unchange\r',iimg-2);
            end            
            believelable_in(frameindex)=1;
        end
            
    end
    
end
believelable_out=believelable_in;
changelable_out=changelable_in;


end

