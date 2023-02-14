function D = region_descriptors(image,corners, window_sz, descriptor_type)
    % get the image dimensions
    img_length = size(image,1);
    img_width = size(image,2);
    % create output storage variable
    length_corners = size(corners,1);

    % create D based on input string 
    if strmatch(descriptor_type,"pixels") 
        D = zeros(window_sz, window_sz, length_corners);
    elseif strmatch(descriptor_type, "histogram")
        num_bins = 30;
        D = zeros(length_corners,num_bins);
    else
        error("Unknown analysis method found. Please type in: pixels, or histogram.")
    end

    % extract corner x and y coordinates
    corners_x = corners(:,2);
    corners_y = corners(:,1);
    for i_corner=1:length_corners
        % grab out center point
        x_coord = corners_x(i_corner);
        y_coord = corners_y(i_corner);
        % set the window range
        offset = floor(window_sz/2);
        x_range = x_coord-offset:x_coord+offset;
        y_range = y_coord-offset:y_coord+offset;
        % check if it's out of image range
        % x coordinate
        if x_coord-offset < 1
           x_range = 1:x_coord+offset;
        elseif x_coord+offset > img_width
           x_range = x_coord-offset:img_width;
        end
        % y coordinate
        if y_coord-offset < 1
           y_range = 1:y_coord+offset;
        elseif y_coord+offset > img_length
           y_range = y_coord-offset:img_length;
        end

        % check input string
        % if the string is pixels, extract out the pixel values inside the
        % window
        if strmatch(descriptor_type,"pixels")
           out = image(y_range,x_range);
           out = double(out);
           len_out = size(out,1);
           wid_out = size(out,2); 
           for i_len=1:len_out
               for i_wid=1:wid_out
                   D(i_len,i_wid,i_corner) = out(i_len,i_wid);
               end
           end
      
        % if the input is histogram, output its bin values
        elseif strmatch(descriptor_type, "histogram")
            % normalize the pixels inside the window
            out = double(image(y_range,x_range));
            out = out-mean(out,[1 2]);
            out = double(out)./norm(double(image(y_range,x_range)));
            % flatten the out
            length_out = size(out,1);
            width_out = size(out,2);
            out = reshape(out,[1,length_out*width_out]);
            % generate histogram bin values
            out = hist(double(out),num_bins);
            D(i_corner,:) = out;

        else
            error("Unknown descriptor type has been input. Please try pixels or histogram");
        end
    end
end