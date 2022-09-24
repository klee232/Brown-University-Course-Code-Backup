function lab3()
image = imread('bds1.jpg');
threshold = 1;
edge_img = intensity_edge_detector(image,threshold);

end