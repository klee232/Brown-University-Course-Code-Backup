function [edge_img max_sup_M] = lab3()

% Problem 2
image = imread('bds1.jpg');
threshold = 0.3;
[edge_img max_sup_M] = intensity_edge_detector(image,threshold);

% Problem 3

end