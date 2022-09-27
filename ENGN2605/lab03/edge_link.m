function outcome = edge_link(image,threshold_h, threshold_l)
% Preprocessing Portion
% Convert Image to Grayscale
gray_image = rgb2gray(image);
% Convert Image to Double Type
gray_image = double(gray_image);

% Edge Detection Portion
% Load Image and Smooth it with s Gaussian Filter (Smooth Noise)
gauss_image = imgaussfilt(gray_image,2);
% Compute the Gradient of the Image
[dy,dx] = gradient(gauss_image);
% Create Magnitude Map M
M = sqrt(dx.^2+dy.^2);
% Used the Command quiver(dy,dx) to View the Actual Gradient Vectors
quiver(dy,dx);

% Conduct Non Max Suppression
% Looping through Each Pixel of Magnitude Map
% Retrieve the Sizes of Magnitude Map
length_M = size(M,1);
width_M = size(M,2);
% Create Outcome Storage Variable
max_sup_M = zeros(length_M,width_M);
for i_len=1:length_M
    for i_wid=1:width_M
        % Obtain its angle based on dy dx values
        angle = atan2d(dy(i_len,i_wid),dx(i_len,i_wid));
        
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
               curr_pix_grad = M(i_len,i_wid);
               nex_pix_grad = M(i_len_nex,i_wid_nex);
               % If the gradient of the current pixel is smaller than the next pixel,
               % set it to 0
               if curr_pix_grad < nex_pix_grad
                   max_sup_M(i_len,i_wid) = 0;
               else
                   max_sup_M(i_len,i_wid) = curr_pix_grad;
               end
            % If next pixel falls out of the range, just perform the
            % comparison for the previous pixel
            elseif i_wid_nex > width_M
                curr_pix_grad = M(i_len,i_wid);
                pre_pix_grad = M(i_len_pre,i_wid_pre);
                % If the gradient of the current pixel is smaller than the
                % next pixel, set it to 0
                if curr_pix_grad < pre_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
                end
            % If all the pixels are in the range, perform comparison on all
            % previous, current and next pixel
            else
                nex_pix_grad = M(i_len_nex,i_wid_nex);
                curr_pix_grad = M(i_len,i_wid);
                pre_pix_grad = M(i_len_pre,i_wid_pre);
                % If the current pixel is not the maximum of all three, set
                % it to 0
                if curr_pix_grad < nex_pix_grad || curr_pix_grad < pre_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
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
             if (i_len_pre < 1 || i_wid_pre < 1) && (i_len_nex <= length_M && i_wid_nex <= width_M)
                 curr_pix_grad = M(i_len,i_wid);
                 nex_pix_grad = M(i_len_nex,i_wid_nex);
                 % If the current pixel is smaller than the next pixel, set
                 % it to 0
                 if curr_pix_grad < nex_pix_grad
                     max_sup_M(i_len,i_wid) = 0;
                 else
                     max_sup_M(i_len,i_wid) = curr_pix_grad;
                 end
             % If next pixel falls out of the range, just perform the comparison
             % for previous pixel
             elseif (i_len_nex > length_M || i_wid_nex > width_M) && (i_len_pre >= 1 && i_wid_pre >= 1)
                curr_pix_grad = M(i_len,i_wid);
                pre_pix_grad = M(i_len_pre,i_wid_pre);
                % If the current pixel is smaller than the previous pixel,
                % set it to 0
                if curr_pix_grad < pre_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
                end
             % If both previous pixel falls out of range, don't perform
             % comparison store the current pixel gradient directly
             elseif (i_len_pre < 1 || i_wid_pre < 1) && (i_len_nex > length_M || i_wid_nex > width_M)
                 curr_pix_grad = M(i_len,i_wid);
                 max_sup_M(i_len,i_wid) = curr_pix_grad;
             % If all the pixels are in the range, perform comparison on all
             % previous, current and next pixel
             else
                 nex_pix_grad = M(i_len_nex,i_wid_nex);
                 curr_pix_grad = M(i_len,i_wid);
                 pre_pix_grad = M(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous or next pixel,
                 % set it to 0        
                 if curr_pix_grad < pre_pix_grad || curr_pix_grad < nex_pix_grad
                     max_sup_M(i_len,i_wid) = 0;
                 else
                     max_sup_M(i_len,i_wid) = curr_pix_grad;
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
                curr_pix_grad = M(i_len,i_wid);
                nex_pix_grad = M(i_len_nex,i_wid_nex);
                % If the current pixel is smaller than the next pixel, set
                % it to 0
                if curr_pix_grad < nex_pix_grad
                   max_sup_M(i_len,i_wid) = 0;
                else
                   max_sup_M(i_len,i_wid) = curr_pix_grad;
                end
             % If next pixel falls out of the range, just perform the comparison
             % for previous pixel
             elseif i_len_nex > length_M
                 curr_pix_grad = M(i_len,i_wid);
                 pre_pix_grad = M(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous pixel, set
                 % it to 0 
                 if curr_pix_grad < pre_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                 else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
                 end
             % If all the pixels are in the range, perform comparison on all
             % previous, current and next pixel
             else
                 nex_pix_grad = M(i_len_nex,i_wid_nex);
                 curr_pix_grad = M(i_len,i_wid);
                 pre_pix_grad = M(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous or next pixel,
                 % set it to 0 
                 if curr_pix_grad < pre_pix_grad || curr_pix_grad < nex_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                 else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
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
            if (i_len_pre < 1 || i_wid_pre > width_M) && (i_len_nex <= length_M && i_wid_nex >= 1) 
                curr_pix_grad = M(i_len,i_wid);
                nex_pix_grad = M(i_len_nex,i_wid_nex);
                % If the current pixel is smaller than the next pixel, set
                % it to 0
                if curr_pix_grad < nex_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
                end
             % If next pixel falls out of the range, just perform the comparison
             % for previous pixel
             elseif (i_len_nex > length_M || i_wid_nex < 1) && (i_len_pre >= 1 && i_wid_pre <= width_M)
                 curr_pix_grad = M(i_len,i_wid);
                 pre_pix_grad = M(i_len_pre,i_wid_pre);
                % If the current pixel is smaller than the next pixel, set
                % it to 0
                if curr_pix_grad < pre_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
                end
             % If all pixels fall out of the range, don't perform
             % comparioson and store the current magnitude directly
            elseif (i_len_pre < 1 || i_wid_pre > width_M) && (i_len_nex > length_M || i_wid_nex < 1)
                curr_pix_grad = M(i_len,i_wid);
                max_sup_M(i_len,i_wid) = curr_pix_grad;
             % If all the pixels are in the range, perform comparison on all
             % previous, current and next pixel
             else
                 nex_pix_grad = M(i_len_nex,i_wid_nex);
                 curr_pix_grad = M(i_len,i_wid);
                 pre_pix_grad = M(i_len_pre,i_wid_pre);
                 % If the current pixel is smaller than the previous or next pixel,
                 % set it to 0 
                 if curr_pix_grad < pre_pix_grad || curr_pix_grad < nex_pix_grad
                    max_sup_M(i_len,i_wid) = 0;
                 else
                    max_sup_M(i_len,i_wid) = curr_pix_grad;
                 end
             end
         end
     end
end

% Generate high and low thresholding matrix
edge_img_low = zeros(length_M,width_M);
edge_img_high = zeros(length_M,width_M);
for i_len_edg=1:length_M
    for i_wid_edg=1:width_M
        if max_sup_M(i_len_edg,i_wid_edg) < threshold_h
           edge_img_high(i_len_edg,i_wid_edg) = 0;
           if max_sup_M(i_len_edg,i_wid_edg) < threshold_l
              edge_img_low(i_len_edg,i_wid_edg) = 0;
           else
              edge_img_low(i_len_edg,i_wid_edg) = max_sup_M(i_len_edg,i_wid_edg);
           end
        else
           edge_img_high(i_len_edg,i_wid_edg) = max_sup_M(i_len_edg,i_wid_edg);
           edge_img_low(i_len_edg,i_wid_edg) = max_sup_M(i_len_edg,i_wid_edg);
        end
    end
end

% Determine edge orientation 
for i_len=1:length_M
    for i_wid=1:width_M
        if edge_img_high>0
            y_loc = dy(i_len,i_wid);
            x_loc = dx(i_len,i_wid);
            theta = atan2(y_loc,x_loc);
            % Sort out edge orientation
            % 0 degree (edge orientation: 90 degrees)
            if theta<pi/8 && theta>(-1)*pi/8
                i_wid_nex = i_wid;
                i_len_nex = i_len+1;
                i_wid_pre = i_wid;
                i_len_pre = i_len-1;
                % Check if the index stays withing the range
                if (i_len_nex <= length_M) && (i_len_pre >= 1)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre) + prev_pix;   
                   end
               % if the previous index falls and next stays 
               elseif i_len_pre < 1 && i_len_nex <= length_M
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex) + next_pix;
                   end
               % if the next index falls and previous stays 
               elseif i_len_pre >= 1 && i_len_nex > length_M
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+ prev_pix;   
                   end
               end

            % 45 degrees (edge orientation: 135 degrees)
            elseif theta>=pi/8 && theta<3*pi/8
                i_wid_nex = i_wid-1;
                i_len_nex = i_len+1;
                i_wid_pre = i_wid+1;
                i_len_pre = i_len-1;
                % Check if the indices falls out of the range
                if (i_wid_nex>=1 && i_len_nex<=length_M) && (i_wid_pre<=width_M && i_len_pre>=1)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                % if the previous index falls and next stays 
                elseif (i_wid_pre>width_M || i_len_pre<1) && (i_wid_nex>=1 && i_len_nex<=length_M)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                % if the previous index falls and next stays 
                elseif (i_wid_pre<=width_M && i_len_pre>=1) && (i_wid_nex<1 || i_len_nex>length_M)
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                end

            % 90 degrees (edge orientation: 180 degrees)
            elseif theta>=3*pi/8 && theta<5*pi/8
                i_wid_nex = i_wid+1;
                i_len_nex = i_len;
                i_wid_pre = i_wid-1;
                i_len_pre = i_len;
                % Check if all indices stays within the range
                if i_wid_nex<=width_M && i_wid_pre>=1
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                % if previous falls out of the range and next stays
                elseif i_wid_pre<1 && i_wid_nex<=width_M
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                % if previous stays and next falls
                elseif i_wid_pre>=1 && i_wid_nex>width_M
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                end

            % 135 degrees (edge orientation: 225 degrees)
            elseif theta>=5*pi/8 && theta<7*pi/8
                i_wid_nex = i_wid-1;
                i_len_nex = i_len-1;
                i_wid_pre = i_wid+1;
                i_len_pre = i_len+1;
                % Check if all indices stays within the range
                if (i_wid_pre<=width_M && i_len_pre<=length_M) && (i_wid_nex>=1 && i_wid_nex>=1)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                % if previous falls out of the range and next stays
                elseif (i_wid_pre>width_M || i_len_pre>length_M) && (i_wid_nex>=1 && i_wid_nex>=1)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                % if next falls out of the range and previous stays
                elseif (i_wid_pre<=width_M && i_len_pre<=length_M) && (i_wid_nex<1 && i_wid_nex<1)
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre); 
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                end

            % 180 degrees (edge orientation: 270 degrees)
            elseif theta>=7*pi/8 || theta<(-7)*pi/8
                i_wid_nex = i_wid-1;
                i_len_nex = i_len;
                i_wid_pre = i_wid+1;
                i_len_pre = i_len;
                % Check if all indices stays within the range
                if wid_nex>=1 && i_wid_pre<=width_M
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                % if previous falls and next stays
                elseif wid_nex>=1 && i_wid_pre>width_M
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                % if next falls and previous stays
                elseif wid_nex<1 && i_wid_pre<=width_M
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                end

            % 225 degrees (edge orientation: 315 degrees)
            elseif theta>=(-7)*pi/8 && theta<(-5)*pi/8
                i_wid_nex = i_wid+1;
                i_len_nex = i_len-1;
                i_wid_pre = i_wid-1;
                i_len_pre = i_len+1;
                % Check if all indices fall in the range
                if (i_wid_nex<=width_M && i_len_nex>=1) && (i_wid_pre>=1 && i_len_pre<=length_M)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                % if previous falls out of the range and next stays
                elseif (i_wid_nex<=width_M && i_len_nex>=1) && (i_wid_pre<1 || i_len_pre>length_M)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                % if next falls out of the range and previous stays
                elseif (i_wid_nex>width_M && i_len_nex<1) && (i_wid_pre>=1 && i_len_pre<=length_M)
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                end

            % 270 degrees (edge orientation: 0 degree)
            elseif theta>=(-5)*pi/8 && theta<(-3)*pi/8
                i_wid_nex = i_wid+1;
                i_len_nex = i_len;
                i_wid_pre = i_wid-1;
                i_len_pre = i_len;
                % Check if all indices stays within the range
                if i_wid_pre>=1 && i_wid_nex<=length_M
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                % if previous falls out of the range and next stays
                elseif i_wid_pre<1 && i_wid_nex<=length_M
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                % if next falls out of the range and previous stays
                elseif i_wid_pre>=1 && i_wid_nex>length_M
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                end

            % 315 degrees (edge orientation: 45 degrees)
            elseif theta>=(-3)*pi/8 && theta<(-1)*pi/8
                i_wid_nex = i_wid+1;
                i_len_nex = i_len+1;
                i_wid_pre = i_wid-1;
                i_len_pre = i_len-1;
                % Check if all indices stay within the range
                if (i_wid_nex<=width_M && i_len_nex<=length_M) && (i_wid_pre>=1 && i_len_pre>=1)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                % if previous falls out of the range and next stays
                elseif (i_wid_nex<=width_M && i_len_nex<=length_M) && (i_wid_pre<1 || i_len_pre<1)
                   next_pix = max_sup_M(i_len_nex,i_wid_nex);
                   % if the next pixel is within the range of high and low
                   % threshold then store
                   if next_pix < threshold_h && next_pix > threshold_l
                      edge_img_high(i_len_nex,i_wid_nex) = edge_img_high(i_len_nex,i_wid_nex)+next_pix;
                   end
                % if next falls out of the range and previous stays
                elseif (i_wid_nex>width_M && i_len_nex>length_M) && (i_wid_pre>=1 && i_len_pre>=1)
                   prev_pix = max_sup_M(i_len_pre,i_wid_pre);                   
                   % if the previous pixel is within the range of high and low
                   % threshold then store
                   if prev_pix < threshold_h && prev_pix > threshold_l
                      edge_img_high(i_len_pre,i_wid_pre) = edge_img_high(i_len_pre,i_wid_pre)+prev_pix;   
                   end
                end
            end
        end
    end
end

% Binarization
outcome = zeros(length_M,width_M);
for i_len_edg=1:length_M
    for i_wid_edg=1:width_M
        % If the non max suppression value is below threshold, set it to zero, otherwise, set
        % it to 255
        if edge_img_high(i_len_edg,i_wid_edg) <= 0 
           outcome(i_len_edg,i_wid_edg) = 0;
        else
           outcome(i_len_edg,i_wid_edg) = 255;
        end
    end
end

% Convert the Outcome Back to 8-Bit Unsinged Integer 
outcome = uint8(outcome);


end