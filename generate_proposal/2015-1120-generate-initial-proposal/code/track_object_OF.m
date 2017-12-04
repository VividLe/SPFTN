function im_tracked_object=track_object_OF(img,frame_index,tracking_frame_index,opticalFlow)
    % Track Object using Optical Flow
    if frame_index>tracking_frame_index
%         fprintf('forward/r/n');
        %插值方式：bicubic，bilinear
        %使用不同插值方式得到的结果一致，因为数值只有0和255
        im_tracked_object=warpByOpticalFlow_dong(img,opticalFlow.vx,opticalFlow.vy,'linear');
    else
        im_tracked_object=warpByOpticalFlow_dong(img,-opticalFlow.vx,-opticalFlow.vy,'linear');
%         fprintf('backward/r/n');
    end
end