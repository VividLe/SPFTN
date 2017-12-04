function imgs=prepare_img(img,mask,rgbmean,imgchsize,maskchsize)
%对于mask没有做减去均值的操作
img=imresize(img,[imgchsize,imgchsize]);
img_data = img(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
img_data = permute(img_data, [2, 1, 3]);  % flip width and height
img_data = single(img_data);  % convert from uint8 to single
for ch=1:3
    img_data(:,:,ch)=  img_data(:,:,ch)-rgbmean(ch);
end

mask=imresize(mask,[maskchsize,maskchsize]);
mask_data = mask(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
mask_data = permute(mask_data, [2, 1, 3]);  % flip width and height
mask_data=rgb2gray(mask_data);
mask_data = single(mask_data);  % convert from uint8 to single
% for ch=1:3
%     mask_data(:,:,ch)=  mask_data(:,:,ch)-mean_data(ch);
% end
imgs{1}=img_data;
imgs{2}=mask_data;

end

