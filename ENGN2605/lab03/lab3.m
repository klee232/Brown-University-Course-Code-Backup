function lab3()

% % Problem 2
% mkdir problem2
% image1 = imread('bds1.jpg');
% threshold = 3.5;
% [edge_img1 max_sup_M1] = intensity_edge_detector(image1,threshold);
% % Store Outcomes into Corresponding Directory
% imwrite(edge_img1,'problem2\edge_img1.jpg');
% image2 = imread('bds2.jpg');
% [edge_img2 max_sup_M2] = intensity_edge_detector(image2,threshold);
% imwrite(edge_img2,'problem2\edge_img2.jpg');
% image3 = imread('bds3.jpg');
% [edge_img3 max_sup_M3] = intensity_edge_detector(image3,threshold);
% imwrite(edge_img3,'problem2\edge_img3.jpg');
% image4 = imread('bds4.jpg');
% [edge_img4 max_sup_M4] = intensity_edge_detector(image4,threshold);
% imwrite(edge_img4,'problem2\edge_img4.jpg');
% image5 = imread('bds5.jpg');
% [edge_img5 max_sup_M5] = intensity_edge_detector(image5,threshold);
% imwrite(edge_img5,'problem2\edge_img5.jpg');
% image6 = imread('bds6.jpg');
% [edge_img6 max_sup_M6] = intensity_edge_detector(image6,threshold);
% imwrite(edge_img6,'problem2\edge_img6.jpg');
% 
% % Problem 3
% mkdir problem3
% threshold = 0.15;
% sigma = 1;
% can_edge_img1 = auto_canny(image1);
% imwrite(can_edge_img1,'problem3\can_edge_img1.jpg');
% can_edge_img1_param = auto_canny(image1,threshold,sigma);
% imwrite(can_edge_img1_param,'problem3\can_edge_img1_param.jpg');
% can_edge_img2 = auto_canny(image2);
% imwrite(can_edge_img2,'problem3\can_edge_img2.jpg');
% can_edge_img2_param = auto_canny(image2,threshold,sigma);
% imwrite(can_edge_img2_param,'problem3\can_edge_img2_param.jpg');
% can_edge_img3 = auto_canny(image3);
% imwrite(can_edge_img3,'problem3\can_edge_img3.jpg');
% can_edge_img3_param = auto_canny(image3,threshold,sigma);
% imwrite(can_edge_img3_param,'problem3\can_edge_img3_param.jpg');
% can_edge_img4 = auto_canny(image4);
% imwrite(can_edge_img4,'problem3\can_edge_img4.jpg');
% can_edge_img4_param = auto_canny(image4,threshold,sigma);
% imwrite(can_edge_img4_param,'problem3\can_edge_img4_param.jpg');
% can_edge_img5 = auto_canny(image5);
% imwrite(can_edge_img5,'problem3\can_edge_img5.jpg');
% can_edge_img5_param = auto_canny(image5,threshold,sigma);
% imwrite(can_edge_img5_param,'problem3\can_edge_img5_param.jpg');
% can_edge_img6 = auto_canny(image6);
% imwrite(can_edge_img6,'problem3\can_edge_img6.jpg');
% can_edge_img6_param = auto_canny(image6,threshold,sigma);
% imwrite(can_edge_img6_param,'problem3\can_edge_img6_param.jpg');

% Problem 4
image2=imread('bds4.jpg');
mkdir problem4
[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,3,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map4_3.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,5,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map4_5.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,10,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map4_10.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,20,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map4_20.jpg');


image2=imread('bds5.jpg');
mkdir problem4
[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,3,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map5_3.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,5,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map5_5.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,10,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map5_10.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,20,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map5_20.jpg');

image2=imread('bds6.jpg');
mkdir problem4
[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,3,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map6_3.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,5,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map6_5.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,10,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map6_10.jpg');

[edge_map1_3 orient_map1_3] = hist_edge_detector(image2,20,8,16);
edge_map1_3(edge_map1_3 <200) = 0;
edge_map1_3(edge_map1_3 >=200) = 255;
edge_map1_3_f = edge_map1_3;
imwrite(edge_map1_3,'problem4\edge_map6_20.jpg');

% figure(2);
% imshow(edge_map1_3_f)
% imwrite(edge_map1_3_f,'problem4\edge_map_img1_3.jpg')
% [edge_map1_5,orient_map1_5] = hist_edge_detector(image1,5,8,16);
% edge_map1_5 = threshold_img(edge_map1_5,200);
% imwrite(edge_map1_5,'problem4\edge_map_img1_5.jpg')
% [edge_map1_10,orient_map1_10] = hist_edge_detector(image1,10,8,16);
% edge_map1_10 = threshold_img(edge_map1_10,200);
% imwrite(edge_map1_10,'problem4\edge_map_img1_10.jpg')
% [edge_map1_20,orient_map1_20] = hist_edge_detector(image1,20,8,16);
% edge_map1_20 = threshold_img(edge_map1_20,200);
% imwrite(edge_map1_20,'problem4\edge_map_img1_20.jpg')

% Problem 5

% % Problem 6
% mkdir problem6
% threshold_h = 8.5;
% threshold_l = 7.0;
% image1=imread('bds1.jpg');
% outcome = edge_link(image1,threshold_h,threshold_l);
% imwrite(outcome,'problem6\bds1_link.jpg')
% image2=imread('bds2.jpg');
% outcome = edge_link(image2,threshold_h,threshold_l);
% imwrite(outcome,'problem6\bdsj2_link.jpg')
% image3=imread('bds3.jpg');
% outcome = edge_link(image3,threshold_h,threshold_l);
% imwrite(outcome,'problem6\bdsj3_link.jpg')
% image4=imread('bds4.jpg');
% outcome = edge_link(image4,threshold_h,threshold_l);
% imwrite(outcome,'problem6\bdsj4_link.jpg')
% image5=imread('bds5.jpg');
% outcome = edge_link(image5,threshold_h,threshold_l);
% imwrite(outcome,'problem6\bdsj5_link.jpg')
% image6=imread('bds6.jpg');
% outcome = edge_link(image6,threshold_h,threshold_l);
% imwrite(outcome,'problem6\bdsj6_link.jpg')

end