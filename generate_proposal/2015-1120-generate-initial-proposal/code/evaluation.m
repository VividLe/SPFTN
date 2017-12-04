function errpixnum=evaluation(gtdir,prodir,imgnum)
%计算每一帧的平均错误率
errpixnum=zeros(1,imgnum-2);
for iche=3:imgnum
    imgname=imgfolder(iche).name;
    proimg=imread([prodir,imgname]);
    gtimg=imread([gtdir,imgname]);
    gtimg=rgb2gray(gtimg);
    errpixnum(iche-2)=sum(sum(xor(proimg,gtimg)));    
end

end

