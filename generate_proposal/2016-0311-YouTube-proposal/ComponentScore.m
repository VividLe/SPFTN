function partsalscore=ComponentScore(img,salmap)
%计算部件的显著性得分
% imgj=rgb2gray(img);
imgj=img;
imgj=(double(imgj))/255;
imgsal=salmap.*imgj;
objpointsum=(sum(sum(imgj)));
partsalscore=(sum(sum(imgsal)))/objpointsum;

end

