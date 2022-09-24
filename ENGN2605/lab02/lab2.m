% Main Function of this Lab
function lab2()
% Problem 1 Implement a 2D Convolution Function
% Create A Filter and An Image
image = magic(10);
filter = ones(3,3);
% Conduct Convolution
my_output = my_conv(image,filter,'none');
matlab_output = imfilter(image,filter);
matlab_output = uint8(matlab_output);
disp('Are the outputs of two functions the same?')
disp(isequal(my_output, matlab_output));

% Problem 2
mkdir problem2
% Smoothing Filter
% Box filter
box_filt = (1/9)*ones(3,3);
% Weighted Box Filter
weigh_box_filt_row1 = [1 2 1];
weigh_box_filt_row2 = [2 4 2];
weigh_box_filt_row3 = [1 2 1];
weigh_box_filt = (1/16).*cat(1, weigh_box_filt_row1,...
                        weigh_box_filt_row2,...
                        weigh_box_filt_row3);
% Horizontal Filter
hor_filt_row1 = [0 0 0];
hor_filt_row2 = [1 1 1];
hor_filt_row3 = [0 0 0];
hor_filt = (1/3)*cat(1, hor_filt_row1,...
                  hor_filt_row2,...
                  hor_filt_row3);
% Vertical Filter
ver_filt_row1 = [0 1 0];
ver_filt_row2 = [0 1 0];
ver_filt_row3 = [0 1 0];
ver_filt = (1/3)*cat(1, ver_filt_row1,...
                  ver_filt_row2,...
                  ver_filt_row3);
% Circular-Shape Filter
cir_filt_row1 = [0 1 0];
cir_filt_row2 = [1 1 1];
cir_filt_row3 = [0 1 0];
cir_filt = (1/5)*cat(1, cir_filt_row1,...
                  cir_filt_row2,...
                  cir_filt_row3);
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
% Conduct Convolution
image1 = imread('Lenna.png');
image2 = imread('traffic.jpg');
% Smoothing Filters
% 3*3 Box Filter
box_output1 = my_conv(image1,box_filt,'none');
box_output1 = uint8(box_output1);
box_output2 = my_conv(image2,box_filt,'none');
box_output2 = uint8(box_output2);
matlab_output1 = imfilter(image1,box_filt);
matlab_output2 = imfilter(image2,box_filt);
imwrite(box_output1,'problem2\box_output1.png');
imwrite(box_output2,'problem2\box_output2.jpg');
% 3*3 Wieghted Box Filter
weigh_box_output1 = my_conv(image1,weigh_box_filt,'none');
weigh_box_output2 = my_conv(image2,weigh_box_filt,'none');
matlab_output1 = imfilter(image1,weigh_box_filt);
matlab_output2 = imfilter(image2,weigh_box_filt);
imwrite(weigh_box_output1,'problem2\weigh_box_output1.png');
imwrite(weigh_box_output2,'problem2\weigh_box_output2.jpg');
imwrite(matlab_output1,'problem2\matlab_output1.png');
imwrite(matlab_output2,'problem2\matlab_output2.jpg');
% Horizontal Filter
hor_output1 = my_conv(image1,hor_filt,'none');
hor_output1 = uint8(hor_output1);
hor_output2 = my_conv(image2,hor_filt,'none');
hor_output2 = uint8(hor_output2);
matlab_output1 = imfilter(image1,hor_filt);
matlab_output2 = imfilter(image2,hor_filt);
imwrite(hor_output1,'problem2\hor_output1.png');
imwrite(hor_output2,'problem2\hor_output2.jpg');
% Vertical Filter
ver_output1 = my_conv(image1,ver_filt,'none');
ver_output1 = uint8(ver_output1);
ver_output2 = my_conv(image2,ver_filt,'none');
ver_output2 = uint8(ver_output2);
matlab_output1 = imfilter(image1,ver_filt);
matlab_output2 = imfilter(image2,ver_filt);
imwrite(ver_output1,'problem2\ver_output1.png');
imwrite(ver_output2,'problem2\ver_output2.jpg');
% 3*3 Circular Shaped Filter
cir_output1 = my_conv(image1,cir_filt,'none');
cir_output1 = uint8(cir_output1);
cir_output2 = my_conv(image2,cir_filt,'none');
cir_output2 = uint8(cir_output2);
matlab_output1 = imfilter(image1,cir_filt);
matlab_output2 = imfilter(image2,cir_filt);
imwrite(cir_output1,'problem2\cir_output1.png');
imwrite(cir_output2,'problem2\cir_output2.jpg');
% 5*5 Box Filter
ff_box_output1 = my_conv(image1,ff_box_filt,'none');
ff_box_output1 = uint8(ff_box_output1);
ff_box_output2 = my_conv(image2,ff_box_filt,'none');
ff_box_output2 = uint8(ff_box_output2);
matlab_output1 = imfilter(image1,ff_box_filt);
matlab_output2 = imfilter(image2,ff_box_filt);
imwrite(ff_box_output1,'problem2\ff_box_output1.png');
imwrite(ff_box_output2,'problem2\ff_box_output2.jpg');
% 5*5 Circular Shaped Filter
ff_cir_output1 = my_conv(image1,ff_cir_filt,'none');
ff_cir_output1 = uint8(ff_cir_output1);
ff_cir_output2 = my_conv(image2,ff_cir_filt,'none');
ff_cir_output2 = uint8(ff_cir_output2);
matlab_output1 = imfilter(image1,ff_cir_filt);
matlab_output2 = imfilter(image2,ff_cir_filt);
imwrite(ff_cir_output1,'problem2\ff_cir_output1.png');
imwrite(ff_cir_output2,'problem2\ff_cir_output2.jpg');
% Enhancement FIlter
% 4*4 Laplacian 
frfr_lap_row1 = [0 1 0];
frfr_lap_row2 = [1 -4 1];
frfr_lap_row3 = [0 1 0];
frfr_lap_filt = cat(1, frfr_lap_row1,...
                       frfr_lap_row2,...
                       frfr_lap_row3);
% 8*8 Laplacian 
ee_lap_row1 = [1 1 1];
ee_lap_row2 = [1 -8 1];
ee_lap_row3 = [1 1 1];
ee_lap_filt = cat(1, ee_lap_row1,...
                     ee_lap_row2,...
                     ee_lap_row3);
image1 = imread('ImageA.jpg');
image2 = imread('ImageB.jpg');
% 4*4 Laplacian Filter
frfr_lap_output1 = my_conv(image1,frfr_lap_filt,'none');
frfr_lap_output1 = uint8(frfr_lap_output1);
frfr_lap_output2 = my_conv(image2,frfr_lap_filt,'none');
frfr_lap_output2 = uint8(frfr_lap_output2);
matlab_output1 = imfilter(image1,frfr_lap_filt);
matlab_output2 = imfilter(image2,frfr_lap_filt);
imwrite(frfr_lap_output1, 'problem2\frfr_lap_output1.jpg');
imwrite(frfr_lap_output2, 'problem2\frfr_lap_output2.jpg');
% 8*8 Laplacian Filter
ee_lap_output1 = my_conv(image1,ee_lap_filt,'none');
ee_lap_output1 = uint8(ee_lap_output1);
ee_lap_output2 = my_conv(image2,ee_lap_filt,'none');
ee_lap_output2 = uint8(ee_lap_output2);
matlab_output1 = imfilter(image1,ee_lap_filt);
matlab_output2 = imfilter(image2,ee_lap_filt);
imwrite(ee_lap_output1, 'problem2\ee_lap_output1.jpg');
imwrite(ee_lap_output2, 'problem2\ee_lap_output2.jpg');
% Edge Filter
% Prewitt X Filter
pre_x_row1 = [1 0 -1];
pre_x_row2 = [1 0 -1];
pre_x_row3 = [1 0 -1];
pre_x_filt = cat(1, pre_x_row1,...
                    pre_x_row2,...
                    pre_x_row3);
% Prewitt Y Filter
pre_y_row1 = [1 1 1];
pre_y_row2 = [0 0 0];
pre_y_row3 = [-1 -1 -1];
pre_y_filt = cat(1, pre_y_row1,...
                    pre_y_row2,...
                    pre_y_row3);
% Sobel X Filter
sob_x_row1 = [1 0 -1];
sob_x_row2 = [2 0 -2];
sob_x_row3 = [1 0 -1];
sob_x_filt = cat(1, sob_x_row1,...
                    sob_x_row2,...
                    sob_x_row3);
% Sobel Y Filter
sob_y_row1 = [1 2 1];
sob_y_row2 = [0 0 0];
sob_y_row3 = [-1 -2 -1];
sob_y_filt = cat(1, sob_y_row1,...
                    sob_y_row2,...
                    sob_y_row3);
% Prewitt X Filter
pre_x_output1 = my_conv(image1,pre_x_filt,'none');
pre_x_output1 = uint8(pre_x_output1);
pre_x_output2 = my_conv(image2,pre_x_filt,'none');
pre_x_output2 = uint8(pre_x_output2);
matlab_output1 = imfilter(image1,pre_x_filt);
matlab_output2 = imfilter(image2,pre_x_filt);
imwrite(pre_x_output1,'problem2\pre_x_output1.jpg');
imwrite(pre_x_output2,'problem2\pre_x_output2.jpg');
% Prewitt Y Filter
pre_y_output1 = my_conv(image1,pre_y_filt,'none');
pre_y_output1 = uint8(pre_y_output1);
pre_y_output2 = my_conv(image2,pre_y_filt,'none');
pre_y_output2 = uint8(pre_y_output2);
matlab_output1 = imfilter(image1, pre_y_filt);
matlab_output2 = imfilter(image2, pre_y_filt);
imwrite(pre_y_output1,'problem2\pre_y_output1.jpg');
imwrite(pre_y_output2,'problem2\pre_y_output2.jpg');
% Sobel X Filter 
sob_x_output1 = my_conv(image1,sob_x_filt,'none');
sob_x_output1 = uint8(sob_x_output1);
sob_x_output2 = my_conv(image2,sob_x_filt,'none');
sob_x_output2 = uint8(sob_x_output2);
matlab_output1 = imfilter(image1, sob_x_filt);
matlab_output2 = imfilter(image2, sob_x_filt);
imwrite(sob_x_output1,'problem2\sob_x_output1.jpg');
imwrite(sob_x_output2,'problem2\sob_x_output2.jpg');
% Sobel Y Filter
sob_y_output1 = my_conv(image1,sob_y_filt,'none');
sob_y_output1 = uint8(sob_y_output1);
sob_y_output2 = my_conv(image2,sob_y_filt,'none');
sob_y_output2 = uint8(sob_y_output2);
matlab_output1 = imfilter(image1, sob_y_filt);
matlab_output2 = imfilter(image2, sob_y_filt);
imwrite(sob_y_output1,'problem2\sob_y_output1.jpg');
imwrite(sob_y_output2,'problem2\sob_y_output2.jpg');

% Problem 3 Gaussian Smoothing
mkdir problem3
image1 = imread('Lenna.png');
image2 = imread('traffic.jpg');
% Window Size of 3
% Sigma of 0.5
kernel3_half = gauss_kernel(3, 0.5);
kernel3_half_matlab = fspecial('gaussian',3, 0.5);
kernel3_half_output1 = my_conv(image1,kernel3_half,'none');
kernel3_half_output2 = my_conv(image2,kernel3_half,'none');
imwrite(kernel3_half_output1,'problem3\kernel3_half_output1.png');
imwrite(kernel3_half_output2,'problem3\kernel3_half_output2.jpg');
% Sigma of 1
kernel3_one = gauss_kernel(3, 1);
kernel3_one_matlab = fspecial('gaussian',3, 1);
kernel3_one_output1 = my_conv(image1,kernel3_one,'none');
kernel3_one_output2 = my_conv(image2,kernel3_one,'none');
imwrite(kernel3_one_output1, 'problem3\kernel3_one_output1.png');
imwrite(kernel3_one_output2, 'problem3\kernel3_one_output2.jpg');
% Sigma of 2
kernel3_two = gauss_kernel(3, 2);
kernel3_two_matlab = fspecial('gaussian',3, 2);
kernel3_two_output1 = my_conv(image1,kernel3_two,'none');
kernel3_two_output2 = my_conv(image2,kernel3_two,'none');
imwrite(kernel3_two_output1, 'problem3\kernel3_two_output1.png');
imwrite(kernel3_two_output2, 'problem3\kernel3_two_output2.jpg');

% Window Size of 5
% Sigma of 0.5
kernel5_half = gauss_kernel(5, 0.5);
kernel5_half_matlab = fspecial('gaussian',5, 0.5);
kernel5_half_output1 = my_conv(image1,kernel5_half,'none');
kernel5_half_output2 = my_conv(image2,kernel5_half,'none');
imwrite(kernel5_half_output1,'problem3\kernel5_half_output1.png');
imwrite(kernel5_half_output2,'problem3\kernel5_half_output2.jpg');
% Sigma of 1
kernel5_one = gauss_kernel(5, 1);
kernel5_one_matlab = fspecial('gaussian',5, 1);
kernel5_one_output1 = my_conv(image1,kernel5_one,'none');
kernel5_one_output2 = my_conv(image2,kernel5_one,'none');
imwrite(kernel5_one_output1, 'problem3\kernel5_one_output1.png');
imwrite(kernel5_one_output2, 'problem3\kernel5_one_output2.jpg');
% Sigma of 2
kernel5_two = gauss_kernel(5, 2);
kernel5_two_matlab = fspecial('gaussian',5, 2);
kernel5_two_output1 = my_conv(image1,kernel5_two,'none');
kernel5_two_output2 = my_conv(image2,kernel5_two,'none');
imwrite(kernel5_two_output1, 'problem3\kernel5_two_output1.png');
imwrite(kernel5_two_output2, 'problem3\kernel5_two_output2.jpg');

% Window Size of 7
% Sigma of 0.5
kernel7_half = gauss_kernel(7, 0.5);
kernel7_half_matlab = fspecial('gaussian',7, 0.5);
kernel7_half_output1 = my_conv(image1,kernel7_half,'none');
kernel7_half_output2 = my_conv(image2,kernel7_half,'none');
imwrite(kernel7_half_output1,'problem3\kernel7_half_output1.png');
imwrite(kernel7_half_output2,'problem3\kernel7_half_output2.jpg');
% Sigma of 1
kernel7_one = gauss_kernel(7, 1);
kernel7_one_matlab = fspecial('gaussian',7, 1);
kernel7_one_output1 = my_conv(image1,kernel7_one,'none');
kernel7_one_output2 = my_conv(image2,kernel7_one,'none');
imwrite(kernel7_one_output1, 'problem3\kernel7_one_output1.png');
imwrite(kernel7_one_output2, 'problem3\kernel7_one_output2.jpg');
% Sigma of 2
kernel7_two = gauss_kernel(7, 2);
kernel7_two_matlab = fspecial('gaussian',7, 2);
kernel7_two_output1 = my_conv(image1,kernel7_two,'none');
kernel7_two_output2 = my_conv(image2,kernel7_two,'none');
imwrite(kernel7_two_output1, 'problem3\kernel7_two_output1.png');
imwrite(kernel7_two_output2, 'problem3\kernel7_two_output2.jpg');

% Problem 4
mkdir problem4
image = imread('salt_and_pepper_coins.png');
% 3*3 Window
filter = ones(3,3);
min3_output = my_conv(image,filter,'min');
imwrite(min3_output,'problem4\min3_output.png');
max3_output = my_conv(image,filter,'max');
imwrite(max3_output,'problem4\max3_output.png');
med3_output = my_conv(image,filter,'med');
imwrite(med3_output,'problem4\med3_output.png');

% 5*5 Window
filter = ones(5,5);
min5_output = my_conv(image,filter,'min');
imwrite(min5_output,'problem4\min5_output.png');
max5_output = my_conv(image,filter,'max');
imwrite(max5_output,'problem4\max5_output.png');
med5_output = my_conv(image,filter,'med');
imwrite(med5_output,'problem4\med5_output.png');

% 7*7 Window
filter = ones(7,7);
min7_output = my_conv(image,filter,'min');
imwrite(min7_output,'problem4\min7_output.png');
max7_output = my_conv(image,filter,'max');
imwrite(max7_output,'problem4\max7_output.png');
med7_output = my_conv(image,filter,'med');
imwrite(med7_output,'problem4\med7_output.png');

% Problem 5
mkdir problem5
% Applying Gaussian Smoothing and 5*5 Box Filters
image1 = imread('salt_and_pepper_coins.png');
image2 = imread('traffic.jpg');
gauss_filter = gauss_kernel(5,1);
box_filter = ff_box_filt;
gauss_output = my_conv(image1,gauss_filter,'none');
box_output = my_conv(image1, box_filter,'none');
imwrite(gauss_output,'problem5\gauss_output.png');
imwrite(box_output,'problem5\box_output.png');

% Applying Median, Max and Min Filters
filter = ones(3,3);
min_output = my_conv(image2,filter,'min');
max_output = my_conv(image2,filter,'max');
med_output = my_conv(image2,filter,'med');
imwrite(min_output,'problem5\min_output.jpg');
imwrite(max_output,'problem5\max_output.jpg');
imwrite(med_output,'problem5\med_output.jpg');

% % Problem 6
% mkdir problem6
% % Conduct Separable Convolution and Compare it with the brute force
% image = imread('Lenna.png');
% % 5*5 Box Filter
% disp('5*5 Box Filter Separable Convolution Time:')
% sep_ff_box_output = conv_separable(image,ff_box_filt);
% disp('5*5 Box FIlter Brute Force Time:')
% ff_box_output = my_conv(image,ff_box_filt,'none');
% disp('Are the two convolution (5*5 box) images the same?')
% disp(isequal(sep_ff_box_output,ff_box_output));
% 
% % % 5*5 Circular Shape Filter
% % disp('5*5 Circular Filter Separable Convolution Time:')
% % tic
% % sep_ff_cir_output = conv_separable(image,ff_cir_filt);
% % toc
% % disp('5*5 Circular FIlter Brute Force Convolution TIme:')
% % tic
% % ff_cir_output = my_conv(image,ff_cir_filt,'none');
% % toc
% % disp('Are the two convolution (5*5 cir) images the same?')
% % disp(isequal(sep_ff_cir_output,ff_cir_output))
% 
% % 7*7 Gaussian with Sigma of 0.5
% gauss_filt7 = gauss_kernel(7, 0.5);
% disp('7*7 Gaussian Filter Separable Convolution Time:')
% sep_gauss_output7 = conv_separable(image,gauss_filt7);
% disp('7*7 Gaussian Filter Brute Force Convolution Time:')
% gauss_output7 = my_conv(image,gauss_filt7,'none');
% disp('Are the two convolution (7*7 gauss) images the same?')
% disp(isequal(sep_gauss_output7,gauss_output7));
% 
% % 17*17 Gaussian with Sigma of 0.5
% gauss_filt17 = gauss_kernel(17, 0.5);
% disp('17*17 Gaussian Filter Separable Convolution Time:')
% tic
% sep_gauss_output17 = conv_separable(image,gauss_filt17);
% toc
% disp('17*17 Gaussian Filter Brute Force Convolution Time:')
% tic
% gauss_output17 = my_conv(image,gauss_filt17,'none');
% toc
% disp('Are the two convolution (17*17 gauss) images the same?')
% disp(isequal(sep_gauss_output17,gauss_output17));
% 
% % 35*35 Gaussian with Sigma of 2
% gauss_filt35 = gauss_kernel(35, 2);
% disp('35*35 Gaussian Filter Separable Convolution Time:')
% tic
% sep_gauss_output35 = conv_separable(image,gauss_filt35);
% toc
% disp('35*35 Gaussian Filter Brute Force Convolution Time:')
% tic
% gauss_output35 = my_conv(image,gauss_filt35,'none');
% toc
% disp('Are the two convolution (35*35 gauss) images the same?')
% disp(isequal(sep_gauss_output35,gauss_output35));

% Problem 7
mkdir problem7
% Read Input Images
image1=imread('eyechart_degraded.jpg');
image2=imread('Circuit_Board_degraded.png');
% Read Point Spread Function
psf1 = importdata('psf_eye_chart.mat');
psf2 = importdata('psf_circuit_board.mat');
% Conduct Lucy Richardson Algorithm
res_image1 = lucy_richardson(image1,psf1);
res_image2 = lucy_richardson(image2,psf2);
matlab_res_image1 = deconvlucy(image1,psf1,100);
matlab_res_image2 = deconvlucy(image2,psf2,100);
imwrite(res_image1, 'problem7\res_image1.jpg');
imwrite(res_image2, 'problem7\res_image2.png');
imwrite(matlab_res_image1, 'problem7\matlab_res_image1.jpg');
imwrite(matlab_res_image2, 'problem7\matlab_res_image2.png');
filter = ones(3,3);
med_image1 = my_conv(image1,filter,'med');
med_image2 = my_conv(image2,filter,'med');
imwrite(med_image1, 'problem7\med_image1.jpg');
imwrite(med_image2, 'problem7\med_image2.png');
max_image1 = my_conv(image1,filter,'max');
max_image2 = my_conv(image2,filter,'max');
imwrite(max_image1, 'problem7\max_image1.jpg');
imwrite(max_image2, 'problem7\max_image2.png');
min_image1 = my_conv(image1,filter,'min');
min_image2 = my_conv(image2,filter,'min');
imwrite(min_image1, 'problem7\min_image1.jpg');
imwrite(min_image2, 'problem7\min_image2.png');
gauss_ker=gauss_kernel(35,0.5);
gauss_image1 = my_conv(image1,gauss_ker,'none');
gauss_image2 = my_conv(image2,gauss_ker,'none');
imwrite(gauss_image1,'problem7\gauss_image1.jpg');
imwrite(gauss_image2,'problem7\gauss_image2.png');

end


% Convolution (Modified for the usage of Problem 4)
% It accepts three inputs:
% image: the image that needs to be convolved
% filter: convolution kernel
% type: 
% 'none': normal convolution
% 'max': maximum pooling
% 'min': minimum pooling
% 'med': median pooling
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

% Gaussian Kenrel Generation Function
% Input:
% filter_size: size of gaussian kernel
% sigma: intended standard deviation
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

% Separable Convolution
% Same idea from normal convolution. Except for it only has function of
% normal convolution
function output = conv_separable(image,filter)
% Obtain the length, width, and channel number of the image
length_image = size(image,1);
width_image = size(image,2);
chan_image = size(image,3);

% Check if the filter matrix is separable 
if isfilterseparable(filter)==0
    error('The filter is not a separable filter')
end

% Grab out a row and columin vector of the filter matrix
length_filter = size(filter,1);
width_filter = size(filter,2);
[~,filter_col, filter_row] = isfilterseparable(filter);

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

% Conduct Column Convolution 
% Create Outcome Variable for Storage
outimage = zeros(length_image, width_image, chan_image);
% Create a temporary storage for the ourcome of column convolution
col_conv_temp = zeros(length_image,width_image+2*((width_filter-1)/2),chan_image); 
tic
for i_len_image=1:length_image
     for i_wid_image=1:width_image+2*((width_filter-1)/2)
        for i_chn_image=1:chan_image
            col_conv_temp(i_len_image,i_wid_image,i_chn_image) ... 
            = sum(zero_pad_image(i_len_image:i_len_image+length_filter-1,...
                                 i_wid_image,...
                                 i_chn_image).*filter_col, 'all');
        end
     end
end
% Conduct Row Convolution
for i_len_image=1:length_image
     for i_wid_image=1:width_image
        for i_chn_image=1:chan_image
            outimage(i_len_image,i_wid_image,i_chn_image) ... 
            = sum(col_conv_temp(i_len_image,...
                                i_wid_image:i_wid_image+width_filter-1,...
                                i_chn_image).*filter_row, 'all');
        end
     end
end
toc
output = uint8(outimage);

end

% Lucy Richardson Algorithm
function restored_image=lucy_richardson(degraded_image,psf)
% Set up number of iteration 
num_iter = 150;
g_image = double(degraded_image);
degraded_image = double(degraded_image);
psf = double(psf);
restored_image = 0;
% Conduct iteration
for i=1:num_iter
     if i==1
        reblur_image = conv2(degraded_image,psf,'same');
        var1 = g_image./reblur_image;
        var2 = psf;
        var3 = filter2(var2,var1);
        disp('g_image size:')
        disp(size(g_image))
        disp('var3 size:')
        disp(size(var3))
        restored_image = g_image.*var3;
    else
        reblur_image = conv2(degraded_image,psf,'same');
        var1 = g_image./reblur_image;
        var2 = psf;
        var3 = filter2(var2,var1);
        disp('restored image size:')
        disp(size(restored_image))
        disp('var3 size:')
        disp(size(var3))
        restored_image = restored_image.*var3;
    end
end

end
