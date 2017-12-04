clear
clc

datasetpath='G:\yangle\weakly video segmentation\initialization\result\';

%计算平均特征点
avefea=zeros(1,4);
allmatnum=0;

folderfile=dir(datasetpath);
[foldernum,~]=size(folderfile);
for ifol=3:foldernum
    filename=folderfile(ifol).name;
    fprintf([filename,'\r\n']);
    matpath=[datasetpath,filename,'\'];
    matfile=dir(matpath);
    [matnum,~]=size(matfile);    
    for imat=3:matnum
        matdatapath=[matpath,matfile(imat).name];
        cmat=load(matdatapath);
        [pronum,~]=size(cmat.imgpro);
        allmatnum=allmatnum+pronum;
        for ipro=1:pronum
            avefea=avefea+cmat.imgpro{ipro,1}.pro;    
        end
        
    end   
end

avefea1=avefea/matnum;