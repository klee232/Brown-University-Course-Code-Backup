function edge_img = auto_canny(image, threshold, sigma)
% Preprocessing Portion
% Convert Image to Grayscale
gray_image = rgb2gray(image);

% Conduct MATLAB Built-in Canny Edge Detection Function
% If the thredhold and sigma does not exist, perform Canny without inputing
% the thredhold and sigma
if ~exist('thredhold','var') && ~exist('sigma','var')
    edge_img = edge(gray_image,'Canny');
else
    edge_img = edge(gray_image,'Canny',threshold, sigma);
end

end