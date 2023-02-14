function [coord1_1, coord1_2] = lab06 

% problem 1

problem1_dir = "images/problem_1/";


% load images 
img1_1_dir = strcat(problem1_dir,"Golden_Gate/goldengate-02.png");
img1_2_dir = strcat(problem1_dir,"Golden_Gate/goldengate-03.png");
img2_1_dir = strcat(problem1_dir,"LEMS_lab/lems-01.png");
img2_2_dir = strcat(problem1_dir,"LEMS_lab/lems-02.png");
img3_1_dir = strcat(problem1_dir,"PVD_City_Hall/1900.jpg");
img3_2_dir = strcat(problem1_dir,"PVD_City_Hall/2016.jpg");

img1_1 = imread(img1_1_dir);
img1_2 = imread(img1_2_dir);
img2_1 = imread(img2_1_dir);
img2_2 = imread(img2_2_dir);
img3_1 = imread(img3_1_dir);
img3_2 = imread(img3_2_dir);

% utilize sift features
if size(img1_1,3)==3
    img1_1 = rgb2gray(img1_1);
else
    img1_1 = img1_1;
end
if size(img1_2,3)==3
    img1_2 = rgb2gray(img1_2);
else
    img1_2 = img1_2;
end
if size(img2_1,3)==3
    img2_1 = rgb2gray(img2_1);
else
    img2_1 = img2_1;
end
if size(img2_2,3)==3
    img2_2 = rgb2gray(img2_2);
else
    img2_2 = img2_2;
end
if size(img3_1,3)==3
    img3_1 = rgb2gray(img3_1);
else
    img3_1 = img3_1;
end
if size(img3_2,3)==3
    img3_2 = rgb2gray(img3_2);
else
    img3_2 = img3_2;
end

similarity_type = "SIFT";
img1_1_single = single(img1_1);
img1_2_single = single(img1_2);
img2_1_single = single(img2_1);
img2_2_single = single(img2_2);
img3_1_single = single(img3_1);
img3_2_single = single(img3_2);
peak_thresh = 0.1;
edge_thresh = 5;
[f1_1, d1_1] = vl_sift(img1_1_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f1_2, d1_2] = vl_sift(img1_2_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f2_1, d2_1] = vl_sift(img2_1_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f2_2, d2_2] = vl_sift(img2_2_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f3_1, d3_1] = vl_sift(img3_1_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f3_2, d3_2] = vl_sift(img3_2_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
d1_1 = double(d1_1);
d1_2 = double(d1_2);
d2_1 = double(d2_1);
d2_2 = double(d2_2);
d3_1 = double(d3_1);
d3_2 = double(d3_2);
[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches(d1_1, d1_2, similarity_type,0.7);
[coord1_1,coord1_2] = coordinates_find_sift(best_match1,simi_match1_1,f1_1,f1_2);
homat1 = Ransac4Homography(coord1_1, coord1_2);
[best_match2, sec_match2, simi_match2_1, simi_match2_2] = find_matches(d2_1, d2_2, similarity_type,0.7);
[coord2_1,coord2_2] = coordinates_find_sift(best_match2,simi_match2_1,f2_1,f2_2);
homat2 = Ransac4Homography(coord2_1, coord2_2);
[best_match3, sec_match3, simi_match3_1, simi_match3_2] = find_matches(d3_1, d3_2, similarity_type,0.7);
[coord3_1,coord3_2] = coordinates_find_sift(best_match3,simi_match3_1,f3_1,f3_2);
homat3 = Ransac4Homography(coord3_1, coord3_2);
% using getNewImg.m
img1_1 = imread(img1_1_dir);
img1_2 = imread(img1_2_dir);
img2_1 = imread(img2_1_dir);
img2_2 = imread(img2_2_dir);
img3_1 = imread(img3_1_dir);
img3_2 = imread(img3_2_dir);
[warpedImage1, leftTopUnwarpX1, leftTopUnwarpY1, warpImgWeight1] = getNewImg(homat1, img1_1, img1_2);
blendType = 'weightBlend';
[stitchedImage] = blendImgs(warpedImage1, img1_1, leftTopUnwarpX1, leftTopUnwarpY1, blendType, warpImgWeight1);
figure(1);
imshow(uint8(stitchedImage));
[warpedImage2, leftTopUnwarpX2, leftTopUnwarpY2, warpImgWeight2] = getNewImg(homat2, img2_1, img2_2);
blendType = 'weightBlend';
[stitchedImage] = blendImgs(warpedImage2, img2_1, leftTopUnwarpX2, leftTopUnwarpY2, blendType, warpImgWeight2);
figure(2);
imshow(uint8(stitchedImage));
[warpedImage3, leftTopUnwarpX3, leftTopUnwarpY3, warpImgWeight3] = getNewImg(homat3, img3_1, img3_2);
blendType = 'weightBlend';
[stitchedImage] = blendImgs(warpedImage3, img3_1, leftTopUnwarpX3, leftTopUnwarpY3, blendType, warpImgWeight3);
figure(3);
imshow(uint8(stitchedImage));

% problem 2

problem2_dir = "images/problem_2/";

% load images 
img1_1_dir = strcat(problem2_dir,"half_dome/halfdome-05.png");
img1_2_dir = strcat(problem2_dir,"half_dome/halfdome-06.png");
img1_3_dir = strcat(problem2_dir,"half_dome/halfdome-07.png");
img2_1_dir = strcat(problem2_dir,"hotel/hotel-00.png");
img2_2_dir = strcat(problem2_dir,"hotel/hotel-01.png");
img2_3_dir = strcat(problem2_dir,"hotel/hotel-02.png");
img1_1 = imread(img1_1_dir);
img1_2 = imread(img1_2_dir);
img1_3 = imread(img1_3_dir);
img2_1 = imread(img2_1_dir);
img2_2 = imread(img2_2_dir);
img2_3 = imread(img2_3_dir);
% utilize sift features
if size(img1_1,3)==3
    img1_1 = rgb2gray(img1_1);
else
    img1_1 = img1_1;
end
if size(img1_2,3)==3
    img1_2 = rgb2gray(img1_2);
else
    img1_2 = img1_2;
end
if size(img1_3,3)==3
    img1_3 = rgb2gray(img1_3);
else
    img1_3 = img1_3;
end
if size(img2_1,3)==3
    img2_1 = rgb2gray(img2_1);
else
    img2_1 = img2_1;
end
if size(img2_2,3)==3
    img2_2 = rgb2gray(img2_2);
else
    img2_2 = img2_2;
end
if size(img2_3,3)==3
    img2_3 = rgb2gray(img2_3);
else
    img2_3 = img2_3;
end

similarity_type = "SIFT";
img1_1_single = single(img1_1);
img1_2_single = single(img1_2);
img1_3_single = single(img1_3);
img2_1_single = single(img2_1);
img2_2_single = single(img2_2);
img2_3_single = single(img2_3);
peak_thresh = 0.1;
edge_thresh = 5;
[f1_1, d1_1] = vl_sift(img1_1_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f1_2, d1_2] = vl_sift(img1_2_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f1_3, d1_3] = vl_sift(img1_3_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f2_1, d2_1] = vl_sift(img2_1_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f2_2, d2_2] = vl_sift(img2_2_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f2_3, d2_3] = vl_sift(img2_3_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
d1_1 = double(d1_1);
d1_2 = double(d1_2);
d1_3 = double(d1_3);
d2_1 = double(d2_1);
d2_2 = double(d2_2);
d2_3 = double(d2_3);

[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches(d1_1, d1_2, similarity_type,0.7);
[coord1_1,coord1_2] = coordinates_find_sift(best_match1,simi_match1_1,f1_1,f1_2);
homat1 = Ransac4Homography(coord1_1, coord1_2);
[warpedImage1, leftTopUnwarpX1, leftTopUnwarpY1, warpImgWeight1] = getNewImg(homat1, img1_1, img1_2);
blendType = 'weightBlend';
[stitchedImage] = blendImgs(warpedImage1, img1_1, leftTopUnwarpX1, leftTopUnwarpY1, blendType, warpImgWeight1);
stitchedImage1_single = single(stitchedImage);
[fs_1, ds_1] = vl_sift(stitchedImage1_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
ds_1 = double(ds_1);
[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches(ds_1, d1_3, similarity_type,0.7);
[coords_1,coord1_3] = coordinates_find_sift(best_match1,simi_match1_1,fs_1,f1_3);
homat1 = Ransac4Homography(coords_1, coord1_3);
[warpedImage1, leftTopUnwarpX1, leftTopUnwarpY1, warpImgWeight1] = getNewImg(homat1, stitchedImage, img1_3);
blendType = 'weightBlend';
[stitchedImage] = blendImgs(warpedImage1, stitchedImage, leftTopUnwarpX1, leftTopUnwarpY1, blendType, warpImgWeight1);
figure(4);
imshow(uint8(stitchedImage))

[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches(d2_1, d2_2, similarity_type,0.7);
[coord2_1,coord2_2] = coordinates_find_sift(best_match1,simi_match1_1,f2_1,f2_2);
homat2 = Ransac4Homography(coord2_1, coord2_2);
[warpedImage2, leftTopUnwarpX2, leftTopUnwarpY2, warpImgWeight2] = getNewImg(homat2, img2_1, img2_2);
blendType = 'weightBlend';
[stitchedImage2] = blendImgs(warpedImage2, img2_1, leftTopUnwarpX2, leftTopUnwarpY2, blendType, warpImgWeight2);
stitchedImage2_single = single(stitchedImage2);
[fs_2, ds_2] = vl_sift(stitchedImage2_single,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
ds_2 = double(ds_2);
[best_match2, sec_match2, simi_match2_1, simi_match2_2] = find_matches(ds_2, d2_3, similarity_type,0.7);
[coords_2,coord2_3] = coordinates_find_sift(best_match2,simi_match2_1,fs_2,f2_3);
homat2 = Ransac4Homography(coords_2, coord2_3);
[warpedImage2, leftTopUnwarpX2, leftTopUnwarpY2, warpImgWeight2] = getNewImg(homat2, stitchedImage2, img2_3);
blendType = 'weightBlend';
[stitchedImage2] = blendImgs(warpedImage2, stitchedImage2, leftTopUnwarpX2, leftTopUnwarpY2, blendType, warpImgWeight2);
figure(5);
imshow(uint8(stitchedImage2))


% problem 4
img1_1 = imread(img1_1_dir);
img1_2 = imread(img1_2_dir);
img2_1 = imread(img2_1_dir);
img2_2 = imread(img2_2_dir);
img3_1 = imread(img3_1_dir);
img3_2 = imread(img3_2_dir);

% utilize sift features
if size(img1_1,3)==3
    img1_1gray = rgb2gray(img1_1);
else
    img1_1gray = img1_1;
end
if size(img1_2,3)==3
    img1_2gray = rgb2gray(img1_2);
else
    img1_2gray = img1_2;
end
if size(img2_1,3)==3
    img2_1gray = rgb2gray(img2_1);
else
    img2_1gray = img2_1;
end
if size(img2_2,3)==3
    img2_2gray = rgb2gray(img2_2);
else
    img2_2gray = img2_2;
end
if size(img3_1,3)==3
    img3_1gray = rgb2gray(img3_1);
else
    img3_1gray = img3_1;
end
if size(img3_2,3)==3
    img3_2gray = rgb2gray(img3_2);
else
    img3_2gray = img3_2;
end
corners1_1 = corner_detector(img1_1gray);
corners1_2 = corner_detector(img1_2gray);
corners2_1 = corner_detector(img2_1gray);
corners2_2 = corner_detector(img2_2gray);
corners3_1 = corner_detector(img3_1gray);
corners3_2 = corner_detector(img3_2gray);

window_sz = 5;
descriptor_type = "histogram";
D1_1 = region_descriptors(img1_1gray,corners1_1, window_sz, descriptor_type);
D1_2 = region_descriptors(img1_2gray,corners1_2, window_sz, descriptor_type);
D2_1 = region_descriptors(img2_1gray,corners2_1, window_sz, descriptor_type);
D2_2 = region_descriptors(img2_2gray,corners2_2, window_sz, descriptor_type);
D3_1 = region_descriptors(img3_1gray,corners3_1, window_sz, descriptor_type);
D3_2 = region_descriptors(img3_2gray,corners3_2, window_sz, descriptor_type);

similarity_type = "Chi-Square";
[best_match1, sec_match1, simi_match1_1, simi_match1_2] = find_matches(D1_1, D1_2, similarity_type,0.7);
[best_match2, sec_match2, simi_match2_1, simi_match2_2] = find_matches(D2_1, D2_2, similarity_type,0.7);
[best_match3, sec_match3, simi_match3_1, simi_match3_2] = find_matches(D3_1, D3_2, similarity_type,0.7);

[coord1_1,coord1_2] = coordinates_find(best_match1,simi_match1_1, corners1_1,corners1_2);
[coord2_1,coord2_2] = coordinates_find(best_match2,simi_match2_1, corners2_1,corners2_2);
[coord3_1,coord3_2] = coordinates_find(best_match3,simi_match3_1, corners3_1,corners3_2);

homat1 = Ransac4Homography(coord1_1, coord1_2);
homat2 = Ransac4Homography(coord2_1, coord2_2);
homat3 = Ransac4Homography(coord3_1, coord3_2);

[warpedImage1, leftTopUnwarpX1, leftTopUnwarpY1, warpImgWeight1] = getNewImg(homat1, img1_1, img1_2);
blendType = 'weightBlend';
[stitchedImage1] = blendImgs(warpedImage1, img1_1, leftTopUnwarpX1, leftTopUnwarpY1, blendType, warpImgWeight1);
[warpedImage2, leftTopUnwarpX2, leftTopUnwarpY2, warpImgWeight2] = getNewImg(homat2, img2_1, img2_2);
blendType = 'weightBlend';
[stitchedImage2] = blendImgs(warpedImage2, img2_1, leftTopUnwarpX2, leftTopUnwarpY2, blendType, warpImgWeight2);
[warpedImage3, leftTopUnwarpX3, leftTopUnwarpY3, warpImgWeight3] = getNewImg(homat3, img3_1, img3_2);
blendType = 'weightBlend';
[stitchedImage3] = blendImgs(warpedImage3, img3_1, leftTopUnwarpX3, leftTopUnwarpY3, blendType, warpImgWeight3);
figure(6);
imshow(uint8(stitchedImage1))
figure(7);
imshow(uint8(stitchedImage2))
figure(8);
imshow(uint8(stitchedImage3))

% col_img = size(img1_1,2);
% figure(1);
% imshow([img1_1 img1_2])
% hold on
% plot(coord1_1(:,1), coord1_1(:,2),"ro")
% hold on
% plot(coord1_2(:,1)+col_img, coord1_2(:,2),"ro")
% hold on
% num_feat = size(coord1_1,1);
% for i=1:num_feat
%     line([coord1_1(i,1), coord1_2(i,1)+col_img],[coord1_1(i,2), coord1_2(i,2)],'Color','c');
% end



end