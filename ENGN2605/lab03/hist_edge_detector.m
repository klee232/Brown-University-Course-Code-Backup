function [edge_map,orient_map] = hist_edge_detector(img,rad,num_orient,num_bins)
% Preprocessing Portion
% Convert Image to Grayscale
gray_image = rgb2gray(img);

% Rescale the Image Data to a Range [0,1]
rescale_image = im2double(gray_image);

% Loop Through Each Pixel of the Image
length_img = size(img,1);
width_img = size(img,2);

% Zero Padding through the Image f (Done for the Purpose of Falling Out of Range) 
% Zero Padding through the Original Image
num_pad = rad;
for i_pad=1:num_pad
    % Create padding for each direction (horizontal and vertical)
    zero_pad_hzl = zeros(1,width_img+2*i_pad);
    zero_pad_vtl = zeros(length_img+2*(i_pad-1),1);
    % Concatenate zero padding for vertical direction
    % If this is the first padding concatenate with the original image
    % otherwise, concatenate it with the stored zero padded image
    if i_pad == 1
        zero_pad_image_temp = cat(2, zero_pad_vtl, rescale_image);
    else
        zero_pad_image_temp = cat(2, zero_pad_vtl, zero_pad_image_temp);
    end
    zero_pad_image_temp = cat(2, zero_pad_image_temp, zero_pad_vtl);
    % Concatenate zero padding for horizontal direction
    zero_pad_image_temp = cat(1, zero_pad_hzl, zero_pad_image_temp);
    zero_pad_image_temp = cat(1, zero_pad_image_temp, zero_pad_hzl);
end
zero_pad_image = zero_pad_image_temp;

% Create Square Window Matrix (it will be implemented into circular matrix
% by assigning values)
wind_matrix = zeros(2*rad+1,2*rad+1);
% Retrieve the cnetral point of the matrix
cent_len = median(1:2*rad+1);
cent_wid = median(1:2*rad+1);
% Looping through each index to implement a circular matrix
for i_wind_len=1:2*rad+1
    for i_wind_wid=1:2*rad+1
        % Get the distance between current element and central element in
        % indices
        dist_len = (i_wind_len-cent_len);
        dist_wid = (i_wind_wid-cent_wid);
        dist = sqrt(dist_len.^2+dist_wid.^2);
        dist = ceil(dist);
        if (dist <= rad)  
           wind_matrix(i_wind_len,i_wind_wid) = 1;
        else
           wind_matrix(i_wind_len,i_wind_wid) = 0;
        end
    end
end

% Generate the Angles to Loop through
angles = linspace(0,pi,num_orient);
% Loop through Each Pixel of Original Image
for i_len=rad+1:rad+length_img+1
    for i_wid=rad+1:rad+width_img+1
        % Impose the circular matrix on current pixel region
        % Retrieve the current region on image 
        i_len_curr = i_len-rad:i_len+rad;
        i_wid_curr = i_wid-rad:i_wid+rad;
        curr_reg_image = zero_pad_image(i_len_curr,i_wid_curr);
        filt_curr_reg_image = curr_reg_image.*wind_matrix;
        % Create a Variable to Store Final Outcome Angle
        fin_angle = 0;
        % Loop through each angle
        for i_ang=angles
            x
        end
    end
end


end