% Go through Each Angle Situation
            % Grab out the maximum element for angles less than pi/8 or
            % greater than 7*pi/8
            if i_ang < pi/8 || i_ang > 7*pi/8
               % For this scenario, we grab out the horizontal elements.
               % For example, in a 3*3 window, it will be (2,1), (2,2), and
               % (2,3) elements.
               % Divide Current Matrix into Half And Generate Histogram
               % for Each Part
               Upp_half = filt_curr_reg_image(1:cent_len-1,:);
               Low_half = filt_curr_reg_image(cent_len+1:end,:);
               hist_upp = hist(Upp_half, num_bins);
               sum_upp = sum(hist_upp);
               hist_upp = hist_upp./sum_upp;
               hist_low = hist(Low_half, num_bins);
               sum_low = sum(hist_low);
               hist_low = hist_low./sum_low;
               % Compute Chi-Square 
               var1 = (hist_up-hist_low).^2;
               var2 = (hist_up+hist_low);
               var3 = (0.5).*(var1./var2);
               chi_square = sum(var3);
               
            % Grab out the maximum element for angles larger than pi/8 but
            % smaller than 3*pi/8
            elseif i_ang >= pi/8 && i_ang < 3*pi/8
               % For this scenario, we grab out the opposite diagonal
               % elements. For example, in a 3*3 matrix, it will be (3,1),
               % (2,2) and (1,3) elements.
               % Divide Current Matrix into Half And Generate Histogram
               % for Each Part
               len_filt = size(filt_curr_reg_image,1);
               flip_filt_curr_reg_image = filt_curr_reg_image(len_filt:len_filt-1:end-1);
               Upp_half = tril(flip_filt_curr_reg_image);
               Low_half = triu(flip_filt_curr_reg_image);
               hist_upp = hist(Upp_half,num_bins);
               sum_upp = sum(hist_upp);
               hist_upp = hist_upp./sum_upp;
               hist_low = hist(Low_half,num_bins);
               sum_low = sum(hist_low);
               hist_low = hist_low./sum_low;
               % Compute Chi-Square 
               var1 = (hist_up-hist_low).^2;
               var2 = (hist_up+hist_low);
               var3 = (0.5).*(var1./var2);
               chi_square = sum(var3);
               
            % Grab out the maximum element for angles larger than 3*pi/8 
            % but smaller than 5*pi/8
            elseif i_ang >= 3*pi/8 && i_ang < 5*pi/8
                % In this scenario, we grab out the vertical elements. For
                % example, in a 3*3 matrix, we grab out (1,2), (2,2), and
                % (3,2) elements.
                % Divide Current Matrix into Half And Generate Histogram
                % for Each Part
                Upp_half = filt_curr_reg_image(:,1:cent_wid-1);
                Low_half = filt_curr_reg_image(:,cent_wid+1:end);
                hist_upp = hist(Upp_half,num_bins);
                sum_upp = sum(hist_upp);
                hist_upp = hist_upp./sum_upp;
                hist_low = hist(Low_half,num_bins);
                sum_low = sum(hist_low);
                hist_low = hist_low./sum_low;
                % Compute Chi-Square 
               var1 = (hist_up-hist_low).^2;
               var2 = (hist_up+hist_low);
               var3 = (0.5).*(var1./var2);
               chi_square = sum(var3);
               
            % Grab out the maximum element for angles larger than 5*pi/8 
            % but smaller than 7*pi/8
            else
               % In this scenario, we grab out the diagonal elements of the
               % matrix. For example, for a 3*3 matrix, we grab out (1,1),
               % (2,2) and (3,3) elements
               % Divide Current Matrix into Half And Generate Histogram
               % for Each Part
               Upp_half = triu(filt_curr_reg_image);
               Low_half = tril(filt_curr_reg_image);
               hist_upp = hist(Upp_half,num_bins);
               sum_upp = sum(hist_upp);
               hist_upp = hist_upp./sum_upp;
               hist_low = hist(Low_half,num_bins);
               sum_low = sum(hist_low);
               hist_low = hist_low./sum_low;
               % Compute Chi-Square 
               var1 = (hist_up-hist_low).^2;
               var2 = (hist_up+hist_low);
               var3 = (0.5).*(var1./var2);
               chi_square = sum(var3);
            end 


% Retrieve the length of the region
               width_reg = size(filt_curr_reg_image,2);
               num_x_iter = numel(x_left:width_reg);
               low_y_bound = round(cent_len+rad*tan(i_ang));
               upp_y_bound = round(cent_len-rad*tan(i_ang));
               % Obtain y linspace
               y_lin =linspace(low_y_bound,upp_y_bound,num_x_iter);
               % Obtain the pixels of the Lower half of the region
               low_half = [];
               y_point = 1;
               for i_wid_x=x_left:width_reg
                   grab_out_portion = filt_cur_reg_image(i_wid_x,round(y_lin(y_point)):end);
                   low_half = cat(1, low_half, grab_out_portion);
                   y_point = y_point+1;
               end
               % Obtain the Upper half
               upp_half = [];
               y_point = 1;
               
               
                       
               upp_half = flip_filt_curr_reg_image(x_left:end,1:y_up));
               low_half = flip_filt_curr_reg_image(x_left:end,y_low:y_up));


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
        dist = round(dist);
        if (dist <= rad)  
           wind_matrix(i_wind_len,i_wind_wid) = 1;
        else
           wind_matrix(i_wind_len,i_wind_wid) = 0;
        end
    end
end

% 0 and 180 degree case
            if i_ang==0 || i_ang==pi
               upp_half = filt_curr_reg_image(1:cent_len-1,:);
               low_half = filt_curr_reg_image(cent_len+1:end,:);
               hist_upp = hist(upp_half,num_bins);
               sum_upp = sum(hist_upp);
               hist_up = hist_upp./sum_upp;
               hist_low = hist(low_half,num_bins);
               sum_low = sum(hist_low);
               hist_low = hist_low./sum_low;
               % Compute Chi-Square 
               var1 = (hist_up-hist_low).^2;
               var2 = (hist_up+hist_low);
               var3 = (0.5).*(var1./var2);
               chi_square = sum(var3);
               % Make Comparison
               if chi_square > chi_square_temp
                   chi_square_temp = chi_square;
                   fin_angle = i_ang;
               end
               
            % 90 degree case
            elseif i_ang==pi/2
               upp_half = filt_curr_reg_image(:,1:cent_wid-1);
               low_half = filt_curr_reg_image(:,cent_wid+1:end);
               hist_upp = hist(upp_half,num_bins);
               sum_upp = sum(hist_upp);
               hist_up = hist_upp./sum_upp;
               hist_low = hist(low_half,num_bins);
               sum_low = sum(hist_low);
               hist_low = hist_low./sum_low;
               % Compute Chi-Square 
               var1 = (hist_up-hist_low).^2;
               var2 = (hist_up+hist_low);
               var3 = (0.5).*(var1./var2);
               chi_square = sum(var3);
               % Make Comparison
               if chi_square > chi_square_temp
                   chi_square_temp = chi_square;
                   fin_angle = i_ang;
               end
               
            % Other cases
            else
               % Find out the boundary for upper and lower half of the region
               x_l = i_wid-round(rad*cos(i_ang));
               x_r = i_wid+round(rad*cos(i_ang));
               y_u = i_len+round(rad*sin(i_ang));
               y_d = i_len-round(rad*sin(i_ang));
               
               % Find out Line Direction
               num_x = numel(cent_wid:x_r);
               x_half_r = cent_wid:x_r;
               y_half_r = linspace(cent_len,y_u,num_x);
               x_half_l = x_l:cent_wid;
               y_half_l = linspace(y_d,cent_len,num_x);
               x_line = [x_half_l x_half_r];
               y_line = [y_half_l y_half_r];
               
               % Generate Upper and Lower Half
               length_line = size(x_line,2);
               for i_x_line=1:length_line
                  % Grab out corresponding x and y coordinates for the line
                  x_point = x_line(i_x_line);
                  y_point = y_line(i_x_line);
                  
                   
               end
                       % Impose the circular matrix on current pixel region
        % Retrieve the current region on image 
        i_len_curr = i_len-rad:i_len+rad;
        i_wid_curr = i_wid-rad:i_wid+rad;
        curr_reg_image = zero_pad_image(i_len_curr,i_wid_curr);
        filt_curr_reg_image = curr_reg_image.*wind_matrix;
               
               
                           % Chop off the matrix
            low_half(
            chop_off_reg_int = region_of_interest(y_lef_half:y_rig_half,x_lef_half:x_rig_half);
            low_half = tril(chop_off_reg_int);
            upp_half = triu(chop_off_reg_int);

            [x,y] = meshgrid(x_coord,y_coord);
            dist = x.^2+y.^2;
            dist = sqrt(dist);
            % Eliminate the value for far distance
            dist(dist>rad)=0; 
                


            end


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