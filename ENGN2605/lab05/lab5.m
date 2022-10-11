function best_match1 = lab5()
image_dir1_1 = "images\view_change\img1.png";
image_dir1_2 = "images\view_change\img2.png";
image_dir2_1 = "images\scale_rotation_change\img1.png";
image_dir2_2 = "images\scale_rotation_change\img2.png";
image_dir3_1 = "images\planar_rotation_change\img1.png";
image_dir3_2 = "images\planar_rotation_change\img2.png";
image_dir4_1 = "images\illumination_change\img1.png";
image_dir4_2 = "images\illumination_change\img2.png";

img1_1 = imread(image_dir1_1);
img1_1 = rgb2gray(img1_1);
img1_2 = imread(image_dir1_2);
img1_2 = rgb2gray(img1_2);
img2_1 = imread(image_dir2_1);
img2_2 = imread(image_dir2_2);
img3_1 = imread(image_dir3_1);
img3_1 = rgb2gray(img3_1);
img3_2 = imread(image_dir3_2);
img3_2 = rgb2gray(img3_2);
img4_1 = imread(image_dir4_1);
img4_1 = rgb2gray(img4_1);
img4_2 = imread(image_dir4_2);
img4_2 = rgb2gray(img4_2);


% Problem 1
% Set 1
% detect corners in each image
corners1_1 = corner_detector(img1_1);
corners1_2 = corner_detector(img1_2);
% region descriptors
window_sz = 51;
descriptor_type = "histogram";
D1_1 = region_descriptors(img1_1,corners1_1, window_sz, descriptor_type);
D1_2 = region_descriptors(img1_2,corners1_2, window_sz, descriptor_type);
% feature matches
similarity_type = "Chi-Square";
[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches(D1_1, D1_2, similarity_type,0.9);
% get the corresponding coordinates
[coord1_1,coord1_2] = coordinates_find(best_match1,simi_match1_1,corners1_1,corners1_2);
% visualize
N = 10;
visualize_matches(img1_1, img1_2, coord1_1, coord1_2, N)
image_dir1 = "images\view_change\";
accuracy_rate1 = accuracy_compute(image_dir1,coord1_1,coord1_2);
disp("First accuracy rate is:")
disp(accuracy_rate1)

% Set 2
% detect corners in each image
corners2_1 = corner_detector(img2_1);
corners2_2 = corner_detector(img2_2);
% region descriptors
window_sz =19;
descriptor_type = "pixels";
D2_1 = region_descriptors(img2_1,corners2_1, window_sz, descriptor_type);
D2_2 = region_descriptors(img2_2,corners2_2, window_sz, descriptor_type);
% feature matches
similarity_type = "NCC";
[best_match2, sec_match2, simi_match2_1, simi_match2_2] = find_matches(D2_1, D2_2, similarity_type,0.7);
% get the corresponding coordinates
[coord2_1,coord2_2] = coordinates_find(best_match2,simi_match2_1,corners2_1,corners2_2);
% visualize
N = 10;
visualize_matches(img2_1, img2_2, coord2_1, coord2_2, N)
image_dir2 = "images\scale_rotation_change\";
accuracy_rate2 = accuracy_compute(image_dir2,coord2_1,coord2_2);
disp("second accuracy rate is:")
disp(accuracy_rate2)


% Set 3
corners3_1 = corner_detector(img3_1); % corner detection checked
corners3_2 = corner_detector(img3_2); % corner detection checked
% region descriptors
window_sz = 15;
descriptor_type = "pixels";
D3_1 = region_descriptors(img3_1,corners3_1, window_sz, descriptor_type);
D3_2 = region_descriptors(img3_2,corners3_2, window_sz, descriptor_type);
% feature matches
similarity_type = "SSD";
[best_match3 sec_match3, simi_match3_1, simi_match3_2] = find_matches(D3_1, D3_2, similarity_type,0.9);
% get the corresponding coordinates
[coord3_1,coord3_2] = coordinates_find(best_match3,simi_match3_1,corners3_1,corners3_2);
% visualize
N = 10;
visualize_matches(img3_1, img3_2, coord3_1, coord3_2, N)
image_dir3 = "images\planar_rotation_change\";
accuracy_rate3 = accuracy_compute(image_dir3,coord3_1,coord3_2);
disp("Third accuracy rate is:")
disp(accuracy_rate3)

% Set 4
corners4_1 = corner_detector(img4_1);
corners4_2 = corner_detector(img4_2);
% region descriptors
window_sz = 13;
descriptor_type = "pixels";
D4_1 = region_descriptors(img4_1,corners4_1, window_sz, descriptor_type);
D4_2 = region_descriptors(img4_2,corners4_2, window_sz, descriptor_type);
% feature matches
similarity_type = "NCC";
[best_match4, sec_match4, simi_match4_1, simi_match4_2] = find_matches(D4_1, D4_2, similarity_type,0.9);
% get the corresponding coordinates
[coord4_1,coord4_2] = coordinates_find(best_match4,simi_match4_1,corners4_1,corners4_2);
% visualize
N = 10;
visualize_matches(img4_1, img4_2, coord4_1, coord4_2, N)
image_dir4 = "images\illumination_change\";
accuracy_rate4 = accuracy_compute(image_dir4,coord4_1,coord4_2);
disp("Fourth accuracy rate is:")
disp(accuracy_rate4)

% VL Feat Detect
similarity_type = "SIFT";
peak_thresh = 0.1;
edge_thresh = 5;
img1_1_temp = single(img1_1);
img1_2_temp = single(img1_2);
[f1_1,d1_1] = vl_sift(img1_1_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f1_2,d1_2] = vl_sift(img1_2_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
d1_1 = double(d1_1);
d1_2 = double(d1_2);
[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches(d1_1, d1_2, similarity_type,0.9);
% get the corresponding coordinates
[coord1_1,coord1_2] = coordinates_find_sift(best_match1,simi_match1_1,f1_1,f1_2);
% visualize
N = 10;
visualize_matches(img1_1, img1_2, coord1_1, coord1_2, N)
image_dir1 = "images\view_change\";
accuracy_rate1 = accuracy_compute(image_dir1,coord1_1,coord1_2);
disp("First SIFT accuracy rate is:")
disp(accuracy_rate1)

img2_1_temp = single(img2_1);
img2_2_temp = single(img2_2);
[f2_1,d2_1] = vl_sift(img2_1_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f2_2,d2_2] = vl_sift(img2_2_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
d2_1 = double(d2_1);
d2_2 = double(d2_2);
[best_match2, sec_match2, simi_match2_1, simi_match2_2] = find_matches(d2_1, d2_2, similarity_type,0.9);
% get the corresponding coordinates
[coord2_1,coord2_2] = coordinates_find_sift(best_match2,simi_match2_1,f2_1,f2_2);
% visualize
N = 10;
visualize_matches(img2_1, img2_2, coord2_1, coord2_2, N)
image_dir2 = "images\scale_rotation_change\";
accuracy_rate2 = accuracy_compute(image_dir2,coord2_1,coord2_2);
disp("Second SIFT accuracy rate is:")
disp(accuracy_rate2)

img3_1_temp = single(img3_1);
img3_2_temp = single(img3_2);
[f3_1,d3_1] = vl_sift(img3_1_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f3_2,d3_2] = vl_sift(img3_2_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
d3_1 = double(d3_1);
d3_2 = double(d3_2);
[best_match3, sec_match3, simi_match3_1, simi_match3_2] = find_matches(d3_1, d3_2, similarity_type,0.9);
% get the corresponding coordinates
[coord3_1,coord3_2] = coordinates_find_sift(best_match3,simi_match3_1,f3_1,f3_2);
% visualize
N = 10;
visualize_matches(img3_1, img3_2, coord3_1, coord3_2, N)
image_dir3 = "images\planar_rotation_change\";
accuracy_rate3 = accuracy_compute(image_dir3,coord3_1,coord3_2);
disp("Third SIFT accuracy rate is:")
disp(accuracy_rate3)

img4_1_temp = single(img4_1);
img4_2_temp = single(img4_2);
[f4_1,d4_1] = vl_sift(img4_1_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f4_2,d4_2] = vl_sift(img4_2_temp,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
d4_1 = double(d4_1);
d4_2 = double(d4_2);
[best_match4, sec_match4, simi_match4_1, simi_match4_2] = find_matches(d4_1, d4_2, similarity_type,0.9);
% get the corresponding coordinates
[coord4_1,coord4_2] = coordinates_find_sift(best_match4,simi_match4_1,f4_1,f4_2);
% visualize
N = 10;
visualize_matches(img4_1, img4_2, coord4_1, coord4_2, N)
image_dir4 = "images\illumination_change\";
accuracy_rate4 = accuracy_compute(image_dir4,coord4_1,coord4_2);
disp("Fourth SIFT accuracy rate is:")
disp(accuracy_rate4)


% Problem 2
% feature matches
similarity_type = "Chi-Square";
[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches_revised(D1_1, D1_2, similarity_type,0.9);
% get the corresponding coordinates
[coord1_1,coord1_2] = coordinates_find(best_match1,simi_match1_1,corners1_1,corners1_2);
% visualize
N = 10;
visualize_matches(img1_1, img1_2, coord1_1, coord1_2, N)
image_dir1 = "images\view_change\";
accuracy_rate1 = accuracy_compute(image_dir1,coord1_1,coord1_2);
disp("First revised accuracy rate is:")
disp(accuracy_rate1)

% feature matches
similarity_type = "NCC";
[best_match2, sec_match2, simi_match2_1, simi_match2_2] = find_matches_revised(D2_1, D2_2, similarity_type,0.7);
% get the corresponding coordinates
[coord2_1,coord2_2] = coordinates_find(best_match2,simi_match2_1,corners2_1,corners2_2);
% visualize
N = 10;
visualize_matches(img2_1, img2_2, coord2_1, coord2_2, N)
image_dir2 = "images\scale_rotation_change\";
accuracy_rate2 = accuracy_compute(image_dir2,coord2_1,coord2_2);
disp("second revised accuracy rate is:")
disp(accuracy_rate2)

% feature matches
similarity_type = "SSD";
[best_match3 sec_match3, simi_match3_1, simi_match3_2] = find_matches_revised(D3_1, D3_2, similarity_type,0.9);
% get the corresponding coordinates
[coord3_1,coord3_2] = coordinates_find(best_match3,simi_match3_1,corners3_1,corners3_2);
% visualize
N = 10;
visualize_matches(img3_1, img3_2, coord3_1, coord3_2, N)
image_dir3 = "images\planar_rotation_change\";
accuracy_rate3 = accuracy_compute(image_dir3,coord3_1,coord3_2);
disp("Third revised accuracy rate is:")
disp(accuracy_rate3)

% feature matches
similarity_type = "NCC";
[best_match4, sec_match4, simi_match4_1, simi_match4_2] = find_matches_revised(D4_1, D4_2, similarity_type,0.9);
% get the corresponding coordinates
[coord4_1,coord4_2] = coordinates_find(best_match4,simi_match4_1,corners4_1,corners4_2);
% visualize
N = 10;
visualize_matches(img4_1, img4_2, coord4_1, coord4_2, N)
image_dir4 = "images\illumination_change\";
accuracy_rate4 = accuracy_compute(image_dir4,coord4_1,coord4_2);
disp("Fourth revised accuracy rate is:")
disp(accuracy_rate4)


end