function imgR=imgRotate(img,ang)
%siz1=size(img,1);
%siz2=size(img,2);
imgR=imrotate(img,ang,'bilinear','crop');
end