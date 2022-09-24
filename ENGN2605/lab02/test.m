function test()

% 5*5 Box Filter
ff_box_filt = (1/25)*ones(5,5);
% 5*5 Circular-Shape Filter
ff_cir_filt_row1 = [0 1 1 1 0];
ff_cir_filt_row2 = [1 1 1 1 1];
ff_cir_filt_row3 = [1 1 1 1 1];
ff_cir_filt_row4 = [1 1 1 1 1];
ff_cir_filt_row5 = [0 1 1 1 0];
ff_cir_filt = (1/25)*cat(1,ff_cir_filt_row1,...
                           ff_cir_filt_row2,...
                           ff_cir_filt_row3,...
                           ff_cir_filt_row4,...
                           ff_cir_filt_row5);

% Problem 6
mkdir problem6
% Conduct Separable Convolution and Compare it with the brute force
image = imread('Lenna.png');
% 5*5 Box Filter
disp('5*5 Box Filter Separable Convolution Time:')
tic
sep_ff_box_output = sepconv2D(image,ff_box_filt);
toc
disp('5*5 Box FIlter Brute Force Time:')
tic
ff_box_output = conv2D(image,ff_box_filt);
% ff_original = my_conv(image,ff_box_filt,'none');
toc
disp('Are the two convolution (5*5 box) images the same?')
disp(isequal(sep_ff_box_output,ff_box_output));
% disp(isequal(ff_box_output,ff_original));

% % 5*5 Circular Shape Filter
% disp('5*5 Circular Filter Separable Convolution Time:')
% tic
% sep_ff_cir_output = conv_separable(image,ff_cir_filt);
% toc
% disp('5*5 Circular FIlter Brute Force Convolution TIme:')
% tic
% ff_cir_output = my_conv(image,ff_cir_filt,'none');
% toc
% disp('Are the two convolution (5*5 cir) images the same?')
% disp(isequal(sep_ff_cir_output,ff_cir_output))

% 7*7 Gaussian with Sigma of 0.5
gauss_filt7 = gauss_kernel(7, 0.5);
disp('7*7 Gaussian Filter Separable Convolution Time:')
tic
sep_gauss_output7 = sepconv2D(image,gauss_filt7);
toc
disp('7*7 Gaussian Filter Brute Force Convolution Time:')
tic
gauss_output7 = conv2D(image,gauss_filt7);
toc
disp('Are the two convolution (7*7 gauss) images the same?')
disp(isequal(sep_gauss_output7,gauss_output7));

% 17*17 Gaussian with Sigma of 0.5
gauss_filt17 = gauss_kernel(17, 0.5);
disp('17*17 Gaussian Filter Separable Convolution Time:')
tic
sep_gauss_output17 = sepconv2D(image,gauss_filt17);
toc
disp('17*17 Gaussian Filter Brute Force Convolution Time:')
tic
gauss_output17 = conv2D(image,gauss_filt17);
toc
disp('Are the two convolution (17*17 gauss) images the same?')
disp(isequal(sep_gauss_output17,gauss_output17));

% 35*35 Gaussian with Sigma of 2
gauss_filt35 = gauss_kernel(35, 2);
disp('35*35 Gaussian Filter Separable Convolution Time:')
tic
sep_gauss_output35 = sepconv2D(image,gauss_filt35);
toc
disp('35*35 Gaussian Filter Brute Force Convolution Time:')
tic
gauss_output35 = conv2D(image,gauss_filt35);
toc
disp('Are the two convolution (35*35 gauss) images the same?')
disp(isequal(sep_gauss_output35,gauss_output35));

end


function filter=gauss_kernel(filter_size,sigma)
% Figure out x and y range
xrang = -(filter_size-1)/2:(filter_size-1)/2;
yrang = -(filter_size-1)/2:(filter_size-1)/2;

% Generate Assigned Gaussian Kernel
% Create a Variable fot Storaging
filter = zeros(filter_size,filter_size);
% Looping through each element
for i_len_filt=1:filter_size
    for i_wid_filt=1:filter_size
        % Grab out the correlated x and y value
        x_val = xrang(i_len_filt);
        y_val = yrang(i_wid_filt);
        % Calculate the correlated value for kernel
        % store it into the assigned location
        x_sqa = x_val*x_val;
        y_sqa = y_val*y_val;
        nom = x_sqa + y_sqa;
        den = 2*sigma*sigma;
        e_pow = (-1)*(nom/den);
        filter(i_len_filt,i_wid_filt)=exp(e_pow);
    end
end

% Normalize the Filter Contents
norm = sum(filter,'all');
filter = filter./norm;
end

function output = conv2D(image,filter)
% Obtain the size of the image 
length_image = size(image,1);
width_image = size(image,2);
chan_image  = size(image,3);

% Obtain the size of the filter
length_filter = size(filter,1);
width_filter = size(filter,2);

% Zero Padding through image
% Create Variable for Storing Zero Padded Image
zero_pad_image = zeros(length_image+2*((length_filter-1)/2),width_image+2*((width_filter-1)/2),chan_image);
% Zero Padding through the Original Image
num_pad = (length_filter-1)/2;
for i_pad=1:num_pad
    for i_chan=1:chan_image
        % Create padding for each direction (horizontal and vertical)
        zero_pad_hzl = zeros(1,width_image+2*i_pad);
        zero_pad_vtl = zeros(length_image+2*(i_pad-1),1);
        % Concatenate zero padding for vertical direction
        % If this is the first padding concatenate with the original image
        % otherwise, concatenate it with the stored zero padded image
        if i_pad == 1
            zero_pad_image_temp = cat(2, zero_pad_vtl, image(:,:,i_chan));
        else
            zero_pad_image_temp = cat(2, zero_pad_vtl, zero_pad_image_temp);
        end
        zero_pad_image_temp = cat(2, zero_pad_image_temp, zero_pad_vtl);
        % Concatenate zero padding for horizontal direction
        zero_pad_image_temp = cat(1, zero_pad_hzl, zero_pad_image_temp);
        zero_pad_image_temp = cat(1, zero_pad_image_temp, zero_pad_hzl);
    end
end
zero_pad_image = zero_pad_image_temp;
zero_pad_image = double(zero_pad_image);

% Conduct convolution 
outimage = zeros(length_image, width_image, chan_image);

for i_len_image=1:length_image
    for i_wid_image=1:width_image
        for i_chn_image=1:chan_image
            con_current = 0;
            for i_len_point_filt=i_len_image:i_len_image+length_filter-1
                for i_wid_point_filt=i_wid_image:i_wid_image+width_filter-1
                    con_current = con_current + ...
                                  zero_pad_image(i_len_point_filt,...
                                                 i_wid_point_filt,...
                                                 i_chn_image)*...
                                  filter(i_len_point_filt-(i_len_image-1),...
                                         i_wid_point_filt-(i_wid_image-1));
                end
            end
            outimage(i_len_image,i_wid_image,i_chn_image) = con_current;
         end
    end
end
    output=outimage;
    output=uint8(output);
end


function outimage = my_conv(image,filter,type)
image=double(image);
% Get the length and width of input image 
length_image = size(image,1);
width_image = size(image,2);
chan_image = size(image,3);
% Get the length and width of filter
length_filter = size(filter,1);
width_filter = size(filter,2);

% Zero Padding through image
% Create Variable for Storing Zero Padded Image
zero_pad_image = zeros(length_image+2*((length_filter-1)/2),width_image+2*((width_filter-1)/2),chan_image);
% Zero Padding through the Original Image
num_pad = (length_filter-1)/2;
for i_pad=1:num_pad
    for i_chan=1:chan_image
        % Create padding for each direction (horizontal and vertical)
        zero_pad_hzl = zeros(1,width_image+2*i_pad);
        zero_pad_vtl = zeros(length_image+2*(i_pad-1),1);
        % Concatenate zero padding for vertical direction
        % If this is the first padding concatenate with the original image
        % otherwise, concatenate it with the stored zero padded image
        if i_pad == 1
            zero_pad_image_temp = cat(2, zero_pad_vtl, image(:,:,i_chan));
        else
            zero_pad_image_temp = cat(2, zero_pad_vtl, zero_pad_image_temp);
        end
        zero_pad_image_temp = cat(2, zero_pad_image_temp, zero_pad_vtl);
        % Concatenate zero padding for horizontal direction
        zero_pad_image_temp = cat(1, zero_pad_hzl, zero_pad_image_temp);
        zero_pad_image_temp = cat(1, zero_pad_image_temp, zero_pad_hzl);
    end
end
zero_pad_image = zero_pad_image_temp;
zero_pad_image = double(zero_pad_image);

% Create Outcome Variable for Storage
outimage = zeros(length_image, width_image, chan_image);
% Check the convolution type
% if it's none, conduct the typical convolution
if strcmp(type,'none')
    tic
    % Conduct Convolution on Zero Padded Image
    for i_len_image=1:length_image
        for i_wid_image=1:width_image
            for i_chn_image=1:chan_image
                outimage(i_len_image,i_wid_image,i_chn_image) ... 
                = sum(zero_pad_image(i_len_image:i_len_image+length_filter-1,...
                                     i_wid_image:i_wid_image+width_filter-1,...
                                     i_chn_image).*filter, 'all');
            end
        end
    end
    toc
    outimage = uint8(outimage);
    
% if it's min, conduct minimum pooling 
elseif strcmp(type,'min')
   % Conduct Convolution on Zero Padded Image
    for i_len_image=1:length_image
        for i_wid_image=1:width_image
            for i_chn_image=1:chan_image
                outimage(i_len_image,i_wid_image,i_chn_image) ... 
                = min(zero_pad_image(i_len_image:i_len_image+length_filter-1,...
                                     i_wid_image:i_wid_image+width_filter-1,...
                                     i_chn_image).*filter,[], 'all');
            end
        end
    end
    outimage = uint8(outimage); 
    
% if it's max, conduct maximum pooling
elseif strcmp(type,'max')
    % Conduct Convolution on Zero Padded Image
    for i_len_image=1:length_image
        for i_wid_image=1:width_image
            for i_chn_image=1:chan_image
                outimage(i_len_image,i_wid_image,i_chn_image) ... 
                = max(zero_pad_image(i_len_image:i_len_image+length_filter-1,...
                                     i_wid_image:i_wid_image+width_filter-1,...
                                     i_chn_image).*filter,[], 'all');
            end
        end
    end
    outimage = uint8(outimage);
    
% if it's med, conduct median pooling
elseif strcmp(type, 'med')
    % Conduct Convolution on Zero Padded Image
    for i_len_image=1:length_image
        for i_wid_image=1:width_image
            for i_chn_image=1:chan_image
                outimage(i_len_image,i_wid_image,i_chn_image) ... 
                = median(zero_pad_image(i_len_image:i_len_image+length_filter-1,...
                                     i_wid_image:i_wid_image+width_filter-1,...
                                     i_chn_image).*filter, 'all');
            end
        end
    end
    outimage = uint8(outimage);
    
% If none of this above send out error message    
else
    error('Plear type in: none for convolution, min for minimum pooling, max for maximum pooling, or med for median pooling')
end

end


function output = sepconv2D(image,filter)
% Obtain the size of the image 
length_image = size(image,1);
width_image = size(image,2);
chan_image  = size(image,3);

% Obtain the size of the filter
length_filter = size(filter,1);
width_filter = size(filter,2);

% Zero Padding through image
% Create Variable for Storing Zero Padded Image
zero_pad_image = zeros(length_image+2*((length_filter-1)/2),width_image+2*((width_filter-1)/2),chan_image);
% Zero Padding through the Original Image
num_pad = (length_filter-1)/2;
for i_pad=1:num_pad
    for i_chan=1:chan_image
        % Create padding for each direction (horizontal and vertical)
        zero_pad_hzl = zeros(1,width_image+2*i_pad);
        zero_pad_vtl = zeros(length_image+2*(i_pad-1),1);
        % Concatenate zero padding for vertical direction
        % If this is the first padding concatenate with the original image
        % otherwise, concatenate it with the stored zero padded image
        if i_pad == 1
            zero_pad_image_temp = cat(2, zero_pad_vtl, image(:,:,i_chan));
        else
            zero_pad_image_temp = cat(2, zero_pad_vtl, zero_pad_image_temp);
        end
        zero_pad_image_temp = cat(2, zero_pad_image_temp, zero_pad_vtl);
        % Concatenate zero padding for horizontal direction
        zero_pad_image_temp = cat(1, zero_pad_hzl, zero_pad_image_temp);
        zero_pad_image_temp = cat(1, zero_pad_image_temp, zero_pad_hzl);
    end
end
zero_pad_image = zero_pad_image_temp;
zero_pad_image = double(zero_pad_image);

[~,filter_col, filter_row] = isfilterseparable(filter);

% Conduct convolution
outimage = zeros(length_image, width_image, chan_image);

col_conv_temp = zeros(length_image,width_image+2*((width_filter-1)/2),chan_image); 
for i_len_image=1:length_image
    for i_wid_image=1:width_image+2*((width_filter-1)/2)
        for i_chn_image=1:chan_image
            con_current = 0;
            for i_len_point_filt=i_len_image:i_len_image+length_filter-1
                con_current = con_current + ...
                              zero_pad_image(i_len_point_filt,...
                                             i_wid_image,...
                                             i_chn_image)*...
                              filter_col(i_len_point_filt-(i_len_image-1),1);
            end
            col_conv_temp(i_len_image,i_wid_image,i_chn_image) = con_current;
        end
    end
end
           
for i_len_image=1:length_image
    for i_wid_image=1:width_image
        for i_chn_image=1:chan_image
            con_current = 0;
            for i_wid_point_filt=i_wid_image:i_wid_image+width_filter-1
                con_current = con_current + ...
                              col_conv_temp(i_len_image,...
                                             i_wid_point_filt,...
                                             i_chn_image)*...
                              filter_row(1,i_wid_point_filt-(i_wid_image-1));
            end
            outimage(i_len_image,i_wid_image,i_chn_image) = con_current;
        end
    end
end
   
output = outimage;
output = uint8(output);

end
 
    