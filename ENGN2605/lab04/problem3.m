function problem3()
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
% compute sift frames
peak_thresh = 10;
edge_thresh = 3.5;
[f1,d1] = vl_sift(image1,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
[f2,d2] = vl_sift(image2,'PeakThresh',peak_thresh,'edgethresh',edge_thresh);
% visualize the outcomes
figure(1);
image1 = imread(image1_dir);
image2 = imread(image2_dir);
len_img1 = size(image1,1);
wid_img1 = size(image1,2);
comb_img = cat(2,image1,image2);
imshow(comb_img);
hold on
perm=randperm(size(f1,2));
sel = perm(1:50);
h1 = vl_plotframe(f1(:,sel));
h2 = vl_plotframe(f1(:,sel));
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d1(:,sel),f1(:,sel)) ;
set(h3,'color','g') ;
hold on
perm=randperm(size(f2,2));
sel = perm(1:50);
h1 = vl_plotframe(f2(:,sel));
h2 = vl_plotframe(f2(:,sel));
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d2(:,sel),f2(:,sel)) ;
set(h3,'color','g') ;

% matching
[matches,scores] = vl_ubcmatch(d1,d2);

end