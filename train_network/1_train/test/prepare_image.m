function im_data = prepare_image(img,mean_data)
im_data = img(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
im_data = permute(im_data, [2, 1, 3]);  % flip width and height
im_data = single(im_data);  % convert from uint8 to single
for ch=1:3
    im_data(:,:,ch)=  im_data(:,:,ch)-mean_data(ch);
end