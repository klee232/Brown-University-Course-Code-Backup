function corners = corner_detector(image)
% Convert the image from color to grayscale
if size(image,3)==3
    gray_image = rgb2gray(image);
else
    gray_image = image;
end
gray_image = double(gray_image);

% Create gaussian filter
sigma=0.7;
wind_size = ceil(6*sigma);
gauss_filt = fspecial('gaussian',[wind_size wind_size],sigma);
% Create x and y derivative gaussian filter
[Gx, Gy] = gradient(gauss_filt);

% Convolve with input image
f_x = conv2(gray_image,Gx,'same');
f_y = conv2(gray_image,Gy,'same');

% Create three spatial maps
f_x_2 = f_x.*f_x;
f_y_2 = f_y.*f_y;
f_x_y = f_x.*f_y;
% Create second gaussian filter
sigma2 = 2.0;
gauss_filt2 = fspecial('gaussian',[wind_size wind_size],sigma2);
% Convolve with the three spatial maps
s_x = conv2(f_x_2,gauss_filt2,'same');
s_y = conv2(f_y_2,gauss_filt2,'same');
s_xy = conv2(f_x_y,gauss_filt2,'same');

% Compute R
% Retrieve the sizes of matrix s_x, s_y, and s_xy
length_s = size(s_x,1);
width_s = size(s_x,2);
% Create R matrix for storing
R = zeros(length_s,width_s);
% Looping through each
for i_len=1:length_s
    for i_wid=1:width_s
       % grab out all corresponding points in s_x, s_y, and s_xy
       s_x_point = s_x(i_len,i_wid);
       s_xy_point = s_xy(i_len,i_wid);
       s_y_point = s_y(i_len,i_wid);
       % form corresponsing M matrix
       M = [s_x_point s_xy_point; s_xy_point s_y_point];
       % obtain corresponding R value
       alpha = 0.04;
       R_val = det(M)-alpha*power(trace(M),2);
       % store the value into R
       R(i_len,i_wid) = R_val;
    end
end


% Conduct non-maximum suppression
% Create non-max suppression storage
non_max_M = zeros(length_s, width_s);
for i_len=1:length_s
    for i_wid=1:width_s
       % Grab out the the region of interest
       len_rang = i_len-1:i_len+1;
       wid_rang = i_wid-1:i_wid+1;
       % check if the range falls out of the range
       % if the index falls out of the start of the image length
       if i_len-1 < 1 
           len_rang = 1:i_len+1;
       end
       % if the index falls out of the end of the image length
       if i_len+1 > length_s
           len_rang = i_len-1:length_s;
       end
       % if the index falls out of the start of the image width
       if i_wid-1 < 1
           wid_rang = 1:i_wid+1;
       end
       % if the index falls out of the end of the image width
       if i_wid+1 > width_s
           wid_rang = i_wid-1:width_s;
       end
       % grab out the region of interest
       region_of_interest = R(len_rang,wid_rang);
       
       % grab out the maximum value of the region of interest
       max_regofint = max(region_of_interest,[],'all');
       
       % check if the current pixel value matches the maximum
       % if it's less than the maximum, then ignore it
       if R(i_len,i_wid) < max_regofint
           non_max_M(i_len,i_wid)=0;
       else
           non_max_M(i_len,i_wid) = R(i_len,i_wid);
       end
    end
end

% final thresholding stage
R0 = 0.01*max(non_max_M,[],'all');
non_max_M(non_max_M<R0) = 0;


% corners = uint8(non_max_M);
[corner_y, corner_x, strength] = find(non_max_M);

corners = [corner_y, corner_x, strength];

end
