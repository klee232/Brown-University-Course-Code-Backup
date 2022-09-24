inputimage = imread('snowman.jpg');
double_inputimage = double(inputimage);
filteredInputImage = imgaussfilt(double_inputimage,1.9);
uint8filteredInputImage = uint8(filteredInputImage);
imwrite(uint8filteredInputImage,'filtered_snowman.jpg');