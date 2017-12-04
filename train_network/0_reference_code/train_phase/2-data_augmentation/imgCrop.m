function imgC=imgCrop(img,manner,cropFrac)
siz1=size(img,1);
siz2=size(img,2);
switch manner
    case 'whole'
        imgC=img;
    case 'up'
        imgC=imresize(img(1:round((1-cropFrac)*siz1),:,:),[siz1,siz2],'bilinear');
    case 'down'
        imgC=imresize(img(round(cropFrac*siz1):end,:,:),[siz1,siz2],'bilinear');
    case 'left'
        imgC=imresize(img(:,1:round((1-cropFrac)*siz2),:),[siz1,siz2],'bilinear');
    case 'right'
        imgC=imresize(img(:,round(cropFrac*siz2):end,:,:),[siz1,siz2],'bilinear');
    case 'middle'
        idx1=round(0.5*cropFrac*siz1):round((1-0.5*cropFrac)*siz1);
        idx2=round(0.5*cropFrac*siz2):round((1-0.5*cropFrac)*siz2);
        imgC=imresize(img(idx1,idx2,:),[siz1,siz2],'bilinear');
    otherwise
        disp('Invalid crop manner!');
        return
end
end