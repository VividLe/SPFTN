clear
clc

% 数据分为训练和测试样本
% 训练样本
imgpath = 'E:\Exchange\dataset\aug\val_gt\';
%txt存放的位置
txtpath='E:\Exchange\dataset\aug\txt\val_gt.txt';

fid=fopen(txtpath,'w+');
fclose(fid);

fid = fopen(txtpath,'w');
img_name = dir([imgpath '*.png']);

for j = 1:length(img_name)
    file_name =[ img_name(j).name,' ', '0'];
    fprintf(fid, '%s\r\n', file_name);
end

fclose(fid);
