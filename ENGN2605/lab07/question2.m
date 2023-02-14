%function question2()
% read in images and intrinsic matrix
img1 = imread("data/Question2/1.png");
img2 = imread("data/Question2/2.png");
int_mat = load("data/Question2/intrinsicMatrix.mat");
int_mat = int_mat.K;

% extract sift features
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);
img1_single = single(img1);
img2_single = single(img2);
peak_thresh = 3;
[f1, d1] = vl_sift(img1_single,'PeakThresh',peak_thresh);
[f2, d2] = vl_sift(img2_single,'PeakThresh',peak_thresh);

% find reliable feature correspondences
similarity_type = "SIFT";
[best_match, sec_match, simi_match, simi_match2] = find_matches(d1, d2, similarity_type,0.7);
[coord1,coord2] = coordinates_find_sift(best_match,simi_match,f1,f2);
[homat, inliers_ind] = Ransac4Homography(coord1, coord2);

% compute essential matrix
% sample out five inliers
samp_inliers = inliers_ind(1:5);
out_coord = zeros(5,3,2);
out_coord_m = zeros(5,3,2);

for i=1:5
    ind_inlier = samp_inliers(i);
    x1 = coord1(ind_inlier,1);
    y1 = coord1(ind_inlier,2);
    x2 = coord2(ind_inlier,1);
    y2 = coord2(ind_inlier,2);
    samp_coord1 = [x1; y1; 1];
    samp_coord2 = [x2; y2; 1];
    out1 = inv(int_mat)*samp_coord1;
    out2 = inv(int_mat)*samp_coord2;
    out_coord(i,:,1) = samp_coord1;
    out_coord(i,:,2) = samp_coord2;
    out_coord_m(i,:,1) = out1;
    out_coord_m(i,:,2) = out2;
end
Es = fivePointAlgorithmSelf(out_coord_m);

% draw an epipolar line
Es1 = Es{1};
int_mat_inv = inv(int_mat);
Es1_bar = int_mat_inv'*Es1*int_mat_inv;
vec = [out_coord(1,1,1);out_coord(1,2,1);out_coord(1,3,1)];
A = Es1_bar(1,:)*vec;
B = Es1_bar(2,:)*vec;
C = Es1_bar(3,:)*vec;
% draw the line
img1_row = size(img1,1);
img1_col = size(img1,2);
img2_row = size(img2,1);
img2_col = size(img2,2);
n_bar = (-C-A)/B;
n_bar_lim = (-C-A*img2_col)/B;


figure(1);
comb_img = cat(2,img1,img2);
imshow(comb_img);
hold on
line([img1_col img1_col+img2_col],[n_bar n_bar_lim],'Color','r');
hold on
plot(out_coord(1,1,2)+img1_col,out_coord(1,2,2),'rs');
hold on
plot(out_coord(1,1,1),out_coord(1,2,1),'rs');



%end