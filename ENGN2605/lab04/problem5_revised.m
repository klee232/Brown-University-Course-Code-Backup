function pairs = problem5_revised()
% calculate the number of image inside the directory
img_dir = dir('problem_5\*.png');
num_imgs = numel(img_dir);

% create variable for storing paris
pairs = [];

% looping through each image
for i_img=1:num_imgs-1
   % check if the pairs is empty 
   if i_img>=2 && isempty(pairs)
       message="Code terminated at %s, %s";
       disp(sprintf(message,string(i_img), string(i_img+1)));
       break
   end
    
   % obtain the file directories
   folder_dir = 'problem_5\';
   img_ind_1 = string(i_img);
   img_ind_2 = string(i_img+1);
   img_ind_1_dir = strcat(folder_dir,img_ind_1,'.png');
   img_ind_2_dir = strcat(folder_dir,img_ind_2,'.png');
   image1 = imread(img_ind_1_dir);
   image2 = imread(img_ind_2_dir);
   disp("current iteration:")
   disp(strcat(img_ind_1,',',img_ind_2));
   % convert the image if necessary
   if size(image1,3)==3
       image1 = single(rgb2gray(image1));
       image2 = single(rgb2gray(image2));
   else
       image1 = single(image1);
       image2 = single(image2);
   end
   
   % compute the sift frames for image1
   % extract features from first feature
   % if this is the first iteration, grab out feautre of the first image
   % directly
   if i_img==1
       f1 = corner_detector(image1);
       f1 = [f1(:,2) f1(:,1)];
   % if it's not jut grab out the previous corresponding f2 paris
   else
       f1 = pairs(:,3:4);
       pairs=[];
   end
   
   % load homography matrix
   mat_dir = strcat(folder_dir,'H_',img_ind_1,'to',img_ind_2,'.txt');
   hom_mat = readmatrix(mat_dir);
   hom_mat1 = hom_mat(1,:);
   hom_mat1 = hom_mat1(~isnan(hom_mat1));
   hom_mat2 = hom_mat(2,:);
   hom_mat2 = hom_mat2(~isnan(hom_mat2));
   hom_mat3 = hom_mat(3,:);
   hom_mat3 = hom_mat3(~isnan(hom_mat3));
   hom_mat = cat(1,hom_mat1,hom_mat2,hom_mat3);
   
   % translate the features from f1
   % get how many feautres 
   num_feat = size(f1,1);
   % obtain image size
   len_img2 = size(image2,1);
   wid_img2 = size(image2,2);
   % create storage variable 
   feat_store = [];
   % loop through each feature to apply homography matrix
   for i_feat=1:num_feat
       curr_f1 = [f1(i_feat,1); f1(i_feat,2); 1];
       corr_f2 = hom_mat*curr_f1;
       corr_f2 = corr_f2./corr_f2(3);
       % check if the corresponding point falls out of the range
       if (corr_f2(1,1) >= 1 && corr_f2(1,1) <= wid_img2) && (corr_f2(2,1) >= 1 && corr_f2(2,1) <= len_img2)
           feat_loc = [corr_f2(1,1) corr_f2(2,1)];
           feat_store = cat(1,feat_store,feat_loc);
       end    
   end
   
   % extract feature for image 2
   f2 = corner_detector(image2);
   f2 = [f2(:,2) f2(:,1)];
   
   % conduct pair matching
   % create storage variable for paired features
   threshold = sqrt(8);
   num_feat = size(feat_store,1);
   % looping through 
   for i_feat=1:num_feat
       % if this is the first iteration store the corresponding pairs
       % directly
       current = feat_store(i_feat,:);
       % check if it's a zero vector
       out = f2-current;
       out = vecnorm(out,2,2);
       [min_out, min_ind] = min(out);
       if min_out < threshold
          f1_pair = current;
          f2_pair = f2(min_ind,:);
          f1_f2_pair = [f1_pair f2_pair];
          pairs = cat(1,pairs,f1_f2_pair);
       end
   end
   
   % compute hte repeatability rate
   left_feat_num = size(f1,1);
   corr_feat_num = size(pairs,1);
   repeat_rate = corr_feat_num/left_feat_num;
   disp("The repeat rate is:");
   disp(repeat_rate)
   
end

end