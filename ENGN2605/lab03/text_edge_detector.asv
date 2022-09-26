function edge_img=text_edge_detector(image,threshold)

% Construct 18 Oriented Odd-Symmetric Filters
k = [1 2 3];
% generate three sigmas
width_k = size(k,2);
sigma = zeros(1,width_k);
for i_k=1:width_k
    sigma(i_k) = sqrt(2).^(k(i_k));
end
% generate six orientations
angles = 0:pi:6;

% Construct 18 Oriented Even-Symmetric Filters

% Construct 8 Laplacian of Gaussian Filters
k = [1 2 3 4];
% generate three sigmas
width_k = size(k,2);
sigma1 = zeros(1,width_k);
sigma2 = zeros(1,width_k);
for i_k=1:width_k
    sigma1(i_k) = sqrt(2).^(k(i_k));
    sigma2(i_k) = (3*sqrt(2)).^(k(i_k));
end
% Use fspecial

% Construct 4 Gaussian Filters
k = [1 2 3 4];
width_k = size(k,2);
sigma = zeros(1,width_k);
for i_k=1:width_k
    sigma(i_k) = sqrt(2).^(k(i_k));
end

% Convert image to grayscale
gray_image = rgb2gray(image);
gray_image = double(gray_image);

% Rescale image 
rescale_image = im2double(gray_image);



end

function out = gauss_filt(input,sigma)
% Construct Denonminator
den = sigma*sqrt(2*pi);
% Construct Numerator
num = exp((-input.^2)/(2*(sigma.^2)));

out = num/den;
end

function out = first_gauss_filt(input,sigma)
% Construct Denonminator
den = (sigma.^3)*sqrt(2*pi);
% Construct Numerator
num = (-1)*input*exp(((-1)*input.^2)/(2*sigma.^2));

out=num/den;
end

function out = sec_gauss_filt(input,sigma)
% Construct Denonminator
den = (sigma.^5)*sqrt(2*pi);
% Construct Numerator
num = (input.^2)*exp(((-1)*input.^2)/(2*sigma.^2));

out=num/den;
end