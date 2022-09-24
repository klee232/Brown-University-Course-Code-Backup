function testfunc()

% Practice
% Basic image reading and writing
data = imread('ImageA.jpg');
imshow(data);
imwrite(data,'myfile.jpg');
% Convert color image to grayscale image
colorimage=imread('white_blood_cells.png');
grayimage=rgb2gray(colorimage);
% Convert it into double type
doubleimage = double(grayimage);
% convert it back to unsigned 8-bit integer image
finalimage = uint8(doubleimage);
imshow(finalimage)

% Problem 1 Thresholding
% Create Folder for Storing Results
mkdir problem1
% Single thresholding
threshold('white_blood_cells.png','regionofinterestwhiteblood_cells.png');
% Double thresholding
BiThreshold('filtered_snowman.jpg', 'regionofinterest1_snowman.jpg', 'regionofinterest2_snowman.jpg');

% Problem 2 Contrasting and Inversion
% Create Folder for Storing Results
mkdir problem2
% Contrasting (Or Brightening and Darkening)
contrast('ImageA.jpg', 25)
% Color Inversion
inversion('white_blood_cells.png')

% Problem 3 Quantization
% Create Folder for Storing Results
mkdir problem3
% By 8 Levels
quantization('white_blood_cells.png', 8)
% By 16 Levels
quantization('white_blood_cells.png', 16)


% Problem 4 Sampling
% Create Folder for Storing Results
mkdir problem4
% Sampled by 2
sampling('white_blood_cells.png',2);
% Sampled by 7
sampling('white_blood_cells.png',7);


% Problem 5 Camera (Sensor Noise)
% Create Folder for Storing Results
mkdir problem5
camera('image folder');


end

% SIngle Thresholding Function
% This function is built to create a reasonable threshold
% to conduct filtering (or thresholding) for the image.
function threshold(imageFile, regionFile)
% To start with this function, feed it with a image file and 
% a region of interest file.
inputImage = imread(imageFile);
regionOfInterest = imread(regionFile);

% Setting Up All Input Image As Double Type
inputImage = double(inputImage);
regionOfInterest = double(regionOfInterest);

% Calculate the Threshold 
% For analyzing purpose, the region of interest (in this case, a white 
% blood image) is cropped. This image of the region of interest will then
% be analyzed and its mean and standard deviation will then be utilized 
% for the purpose of setting up the threshold.
regionOfInterest_mean = mean(regionOfInterest,"all");
% Computing standard deviation
regionOfInterest_std = std(regionOfInterest, 1, "all");
disp('The mean of the single thresholding is:')
disp(regionOfInterest_mean)
disp('The std of the single thresholding is:')
disp(regionOfInterest_std)

% Set Up Threshold
% In this case, the assumption that the data distribution of the region 
% of interest follows gaussian distribution. 
% The threshold is set to be 1.323 standard deviation above the mean value
% (opted empirically)
threshold = regionOfInterest_mean + 1.323*regionOfInterest_std;

% Loop through Each Pixel and Check
% Obtain the height and width of the image 
inputImage_height = size(inputImage,1);
inputImage_width = size(inputImage,2);
% Create an new variable for storing new value for filtered image
filteredImage = zeros(inputImage_height,inputImage_width);
% Start looping
for (i=1:inputImage_height)
   for (j=1:inputImage_width)
       testPoint = inputImage(i,j);
       % Test it out
       % If it's above the threshold, set filted image to zero
       if(testPoint>threshold)
           filteredImage(i,j) = 0;
       % Otherwise, set it to 255
       else
           filteredImage(i,j) = 255;
       end
    end
end

% Writing the Final Filtered Image to A Single Image File
% Convert filtered image to double type
double_filteredImage = double(filteredImage);
% Convert back to unsigned 8-bit image
uint8_filteredImage = uint8(double_filteredImage);
figure(1);
imshow(uint8_filteredImage);

% Store the Result Image into A Created Folder
imwrite(uint8_filteredImage,'problem1\filtered_white_blood_cells.png');

end


% Bilevel Thresholding 
% Using the same idea from single thresholding except this one is a
% multi-level
function BiThreshold(imageFile, regionFile1, regionFile2)
% To start with this function, feed it with a image file and 
% two region of interest files. 
% (One for background and one for ground)
inputImage = imread(imageFile);
regionOfInterest1 = imread(regionFile1);
regionOfInterest2 = imread(regionFile2);

% Change All Input Image Files As Doulbe Type
inputImage = double(inputImage);
regionOfInterest1 = double(regionOfInterest1);
regionOfInterest2 = double(regionOfInterest2);

% Calculate the Threshold 
% Computing means for region of interest 1 and 2
regionOfInterest_mean1 = mean(regionOfInterest1,"all");
regionOfInterest_mean2 = mean(regionOfInterest2,"all");
% Computing standard deviations for region of interest 1 and 2
regionOfInterest_std1 = std(regionOfInterest1, 1, "all");
regionOfInterest_std2 = std(regionOfInterest2, 1, "all");
disp('The mean1 of the bilevel thresholding is:')
disp(regionOfInterest_mean1)
disp('The std1 of the bilevel thresholding is:')
disp(regionOfInterest_std1)
disp('The mean2 of the bilevel thresholding is:')
disp(regionOfInterest_mean2)
disp('The std2 of the bilevel thresholding is:')
disp(regionOfInterest_std2)
% Set up thresholds 
%(in this case it's set 2 standard deviation above the mean)
threshold1 = regionOfInterest_mean1 + 2*regionOfInterest_std1;
threshold2 = regionOfInterest_mean2 + 2*regionOfInterest_std2;

% Loop through Each Pixel And Check
% Obtain the height and width of the image 
inputImage_height = size(inputImage,1);
inputImage_width = size(inputImage,2);
% Create an new object for storing new value for filtered image
biFilteredImage = zeros(inputImage_height,inputImage_width);
% Find out which threshold is larger
test_thresholds = [threshold1 threshold2];
largerThreshold = max(test_thresholds);
smallerThreshold = min(test_thresholds);

% Start Looping
for (i=1:inputImage_height)
   for (j=1:inputImage_width)
       testPoint = inputImage(i,j);
       % Test it out
       % If it's below the larger threshold and also above the smaller thresdhold
       % set filted image to 255
       if(testPoint<largerThreshold && testPoint>smallerThreshold)
           biFilteredImage(i,j) = 255;
       % Otherwise, set it to 0
       else
           biFilteredImage(i,j) = 0;
       end
    end
end

% Writing the Final Filtered Image to A Single Image File Type
% Convert filtered image to double type
double_biFilteredImage = double(biFilteredImage);
% Convert back to unsigned 8-bit image
uint8_biFilteredImage = uint8(double_biFilteredImage);
figure(1);
imshow(uint8_biFilteredImage);

% Store the Results into Assigned Folder
imwrite(uint8_biFilteredImage,'problem1\biFiltered_snowman.jpg');

end


% Contrasting Function
function contrast(imageFile, contrast_threshold)
inputImage = imread(imageFile);

% Obtain the Height And Width of The Image 
inputImage_height = size(inputImage,1);
inputImage_width = size(inputImage,2);

% Create An New object for Storing New Value for Birghtened And Darkened
% Images
brightImage = zeros(inputImage_height,inputImage_width);
darkImage = zeros(inputImage_height,inputImage_width);

% Looping through Each Pixel And Check
for (i=1:inputImage_height)
    for(j=1:inputImage_width)
       % Brightened Image
       brightenedPixel = inputImage(i,j)+contrast_threshold;
       % Check if it falls out of the range of 255
       % If it does, set it to 255
       if (brightenedPixel>255)
           brightenedPixel = 255;
       end
       % Set up the brightened image matrix
       brightImage(i,j) = brightenedPixel;
       
       % Darkened Image
       darkenedPixel = inputImage(i,j)-contrast_threshold;
       % Check if it falls out of the range of 0
       % If it does, set it to 255
       if (darkenedPixel<0)
           darkenedPixel = 0;
       end
       % Set the darkened image matrix
       darkImage(i,j) = darkenedPixel; 
    end
end


% Writing the brightened and darkened image to separate image files 
% Convert filtered image to double type
double_brightImage = double(brightImage);
double_darkImage = double(darkImage);
% Convert back to unsigned 8-bit image
uint8_brightImage = uint8(double_brightImage);
uint8_darkImage = uint8(double_darkImage);

% Show the Results
figure(1);
imshow(uint8_brightImage);
figure(2);
imshow(uint8_darkImage);

% Store the Results into Assigned Folder
imwrite(uint8_brightImage,'problem2\bright_ImageA.jpg');
imwrite(uint8_darkImage,'problem2\dark_ImageA.jpg');
end

% Inversion Function
function inversion(imageFile)
inputImage = imread(imageFile);

% Obtain the Height And Width of the Image 
inputImage_height = size(inputImage,1);
inputImage_width = size(inputImage,2);

% Create An New Matrix for Storing Inverted Image
invertedImage = 255*ones(inputImage_height,inputImage_width,3);
invertedImage = uint8(invertedImage);

% Conduct Pixel Inversion for Each Channel and store it into the new matrix
invertedImage(:,:,1) = invertedImage(:,:,1)-inputImage(:,:,1);
invertedImage(:,:,2) = invertedImage(:,:,2)-inputImage(:,:,2);
invertedImage(:,:,3) = invertedImage(:,:,3)-inputImage(:,:,3);

% Show the Result
figure(1);
imshow(invertedImage)

% Store the Result to the Assigned Folder
imwrite(invertedImage,'inverted_white_blood_cells.jpg');

end


% Quantization Function
function quantization(imageFile, numLevel)
inputImage = imread(imageFile);

% Set Up Interval Ranges for Pixel Value Quantization
intervalQuantization = 256/numLevel;

% Obtain the Height And Width of the Image 
inputImage_height = size(inputImage,1);
inputImage_width = size(inputImage,2);

% Create An New Object for Storing New Value for Quantized
% Images
quantImage = zeros(inputImage_height,inputImage_width);

% Looping through Each Pixel to Perform Quantization
for (i=1:inputImage_height)
   for(j=1:inputImage_width)
       testPoint = inputImage(i,j);
       % Loop through each range and check
       for (level=1:numLevel)
          % if it is within the range, conduct the quantization to set the
          % original value to the range median
          if(testPoint>=(level-1)*intervalQuantization-1 && testPoint>=(level)*intervalQuantization-1)
                quantImage(i,j) = median([(level-1)*intervalQuantization-1 (level)*intervalQuantization-1]);
          end
       end
   end  
end

% Writing the final quantized image to a single image file type
% Convert quantized image to double type
double_quantImage = double(quantImage);
% Convert back to unsigned 8-bit image
uint8_quantImage = uint8(double_quantImage);
rgb_quantImage = cat(3, uint8_quantImage, uint8_quantImage, uint8_quantImage);

% Show the Result
figure(1);
imshow(uint8_quantImage);
fileName = strcat('quantized_white_blood_cells_', num2str(numLevel),'.png');

% Store the Result into Assigned Folder
fileName = strcat('problem3\', fileName);
imwrite(rgb_quantImage,fileName);
end


% Sampling Function
function sampling(imageFile,sampling_rate)
inputImage = imread(imageFile);

% Obtain the Height And Width of the Image 
inputImage_height = size(inputImage,1);
inputImage_width = size(inputImage,2);

% Create An New Variable for Storing New Value for Sampled
% Images
sampleImage = zeros(round(inputImage_height/sampling_rate),round(inputImage_width/sampling_rate),3);

% Looping through Each Pixel to Conduct the Sampling 
% (it jumps with every sampling rate)
for (i=1:sampling_rate:inputImage_height)
   for(j=1:sampling_rate:inputImage_width)
       sampleImage(i,j,:) = inputImage(i,j,:);
   end
end

% Writing the Final Sampled Image to A Single Image File
% convert back to unsigned 8-bit image
uint8_sampleImage = uint8(sampleImage);

% Show the Result
figure(1);
imshow(uint8_sampleImage);

% Store the Result into Assigned Folder
fileName = strcat('sampled_white_blood_cells_', num2str(sampling_rate), '.png');
fileName = strcat('problem4\', fileName);
imwrite(uint8_sampleImage,fileName);
end

% Camera Function
function camera(imageFolder)
% Read A Sample Image And Obtain Its Dimensions
sampleImageNumber = string(1);
sampleImageName = strcat(sampleImageNumber,'.JPG');
fullSampleImageDir = strcat(imageFolder,'\', sampleImageName);
sampleImage = imread(fullSampleImageDir);
imageHeight = size(sampleImage,1);
imageWidth = size(sampleImage,2);

% Create a Variable for storage
% create three variable for storing three channels: R, G, B
storageImageR = zeros(imageHeight,imageWidth,20);
storageImageG = zeros(imageHeight,imageWidth,20);
storageImageB = zeros(imageHeight,imageWidth,20);
% create variable for storing grayscale image
storageImage = zeros(imageHeight, imageWidth,20);

% Storing Image into Storage Image Matrices
% storageImageR: storing R channel
% storageImageG: storing G channel
% storageImageB: storing B channel
for (i=1:20)
    % Create the Directory That We Would Like to Read Image From
    % all the images are labelled as 1 to 20
    % create full directory to the image 
   imageNumber = string(i);
   imageName = strcat(imageNumber,'.JPG');
   fullImageDir = strcat(imageFolder,'\', imageName);
   
   % Read Current Image
   currentImage = imread(fullImageDir);
   
   % Add the Current Image Pixel onto Storage_Image
   storageImageR(:,:,i) = currentImage(:,:,1); 
   storageImageG(:,:,i) = currentImage(:,:,2);   
   storageImageB(:,:,i) = currentImage(:,:,3);
   
   % Turn current image to grayscale
   graycurrentImage=rgb2gray(currentImage);
   
   % Store Current Grayscale Image onto Sotrage_Image
   storageImage(:,:,i) = graycurrentImage;
   
end

% Calculating Mean and Standard Deviation of Image
% Colored Image Cases
% create mean image for each channel
meanImageR = mean(double(storageImageR),3);
meanImageG = mean(double(storageImageG),3);
meanImageB = mean(double(storageImageB),3);
% create mean RGB image
meanRGBImage = cat(3,uint8(meanImageR), uint8(meanImageG), uint8(meanImageB));

% Show the Mean RGB image
figure(1);
title('Mean RGB Image')
imshow(meanRGBImage);

% Store the Result into Assigned Folder
imwrite(meanRGBImage,'problem5\meanRGBImage.JPG');

% Gray Image Cases
% convert the 3-channel mean RGB image to single channel grayscale mean
% image (need to double check with TA)
meanGrayImage = mean(double(meanRGBImage),3);
meanGrayImage = uint8(meanGrayImage);

% Show the Result
figure(2);
imshow(meanGrayImage);

% Store the Result into Assigned Folder
imwrite(meanGrayImage,'problem5\meanGrayImage.JPG');

% Obtain Standard Deviation (need to double check with TA)
% Looping thorough each image file to conduct sbtraction 
for (i=1:20)
   % Extract out the current grayscale image to do subtraction
   % Be sure to change the variables to double type 
   storageImage(:,:,i) = double(storageImage(:,:,i)) - double(meanGrayImage);
   % Square it
   storageImage(:,:,i) = double(storageImage(:,:,i)).*double(storageImage(:,:,i));
end

% Create a variable for storing standard deviation image
% Sum it up across 20 images
stdGrayImage = sum(double(storageImage),3);
% Divide it by 20
stdGrayImage = double(stdGrayImage)./20;
% Take square root of it 
stdGrayImage = uint8(sqrt(stdGrayImage));

% Store it into Assigned Folder
imwrite(stdGrayImage,'problem5\stdGrayImage.JPG');


% Calculate Its Maximum Difference Across the Mean Image
% create a variable for storing the maximum difference of the mean image
maximum_difference = max(double(meanGrayImage),[],'all') - min(double(meanGrayImage),[],'all');
disp('The maximum difference of the gray image is:')
disp(maximum_difference)
% Pick One of the Pixel Across 20 Images And Plot Them Into A Histogram
% Create variables for storing the pixel values for later plotting urpose
% Color Image Cases
pixel_color_R = zeros(1, 20);
pixel_color_G = zeros(1, 20);
pixel_color_B = zeros(1, 20);
% Gray Image Cases
pixel_gray = zeros(1,20);

% Obtain A Random Point in an Image 
sample_length = randsample(imageHeight,1);
sample_width = randsample(imageWidth,1);

disp([sample_length,sample_width])
disp(sampleImage(sample_length,sample_width))
% Grab out the pixel value of each image at the sampled coordinate
for (i=1:20)
   % Read the Image
   % Create the Directory That Would Like to Read From
   imageNumber = string(i);
   imageName = strcat(imageNumber,'.JPG');
   fullImageDir = strcat(imageFolder,'\', imageName);
   currentImage = imread(fullImageDir);
   current_Image_pixel = currentImage(sample_length,sample_width,:);
   
   % Deal with Both Color And Grayscale Image Case
   % Color Image Case 
   % For color image cases, every image is RGB (3 channel) iamge.
   % Therefore, each channel is grabbed out to generate its own individual
   % channel histogram
   % Storing for R channel
   pixel_color_R(1,i) = current_Image_pixel(:,:,1);
   % Storing for G channel
   pixel_color_G(1,i) = current_Image_pixel(:,:,2);
   % Storing for B channel
   pixel_color_B(1,i) = current_Image_pixel(:,:,3);
   % Gray Image Case
   % For gray image cases, every image just has only one channel (gray).
   % Therefore, only one variable is needed for sotring
   pixel_gray(1,i) = mean(current_Image_pixel,3);
end

% Plotting the intensity
figure(1);
title('The Histogram for R Channel of the Colorful Image')
histogram(pixel_color_R);
figure(2);
title('The Histogram for G Channel of the Colorful Image')
histogram(pixel_color_G);
figure(3);
title('The Histogram for B Channel of the Colorful Image')
histogram(pixel_color_B);
% figure(4);
% title('The Histogram of the Gray Image')
% histogram(pixel_gray);
end
