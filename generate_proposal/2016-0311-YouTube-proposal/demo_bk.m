clear
clc

addpath('/home/yangle/work/YouTube/code/SalLeadProposal/proimg/');

vidfolderrootpath='/home/yangle/work/YouTube/result/proposal/';
vidmatrootpath='/home/yangle/work/YouTube/result/sal/';
vidresrootpath='/home/yangle/work/YouTube/result/finepro/';
vidsalrootpath='/home/yangle/work/YouTube/result/vidsal/';

imgsalscoreTH=0.5;
salratioTH=1.2;
salimgTH=0.1;
bsTH=0.05;
partnumratioS=2;
partnumratioB=0.5;
samllpartTH=0.3;

videoset=dir(vidfolderrootpath);
for ivid=4:length(videoset)
    videoname=videoset(ivid).name;
    fprintf('\r%s\r',videoname);
    vidpath=[vidfolderrootpath,videoname,'/'];
    vidmatpath=[vidmatrootpath,videoname,'/'];
    vidrespath=[vidresrootpath,videoname,'/'];
    vidsalpath=[vidsalrootpath,videoname,'/'];
    
    orderset=dir(vidpath);
    for iord=3:length(orderset)
        ordername=orderset(iord).name;
        imgrootpath=[vidpath,ordername,'/1/'];
        imgfolderrootpath=[vidpath,ordername,'/'];
        imgmatrootpath=[vidmatpath,ordername,'/mat/'];
        imgresrootpath=[vidrespath,ordername,'/'];
        imgsalrootpath=[vidsalpath,ordername,'/'];
        if ~exist(imgresrootpath,'dir')
            mkdir(imgresrootpath);
        end
        if ~exist(imgsalrootpath,'dir')
            mkdir(imgsalrootpath);
        end
        
        imgset=dir([imgrootpath,'*.png']);
        imgnum=length(imgset);
        sizeimg=imread([imgrootpath,imgset(1).name]);
        [rows,cols,dep]=size(sizeimg);
        
        mapsal=zeros(1,imgnum);
        salrec=zeros(10,imgnum);
        perrec=zeros(1,imgnum);
                
        parfor iimg=1:imgnum
            imgname=imgset(iimg).name;
            matname=[imgname(1:length(imgname)-3),'mat'];
            aload=load([imgmatrootpath,matname]);
            salmap=aload.salmap;
            salmap=double(salmap);
            salmap=imresize(salmap,[rows,cols],'bilinear');
            %����ͼ
            salmapwri=salmap;
            salmapwri(salmapwri<0.15)=0;
            salmapwri(salmapwri>=0.15)=255;
            salmapwri=uint8(salmapwri);
            imwrite(salmapwri,[imgsalrootpath,imgname],'png');

            mapsal(iimg)=mean(mean(salmap));
            sumimg=uint8(zeros(rows,cols,dep));
            for ord=1:10
                order=num2str(ord);
                imgpath=[imgfolderrootpath,order,'/',imgname];
                img=imread(imgpath);
                img=255*uint8(img);
        %         imgj=rgb2gray(img);
                imgj=img;
                imgj=(double(imgj))/255;
                imgsal=salmap.*imgj;
                objpointsum=(sum(sum(imgj)));
                %proposal saliency score
                partsalscore=(sum(sum(imgsal)))/objpointsum;
                if partsalscore>imgsalscoreTH
                    sumimg=sumimg+img;
                    salrec(ord,iimg)=partsalscore;
                else
                    numsalmap=salmap;
                    numsalmap(numsalmap<salimgTH)=0;
                    if (objpointsum/numel(numsalmap))>bsTH
                        partnumratio=partnumratioB;
                    else
                        partnumratio=partnumratioS;
                    end
                    salpixnum=sum(sum(logical(numsalmap)));
                    if objpointsum > (partnumratio*salpixnum)
                        salrec(ord,iimg)=partsalscore;
                    else
                        salmapr=reshape(salmap,[rows*cols,1]);
                        salmapr=sort(salmapr,'descend');
                        partsalmap=salmapr(1:objpointsum);
                        salratio=mean(partsalmap)/partsalscore;
                        if salratio<salratioTH
                            sumimg=sumimg+img;
                            salrec(ord,iimg)=salratio;
                        else
                            salrec(ord,iimg)=partsalscore;
                        end    
                    end                  
                end        
                salrec(ord,iimg)=partsalscore;
            end

            partper=(sum(sum(sum(sumimg))))/(sum(sum(sum(sumimg+salmapwri))));
            perrec(iimg)=partper;
            if partper<samllpartTH
                fprintf('joint part model %s\r',imgname);
                sumimg=JointPartModel(imgname,salmapwri,salmap,imgfolderrootpath);
            end  
            imwrite(sumimg,[imgresrootpath,imgname],'png');

        end
        
    end
    
end





