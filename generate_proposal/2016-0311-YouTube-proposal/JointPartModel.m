function sumimg=JointPartModel(imgname,salmapwri,salmap,folderrootpath)
%
%С�����������ֵΪ0.1��

imgsize=imread([folderrootpath,'1/',imgname]);
[rows,cols,dep]=size(imgsize);
jointimg=zeros(rows,cols,dep);

% salmapwri=rgb2gray(salmapwri);
objectpixnumTH=(sum(sum(logical(salmapwri))))*0.5;

for ord=1:10
    order=num2str(ord);
    imgpath=[folderrootpath,order,'/',imgname];
    img=imread(imgpath);
%     imgj=logical(rgb2gray(img));
    imgj=img;
    imgpixnum=sum(sum(imgj));
    
    %����֮ǰ����part model��sal�÷�
    partsalTH=0.05;
    partsalscore=ComponentScore(img,salmap);
    if (imgpixnum<objectpixnumTH) && (partsalscore>partsalTH)
        jointimg=jointimg+double(img/255);
    end        
end  
bwTH=1;
jointimg(jointimg<bwTH)=0;
jointimg(jointimg>bwTH)=255;
sumimg=jointimg;

end

