function [pairs,f2] = problem4_revised()
% read image
dir = "problem_3_and_4\set1\";
image1 = "img1.png";
image2 = "img2.png";
image1_dir = strcat(dir,image1);
image2_dir = strcat(dir,image2);
image1 = imread(image1_dir);
image2 = imread(image2_dir);
% convert image
if size(image1,3)==3
    image1 = single(rgb2gray(image1));
    image2 = single(rgb2gray(image2));
else
    image1 = single(image1);
    image2 = single(image2);
end

% compute the corner information
corner1 = corner_detector(image1);
% load homography matrix
hom_mat = readtable("problem_3_and_4\set1\H_1to2.txt");
hom_mat = table2array(hom_mat);
% get how many feautres 
num_feat = size(corner1,1);
% obtain image size
len_img2 = size(image2,1);
wid_img2 = size(image2,2);
% create storage variable 
feat_store = zeros(num_feat,2);
% loop through each feature to apply homography matrix
for i_feat=1:num_feat
    curr_f1 = [corner1(i_feat,2); corner1(i_feat,1); 1];
    corr_f2 = hom_mat*curr_f1;
    % check if the corresponding point falls out of the range
    if (corr_f2(1) >= 1 && corr_f2(1) <= wid_img2) && (corr_f2(2) >= 1 && corr_f2(2) <= len_img2)
        feat_store(i_feat,1) = corr_f2(1);
        feat_store(i_feat,2) = corr_f2(2);
    end    
end
% extract corners for image 2
corner2 = corner_detector(image2);
num_feats = size(corner2,1);
% create storage vriable for feature 2
loc_f2 = [corner2(:,2), corner2(:,1)];
% create storage variable for paired features
pairs = [];
threshold = 1;
% looping through 
for i_feat=1:num_feats
    current = feat_store(i_feat,:);
    % check if it's a zero vector
    if all(current,'all')
        out = loc_f2-current;
        out = vecnorm(out,2,2);
        [min_out, min_ind] = min(out);
        if abs(min_out) < threshold
            f1_pair = current;
            f2_pair = loc_f2(min_ind,:);
            f1_f2_pair = [f1_pair f2_pair];
            pairs = cat(1,pairs,f1_f2_pair);
        end
    end        
end
% compute hte repeatability rate 
left_feat_num = size(corner1,1);
corr_feat_num = size(pairs,1);
repeat_rate = corr_feat_num/left_feat_num;
disp("The repeat rate is:");
disp(repeat_rate)
end