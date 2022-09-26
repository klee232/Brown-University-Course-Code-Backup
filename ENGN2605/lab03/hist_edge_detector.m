function [pre_edge_map,dist] = hist_edge_detector(img,rad,num_orient,num_bins)
% Preprocessing Portion
% Convert Image to Grayscale
gray_image = rgb2gray(img);

% Rescale the Image Data to a Range [0,1]
rescale_image = im2double(gray_image);

orient_map = zeros(length_img,width_img);
pre_edge_map = zeros(length_img,width_img);
% Generate the Angles to Loop through
angles = linspace(0,pi,num_orient);
% create circular mask
x_coord = 1:1+2*rad;
y_coord = 1:1+2*rad;
cent_x = round(numel(x_coord)/2);
cent_y = round(numel(y_coord)/2);

[x,y] = meshgrid(x_coord,y_coord);
dist = (x-cent_x).^2+(y-cent_y).^2;
dist = sqrt(dist);
dist(dist>rad)=0;
dist(cent_x,cent_y) = 1;

% Loop through Each Pixel of Original Image
for i_len=rad+1:rad+1+(length_img-1)
    for i_wid=rad+1:rad+1+(width_img-1)
        region_of_interest = zero_pad_image((i_len-rad):(i_len+rad),(i_wid-rad):(i_wid+rad)).*(dist);
        disp('region_of_interest')
        disp(region_of_interest)
        % Create Variable for Storing
        max_chi_square = 0;
        max_angle = 0;

        % Loop through each angle
        for i_ang=angles
            % Retrieve the x and y vector values for the angle
            x_var = round(rad*cos(i_ang));
            y_var = round(rad*sin(i_ang));
            
            x_rig_half = i_wid + x_var;
            y_rig_half = i_len + y_var;
            x_lef_half = i_wid - x_var;
            y_lef_half = i_len - y_var;
            
            low_half=[];
            upp_half=[];
            
            % 0 and 180 degree case
            if i_ang==0 || i_ang==pi
               upp_half = region_of_interest(1:(i_len-(i_len-rad-1)*rad-1),:);
               low_half = region_of_interest((i_len-(i_len-rad-1)*rad+1):end,:);
               hist_upp = hist(upp_half,num_bins);
               sum_upp = sum(hist_upp);
               hist_up = hist_upp./sum_upp;
               hist_up = double(hist_up);
               hist_low = hist(low_half,num_bins);
               sum_low = sum(hist_low);
               hist_low = hist_low./sum_low;
               hist_low = double(hist_low);
               % Compute Chi-Square 
               var1 = double((hist_up-hist_low).^2);
               var2 = double((hist_up+hist_low));
               var3 = (0.5).*(var1./var2);
               var3 = var3(~isnan(var3));
               chi_square = sum(var3,2);
               disp('hist_up_hor')
               disp(hist_up)
               disp('hist_low_hor')
               disp(hist_low)
               disp('chi_square')
               disp(chi_square)
               % Make Comparison
               if chi_square > max_chi_square
                   max_chi_square = chi_square;
                   max_angle = i_ang;
               end
               
             % 90 degree case
            elseif i_ang==pi/2
               upp_half = region_of_interest(:,1:(i_wid-(i_wid-rad-1)*rad-1));
               low_half = region_of_interest(:,(i_wid-(i_wid-rad-1)*rad+1):end);
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
               var3 = var3(~isnan(var3));
               chi_square = sum(var3,'all');
               disp('hist_up_ver')
               disp(hist_upp)
               disp('hist_low_ver')
               disp(hist_low)
               disp('chi')
               disp(chi_square)
               % Make Comparison
               if chi_square > max_chi_square
                   max_chi_square = chi_square;
                   max_angle = i_ang;
               end
            else
                % Divided y space into equally divided space
                num_var = numel(x_lef_half:x_rig_half);
                x_step_var = x_lef_half:x_rig_half;
                y_step_var = linspace(y_lef_half,y_rig_half,num_var); 
                length_var = size(x_step_var,2);
                for ind_var=1:length_var
                    x_coord=x_step_var(ind_var);
                    y_coord=y_step_var(ind_var);
                    % Generate Upper Half and Lower Half
                    upp_half = cat(1, upp_half, region_of_interest(1:(y_coord-rad*(i_len-rad-1)-1),x_coord-rad*(i_wid-rad-1)));
                    low_half = cat(1, low_half, region_of_interest((y_coord-rad*(i_len-rad-1)+1):end,x_coord-rad*(i_wid-rad-1)));
                end

                % Generate Histogram
                hist_upp = hist(upp_half,num_bins);
                hist_low = hist(low_half,num_bins);

                % Generate Chi-Square Value
                var1 = (hist_upp-hist_low).^2;
                var2 = (hist_upp+hist_low);
                var3 = (0.5).*(var1./var2);
                var3 = var3(~isnan(var3));
                chi_square = sum(var3, 'all');
                disp('hist_up')
                disp(hist_upp)
                disp('hist_low')
                disp(hist_low)
                disp('chi_square hihi')
                disp(chi_square)

                % Store the Maximum Chi-Square Value and Angle
                if chi_square > max_chi_square
                    max_chi_square = chi_square;
                    max_angle = i_ang;
                end  
            end
        end
        orient_map(i_len-(i_len-rad-1)*rad,i_wid-(i_wid-rad-1)*rad) = max_angle;
        pre_edge_map(i_len-(i_len-rad-1)*rad,i_wid-(i_wid-rad-1)*rad) = max_chi_square;
    end
end

% Perform Non Max Suppression
edge_map = zeros(length_img,width_img);
for i_len=1:length_img
    for i_wid=1:width_img
        % Obtain its angle based on dy dx values
        angle = rad2deg(orient_map(i_len,i_wid));
      
        % For cases of angle that is larger than -22.5 and smaller than 22.5 
        % or larger than 157.5 and smaller than -157.5
        if (angle>-22.5 && angle<22.5) || (angle>157.5 && angle<-157.5)
            i_len_pre = i_len;
            i_wid_pre = i_wid-1;
            i_len_nex = i_len;
            i_wid_nex = i_wid+1;
            % Check if the previous or next pixel falls out of the range
            % If previous falls out of the range, just perform the comparison
            % for next pixel
            if i_wid_pre < 1
               curr_pix_grad = pre_edge_map(i_len,i_wid);
               nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
               % If the gradient of the current pixel is smaller than the next pixel,
               % set it to 0
               if curr_pix_grad < nex_pix_grad
                   edge_map(i_len,i_wid) = 0;
               else
                   edge_map(i_len,i_wid) = curr_pix_grad;
               end
            % If next pixel falls out of the range, just perform the
            % comparison for the previous pixel
            elseif i_wid_nex > width_img
                curr_pix_grad = pre_edge_map(i_len,i_wid);
                pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                % If the gradient of the current pixel is smaller than the
                % next pixel, set it to 0
                if curr_pix_grad < pre_pix_grad
                    edge_map(i_len,i_wid) = 0;
                else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                end
            % If all the pixels are in the range, perform comparison on all
            % previous, current and next pixel
            else
                nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
                curr_pix_grad = pre_edge_map(i_len,i_wid);
                pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                % If the current pixel is not the maximum of all three, set
                % it to 0
                if curr_pix_grad < nex_pix_grad || curr_pix_grad < pre_pix_grad
                    edge_map(i_len,i_wid) = 0;
                else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                end
            end
            
         % For cases of angle that is larger than 22.5 but smaller than
         % 67.5 or larger than -157.5 but smaller than -112.5
         elseif (angle>=22.5 && angle<67.5) || (angle>=-157.5 && angle<-112.5)
             i_len_pre = i_len-1;
             i_wid_pre = i_wid-1;
             i_len_nex = i_len+1;
             i_wid_nex = i_wid+1;
             % Check if the previous or next pixel falls out of the range
             % If previous pixel falls out of the range, just perform the comparison
             % for next pixel
             if (i_len_pre < 1 || i_wid_pre < 1) && (i_len_nex <= length_img && i_wid_nex <= width_img)
                 curr_pix_grad = pre_edge_map(i_len,i_wid);
                 nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
                 % If the current pixel is smaller than the next pixel, set
                 % it to 0
                 if curr_pix_grad < nex_pix_grad
                     edge_map(i_len,i_wid) = 0;
                 else
                     edge_map(i_len,i_wid) = curr_pix_grad;
                 end
             % If next pixel falls out of the range, just perform the comparison
             % for previous pixel
             elseif (i_len_nex > length_img || i_wid_nex > width_img) && (i_len_pre >= 1 && i_wid_pre >= 1)
                curr_pix_grad = pre_edge_map(i_len,i_wid);
                pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                % If the current pixel is smaller than the previous pixel,
                % set it to 0
                if curr_pix_grad < pre_pix_grad
                    edge_map(i_len,i_wid) = 0;
                else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                end
             % If both previous pixel falls out of range, don't perform
             % comparison store the current pixel gradient directly
             elseif (i_len_pre < 1 || i_wid_pre < 1) && (i_len_nex > length_img || i_wid_nex > width_img)
                 curr_pix_grad = pre_edge_map(i_len,i_wid);
                 edge_map(i_len,i_wid) = curr_pix_grad;
             % If all the pixels are in the range, perform comparison on all
             % previous, current and next pixel
             else
                 nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
                 curr_pix_grad = pre_edge_map(i_len,i_wid);
                 pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous or next pixel,
                 % set it to 0        
                 if curr_pix_grad < pre_pix_grad || curr_pix_grad < nex_pix_grad
                     edge_map(i_len,i_wid) = 0;
                 else
                     edge_map(i_len,i_wid) = curr_pix_grad;
                 end
             end
             
         % For cases of angle that is larger than 67.5 but smaller than
         % 112.5 or smaller than -67.5 but larger than -112.5
         elseif (angle >= 67.5 && angle < 112.5) || (angle >= -112.5 && angle > -67.5)
             i_len_pre = i_len-1;
             i_wid_pre = i_wid;
             i_len_nex = i_len+1;
             i_wid_nex = i_wid;
             % Check if the previous or next pixel falls out of the range
             % If previous pixel falls out of the range, just perform the comparison
             % for next pixel
             if i_len_pre < 1
                curr_pix_grad = pre_edge_map(i_len,i_wid);
                nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
                % If the current pixel is smaller than the next pixel, set
                % it to 0
                if curr_pix_grad < nex_pix_grad
                   edge_map(i_len,i_wid) = 0;
                else
                   edge_map(i_len,i_wid) = curr_pix_grad;
                end
             % If next pixel falls out of the range, just perform the comparison
             % for previous pixel
             elseif i_len_nex > length_img
                 curr_pix_grad = pre_edge_map(i_len,i_wid);
                 pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous pixel, set
                 % it to 0 
                 if curr_pix_grad < pre_pix_grad
                    edge_map(i_len,i_wid) = 0;
                 else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                 end
             % If all the pixels are in the range, perform comparison on all
             % previous, current and next pixel
             else
                 nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
                 curr_pix_grad = pre_edge_map(i_len,i_wid);
                 pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous or next pixel,
                 % set it to 0 
                 if curr_pix_grad < pre_pix_grad || curr_pix_grad < nex_pix_grad
                    edge_map(i_len,i_wid) = 0;
                 else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                 end
             end
             
         % For cases of angle that is larger than 112.5 but smaller than
         % 157.5 or larger than -67.5 but larger than -22.5
        else
            i_len_pre = i_len-1;
            i_wid_pre = i_wid+1;
            i_len_nex = i_len+1;
            i_wid_nex = i_wid-1;
            % Check if the previous or next pixel falls out of the range
            % If previous pixel falls out of the range, just perform the comparison
            % for next pixel
            if (i_len_pre < 1 || i_wid_pre > width_img) && (i_len_nex <= length_img && i_wid_nex >= 1) 
                curr_pix_grad = pre_edge_map(i_len,i_wid);
                nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
                % If the current pixel is smaller than the next pixel, set
                % it to 0
                if curr_pix_grad < nex_pix_grad
                    edge_map(i_len,i_wid) = 0;
                else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                end
             % If next pixel falls out of the range, just perform the comparison
             % for previous pixel
             elseif (i_len_nex > length_img || i_wid_nex < 1) && (i_len_pre >= 1 && i_wid_pre <= width_img)
                 curr_pix_grad = pre_edge_map(i_len,i_wid);
                 pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                % If the current pixel is smaller than the next pixel, set
                % it to 0
                if curr_pix_grad < pre_pix_grad
                    edge_map(i_len,i_wid) = 0;
                else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                end
             % If all pixels fall out of the range, don't perform
             % comparioson and store the current magnitude directly
            elseif (i_len_pre < 1 || i_wid_pre > width_img) && (i_len_nex > length_img || i_wid_nex < 1)
                curr_pix_grad = pre_edge_map(i_len,i_wid);
                edge_map(i_len,i_wid) = curr_pix_grad;
             % If all the pixels are in the range, perform comparison on all
             % previous, current and next pixel
             else
                 nex_pix_grad = pre_edge_map(i_len_nex,i_wid_nex);
                 curr_pix_grad = pre_edge_map(i_len,i_wid);
                 pre_pix_grad = pre_edge_map(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous or next pixel,
                 % set it to 0 
                 if curr_pix_grad < pre_pix_grad || curr_pix_grad < nex_pix_grad
                    edge_map(i_len,i_wid) = 0;
                 else
                    edge_map(i_len,i_wid) = curr_pix_grad;
                 end
             end
         end
     end
end

% edge_map = uint8(edge_map);

end