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