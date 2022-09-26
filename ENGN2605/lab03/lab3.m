function [edge_map dist] = lab3()

% Problem 2
mkdir problem2
image1 = imread('bds1.jpg');
threshold = 3.5;
[edge_img1 max_sup_M1] = intensity_edge_detector(image1,threshold);
% Store Outcomes into Corresponding Directory
imwrite(edge_img1,'problem2\edge_img1.jpg');
image2 = imread('bds2.jpg');
[edge_img2 max_sup_M2] = intensity_edge_detector(image2,threshold);
imwrite(edge_img2,'problem2\edge_img2.jpg');
image3 = imread('bds3.jpg');
[edge_img3 max_sup_M3] = intensity_edge_detector(image3,threshold);
imwrite(edge_img3,'problem2\edge_img3.jpg');
image4 = imread('bds4.jpg');
[edge_img4 max_sup_M4] = intensity_edge_detector(image4,threshold);
imwrite(edge_img4,'problem2\edge_img4.jpg');
image5 = imread('bds5.jpg');
[edge_img5 max_sup_M5] = intensity_edge_detector(image5,threshold);
imwrite(edge_img5,'problem2\edge_img5.jpg');
image6 = imread('bds6.jpg');
[edge_img6 max_sup_M6] = intensity_edge_detector(image6,threshold);
imwrite(edge_img6,'problem2\edge_img6.jpg');

% Problem 3
mkdir problem3
threshold = 0.15;
sigma = 1;
can_edge_img1 = auto_canny(image1);
imwrite(can_edge_img1,'problem3\can_edge_img1.jpg');
can_edge_img1_param = auto_canny(image1,threshold,sigma);
imwrite(can_edge_img1_param,'problem3\can_edge_img1_param.jpg');
can_edge_img2 = auto_canny(image2);
imwrite(can_edge_img2,'problem3\can_edge_img2.jpg');
can_edge_img2_param = auto_canny(image2,threshold,sigma);
imwrite(can_edge_img2_param,'problem3\can_edge_img2_param.jpg');
can_edge_img3 = auto_canny(image3);
imwrite(can_edge_img3,'problem3\can_edge_img3.jpg');
can_edge_img3_param = auto_canny(image3,threshold,sigma);
imwrite(can_edge_img3_param,'problem3\can_edge_img3_param.jpg');
can_edge_img4 = auto_canny(image4);
imwrite(can_edge_img4,'problem3\can_edge_img4.jpg');
can_edge_img4_param = auto_canny(image4,threshold,sigma);
imwrite(can_edge_img4_param,'problem3\can_edge_img4_param.jpg');
can_edge_img5 = auto_canny(image5);
imwrite(can_edge_img5,'problem3\can_edge_img5.jpg');
can_edge_img5_param = auto_canny(image5,threshold,sigma);
imwrite(can_edge_img5_param,'problem3\can_edge_img5_param.jpg');
can_edge_img6 = auto_canny(image6);
imwrite(can_edge_img6,'problem3\can_edge_img6.jpg');
can_edge_img6_param = auto_canny(image6,threshold,sigma);
imwrite(can_edge_img6_param,'problem3\can_edge_img6_param.jpg');

% Problem 4
% mkdir problem4
[edge_map,dist] = hist_edge_detector(image1,1,8,10);
imshow(edge_map)
% Problem 5


end