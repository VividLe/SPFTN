clear,clc

%设定resize的尺寸
imgSize=224;
maskSize=56;
%待处理图片所在的文件夹
imgPath='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\VGG\ImgAugmentation\test\birdfall';
%groundtruth所在的文件夹
maskPath='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\VGG\ImgAugmentation\test\birdfall-gt';
%图片格式
imgFiles=dir([imgPath,'\*.png']);
maskFiles=dir([maskPath,'\*.png']);
%扩充后文件存储的路径
savePath='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\VGG\ImgAugmentation\result\';        
savePathImg=[savePath '\val_rgb'];
%Groundtruth保存为.png格式
savePathMask=[savePath '\val_gt'];
MaskImgType='.png';



%data agmentation methods
methods={{'hflip'},{'crop'},{'rotate'}};
paras={{[1,-1]},{{'whole','up','down','left','right','middle'}},{[0]}};
cropFrac=[0.1];
[imgNum,~]=size(imgFiles);

for imgIdx=1:imgNum
    disp(imgIdx);
    imgAgmIdx=0;

    img=imread([imgPath '\' imgFiles(imgIdx).name]);
    img_s=imresize(img,[imgSize,imgSize],'bilinear');
    [imgName,ext]=strtok(imgFiles(imgIdx).name,'.');

    mask=imread([maskPath '\' imgName MaskImgType]);
    mask=double(mask)/255;
    mask_s=imresize(mask,[maskSize,maskSize],'bilinear');
    %imgTmp=[];
    %maskTmp=[];
    for i=1:length(methods{1})
        if strcmp(methods{1}{i},'hflip')
            thisParas1=paras{1}{i};
            for ii=1:length(thisParas1)
                if thisParas1(ii)==1
                    imgTmp1=img_s;
                    maskTmp1=mask_s;
                elseif thisParas1(ii)==-1
                    imgTmp1=img_s(:,end:-1:1,:);
                    maskTmp1=mask_s(:,end:-1:1,:);
                end
                for j=1:length(methods{2})
                    if strcmp(methods{2}{j},'crop')
                        thisParas2=paras{2}{j};
                        for jj=1:length(thisParas2)
                            for jjj=1:length(cropFrac)
                                imgTmp2=imgCrop(imgTmp1,thisParas2{jj},cropFrac(jjj));
                                maskTmp2=imgCrop(maskTmp1,thisParas2{jj},cropFrac(jjj));
                                for k=1:length(methods{3})
                                    if strcmp(methods{3}{k},'rotate')
                                        thisParas3=paras{3}{k};
                                        for kk=1:length(thisParas3)
                                            if thisParas3(kk)==0
                                                imgTmp3=imgTmp2;
                                                maskTmp3=maskTmp2;
                                            else
                                                imgTmp3=imgRotate(imgTmp2,thisParas3(kk));
                                                maskTmp3=imgRotate(maskTmp2,thisParas3(kk));
                                            end
                                            imgTmp=imgTmp3;
                                            maskTmp=double(im2bw(maskTmp3,0.5));
                                            imgAgmIdx=imgAgmIdx+1;
                                            saveNameImg=[imgName '-' num2str(imgAgmIdx) ext];
                                            saveNameMask=[imgName '-' num2str(imgAgmIdx) '.png'];
                                            imwrite(imgTmp,[savePathImg '/' saveNameImg]);
                                            imwrite(maskTmp,[savePathMask '/' saveNameMask]);
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end