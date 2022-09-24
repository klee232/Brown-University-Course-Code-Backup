function edge_img = intensity_edge_detector(image,threshold)
threshold = double(threshold);
% Convert Image to Grayscale
gray_image = rgb2gray(image);
% Convert Image to Double Type
gray_image = double(gray_image);
% Load Image and Smooth it with s Gaussian Filter
gauss_image = imgaussfilt(gray_image,2);
% Compute the Gradient of the Image
[dy,dx] = gradient(gauss_image);
% Create Magnitude Map M
M = sqrt(dx.^2+dy.^2);
% Used the Command quiver(dy,dx) to View the Actual Gradient Vectors
quiver(dy,dx);

edge_img = 1;


end