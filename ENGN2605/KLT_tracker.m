function out = KLT_tracker(image_dir)

% Concatenate image in the folder
directory = image_dir;
% Check if the folder is empty
if ~isfolder(directory)
    error("The folder is empty");
end
filePattern = fullfile(directory, '*.jpg');
imagefiles = dir(filePattern);
num_files = length(imagefiles);
% create storage variable
currentfilename = imagefiles(1).name;
currentfiledir = imagefiles(1).folder;
currentfile = strcat(currentfiledir, "\", currentfilename);
currentfile = imread(currentfile);
length_img = size(currentfile,1);
width_img = size(currentfile,2);
store_image = zeros(length_img,width_img,num_files);
% looping through each image files
for i_file=1:num_files
   currentfilename = imagefiles(i_file).name;
   currentfiledir = imagefiles(i_file).folder;
   currentfile = strcat(currentfiledir, "\", currentfilename);
   currentfile = imread(currentfile);
   currentfile = rgb2gray(currentfile);
   store_image(:,:,i_file) = currentfile;
end

% KLT Algorithm
% Obtain corner information of the first frame
first_img = store_image(:,:,1);
corner_info1 = corner_detector(first_img);
% Sorted out M Strongest Corners
M = 20;
sorted_strong_corners = sortrows(corner_info1,3,'descend');
sorted_strong_corners = sorted_strong_corners(:,:,1:M);

for i_frame=1:num_files-1
    tracked_corners(i_frame) = 0;
    [dx dy] = gradient(store_image(:,:,i_frame));
    for i_strength=1:M
        [px py] = sorted_strong_corners(:,:,i_strength);
        m = 2;
        x = px-m:px+m;
        y = py-m:py+m;
        [X,Y] = meshgrid(x,y);
        W = interp2(sorted_strong_corners(:,:,i_strength),x,y,0);
        Ix = interp2(X,x,y,0);
        Iy = interp2(Y,x,y,0);
    end
    
end




out = store_image;
end