%====================================
% Questions:
% 1. What should be fed to the essential matrix (match in pixel or in
% meter)? line 201 (checked)
% 2. For densification, I received opposite dimension? line 42 (checked)
% 3. R and T concept is correct? (if the two method will come out the same
% answer?) (checked)
% 4. Check if the concept of triangulation is correct line 70 (checked)
% 5. Check again if the rotation and translation matrix is correct at this
% time
% 6. How to display in scatter3 (there are two 3rd dimension data: color,
% and depth. how to solve it?) line 118
%=====================================


function lab8_question1()
% read image from directory
img1 = imread("data/1.jpg");
img2 = imread("data/2.jpg");
% resize the image
img1 = imresize(img1,0.25);
img2 = imresize(img2,0.25);

% extract sift features
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);
img1_single = single(img1);
img2_single = single(img2);
peak_thresh = 3;
[f1, d1] = vl_sift(img1_single,'PeakThresh',peak_thresh);
[f2, d2] = vl_sift(img2_single,'PeakThresh',peak_thresh);
% extract and match sift features
similarity_type = "SIFT";
[best_match, sec_match, simi_match, simi_match2] = find_matches(d1, d2, similarity_type,0.7);
[coord1,coord2] = coordinates_find_sift(best_match,simi_match,f1,f2);

% estimate an essential matrix
% import camera intrinsic matrix
load('cameraIntrinsicMatrix.mat');
gamma1 = coord1;
gamma2 = coord2;
[finalE, inlierIndx] = Ransac4Essential(gamma1,gamma2, K);
% grab out matched coordinates (checked)
len_coord = size(coord1,1);
% matched_coord1_temp = gamma1(inlierIndx,:);
% matched_coord2_temp = gamma2(inlierIndx,:);
matched_img1 = zeros(2,len_coord);
matched_img2 = zeros(2,len_coord);
for i=1:len_coord
    matched_img1(1,i) = gamma1(i,1);
    matched_img1(2,i) = gamma1(i,2); 
    matched_img2(1,i) = gamma2(i,1);
    matched_img2(2,i) = gamma2(i,2); 
%     matched_img1(1,i) = matched_coord1_temp(i,1);
%     matched_img1(2,i) = matched_coord1_temp(i,2);
%     matched_img2(1,i) = matched_coord2_temp(i,1);
%     matched_img2(2,i) = matched_coord2_temp(i,2);
end

% feed the inlier indices into densification function
img1_org = imread("data/1.jpg");
[denseMatchImg1, denseMatchImg2, denseInlierIndx] = Densification(finalE, K, matched_img1, matched_img2, inlierIndx, img1_org);

% find valid r and t from e
% first method
W = [0 -1 0;1 0 0;0 0 1];
[U,S,V] = svd(finalE);
R1 = U*W*transpose(V);
R2 = U*transpose(W)*transpose(V);
T1 = U(:,end);
T2 = (-1)*U(:,end);
R = cat(3,R1,R2);
T = cat(3,T1,T2);

% triangulation (needed some clarification)
% Checked all R and T
num_R = size(R,3);
num_T = size(T,3);
% loop through all correspondences
len_match = size(denseMatchImg1,2);
K_inv = inv(K);
% retrieve the true R and T
for i_R=1:num_R
    for i_T=1:num_T
        % extracted out corresponding R and T
        R_corr = R(:,:,i_R);
        T_corr = T(:,:,i_T);
        % randomly extract a point
        match1 = denseMatchImg1(:,50);
        match2 = denseMatchImg2(:,50);
        % convert it to meter
        vec1 = [match1(1);match1(2);1];
        vec2 = [match2(1);match2(2);1];
        match1_meter = K_inv*vec1;
        match2_meter = K_inv*vec2;
        % form linear system
        a = [(-1).*R_corr*match1_meter, match2_meter];
        b = T_corr;
        % solve for linear system
        depth = pinv(a)*b;
        % check if both phi are positive
        if depth(1)>0 && depth(2)>0
            R_final = R_corr;
            T_final = T_corr;
        end
    end
end

img1 = imread("data/1.jpg");
img1 = imresize(img1,0.25);


% convert all 3D reconstruction points for all matched points
num_inlier = length(denseInlierIndx);
recon_point = zeros(num_inlier,3);
rgb_point = zeros(num_inlier,3);

for i_match=1:num_inlier
   ind = denseInlierIndx(i_match);
   % grab out match points
   curr_match1 = denseMatchImg1(:,ind);
   curr_match2 = denseMatchImg2(:,ind);
   curr_match1 = [curr_match1(1);curr_match1(2);1];
   curr_match2 = [curr_match2(1);curr_match2(2);1];
   curr_match1_meter = K_inv*curr_match1;
   curr_match2_meter = K_inv*curr_match2; 
   % calculate the depth of two points
   a = [(-1).*R_final*curr_match1_meter, curr_match2_meter];
   b = T_final;
   [U,S,V] = svd(a,'econ');
   rho = V*diag(1./diag(S))*U'*b;
   depth = rho;
   
   % compute 3D points
   curr_match1_3D = depth(1)*curr_match1_meter;
   curr_match2_3D = depth(2)*curr_match2_meter;
   % take the med point
   curr_med_point = (curr_match1_3D+curr_match2_3D)/2;
   % store the point
   recon_point(i_match,:) = curr_med_point; %curr_match1_3D;
   color = img1(curr_match1(2),curr_match1(1),:);
   rgb_point(i_match,:) = double(color)./double(255);
end

figure(2);
scatter3(recon_point(:,1),recon_point(:,2), recon_point(:,3),2,rgb_point);



end    


% function that estimate the essential matrix
function [finalE, inlierIndx] = Ransac4Essential(gamma1,gamma2, K)

% number of iterations
num_iter = 5000;
% store the maximum number of inliers
max_num_inliers = 0;

for i=1:num_iter
    % randomly pick 5 correspondences (checked)
    num_coord = size(gamma1,1);
    samp_indx = randsample(num_coord,5);
    samp_correspondence1 = gamma1(samp_indx,:);
    samp_correspondence2 = gamma2(samp_indx,:);
    % transform correspondences into meter scale (checked)
    K_inv = inv(K);
    out_correspondence_meter = zeros(5,3,2);
    for i_point=1:5
        % extract coordinates
        coord1 = samp_correspondence1(i_point,:);
        coord2 = samp_correspondence2(i_point,:);
        % form vector for multiplication
        vec1 = [coord1 1];
        vec2 = [coord2 1];
        vec1 = reshape(vec1, [3,1]);
        vec2 = reshape(vec2, [3,1]);
        % multiply with intrinsic matrix
        vec1_world = K_inv*vec1;
        vec2_world = K_inv*vec2;
        % store the outcomes
        out_correspondence_meter(i_point,:,1) = vec1_world;
        out_correspondence_meter(i_point,:,2) = vec2_world;
    end

    % draw epiploar line
    % compute essential matrices
    Es = fivePointAlgorithmSelf(out_correspondence_meter);
    % for each valid essential matrix, calculate the coefficients of the
    % pipolar line
    num_Es = length(Es);
    max_num_inliers_iter = 0;
    for i_Es=1:num_Es
        Esi = Es{i_Es};
        Esi_bar = K_inv'*Esi*K_inv;
        n_feat = size(gamma1,1);
        
        % parameters setup
        num_inliers = 0;
        threshold = 2;
        inliers_ind = [];
        
        for i_feat=1:n_feat
            vec1 = [gamma1(i_feat,1);gamma1(i_feat,2);1];
            % compute coefficients
            A = Esi_bar(1,:)*vec1;
            B = Esi_bar(2,:)*vec1;
            C = Esi_bar(3,:)*vec1;
            % calculate the distances between the epipolar line and the
            % correspondences
            % extract out one correspondence (is the coordinate here
            % supposed to be in pixel or meter)
            curr_corpd = gamma2(i_feat,:);
            var1 = abs(A*curr_corpd(1) + B*curr_corpd(2) + C);
            var2 = sqrt(power(A,2) + power(B,2));
            dist = var1/var2;
            % check if the distance is within threshold
            if dist<=threshold
               num_inliers = num_inliers + 1;
               inliers_ind = cat(1,inliers_ind,i_feat);
            end
        end
        % after calculating the number of inliers for each essential
        % matrix, compare it with the overall maximum number of inliers for
        % this iteration
        if num_inliers > max_num_inliers_iter
            max_num_inliers_iter = num_inliers;
            max_num_inliers_iter_Es = Esi;
            max_num_inliers_iter_ind = inliers_ind;
        end
    end
    
    % in the end of each iteration, compare the maximum number of the current iteration
    % with current overall maximum number 
    if max_num_inliers_iter > max_num_inliers
       max_num_inliers = max_num_inliers_iter;
       max_num_inliers_Es = max_num_inliers_iter_Es;
       max_num_inliers_ind = max_num_inliers_iter_ind;
    end
        
end

num_coord = size(gamma1,1);
samp_indx = randsample(num_coord,3);
% randomly pick 3 correspondences 
samp_correspondence1 = gamma1(samp_indx,:);
samp_correspondence2 = gamma2(samp_indx,:);
% transform correspondences into meter scale
K_inv = inv(K);
out_correspondence_meter_draw = zeros(3,3,2);
for i_point=1:3
    % extract coordinates
     coord1 = samp_correspondence1(i_point,:);
     coord2 = samp_correspondence2(i_point,:);
     % form vector for multiplication
     vec1 = [coord1 1];
     vec2 = [coord2 1];
     vec1 = reshape(vec1, [3,1]);
     vec2 = reshape(vec2, [3,1]);
     % multiply with intrinsic matrix
     vec1_world = K_inv*vec1;
     vec2_world = K_inv*vec2;
     % store the outcomes
     out_correspondence_meter_draw(i_point,:,1) = vec1_world;
     out_correspondence_meter_draw(i_point,:,2) = vec2_world;
end
Es1_bar = K_inv'*max_num_inliers_Es*K_inv;
vec1 = [gamma1(1,1);...
        gamma1(1,2);...
        1];
vec2 = [gamma1(2,1);...
        gamma1(2,2);...
        1];
vec3 = [gamma1(3,1);...
        gamma1(3,2);...
        1];

finalA1 = Es1_bar(1,:)*vec1;
finalB1 = Es1_bar(2,:)*vec1;
finalC1 = Es1_bar(3,:)*vec1;
finalA2 = Es1_bar(1,:)*vec2;
finalB2 = Es1_bar(2,:)*vec2;
finalC2 = Es1_bar(3,:)*vec2;
finalA3 = Es1_bar(1,:)*vec3;
finalB3 = Es1_bar(2,:)*vec3;
finalC3 = Es1_bar(3,:)*vec3;

% read image from directory
img1 = imread("data/1.jpg");
img2 = imread("data/2.jpg");
% resize the image
img1 = imresize(img1,0.25);
img2 = imresize(img2,0.25);

% draw the line
img1_row = size(img1,1);
img1_col = size(img1,2);
img2_row = size(img2,1);
img2_col = size(img2,2);
final_n_bar1 = (-finalC1-finalA1)/finalB1;
final_n_bar_lim1 = (-finalC1-finalA1*img2_col)/finalB1;
final_n_bar2 = (-finalC2-finalA2)/finalB2;
final_n_bar_lim2 = (-finalC2-finalA2*img2_col)/finalB2;
final_n_bar3 = (-finalC3-finalA3)/finalB3;
final_n_bar_lim3 = (-finalC3-finalA3*img2_col)/finalB3;
figure(1);
comb_img = cat(2,img1,img2);
imshow(comb_img);
hold on
line([img1_col img1_col+img2_col],[final_n_bar1 final_n_bar_lim1],'Color','r');
hold on
plot(gamma2(1,1)+img1_col,gamma2(1,2),'rs');
hold on
plot(gamma1(1,1),gamma1(1,2),'rs');
hold on
line([img1_col img1_col+img2_col],[final_n_bar2 final_n_bar_lim2],'Color','k');
hold on
plot(gamma2(2,1)+img1_col,gamma2(2,2),'ks');
hold on
plot(gamma1(2,1),gamma1(2,2),'ks');
hold on
line([img1_col img1_col+img2_col],[final_n_bar3 final_n_bar_lim3],'Color','b');
hold on
plot(gamma2(3,1)+img1_col,gamma2(3,2),'bs');
hold on
plot(gamma1(3,1),gamma1(3,2),'bs');
hold on

% output the final best essential matrix 
finalE = max_num_inliers_Es;
inlierIndx = max_num_inliers_ind;


    
end
