function ppmtojpg_converter()
% count how many images inside the directory
img_dir = dir('problem_2\new_walking\*.ppm');
num_imgs = numel(img_dir);
mkdir problem_2\new_walking_jpg
% looping through each image to convert all of them into jpg
for i_img=1:num_imgs
    filename = img_dir(i_img).name;
    full_directory = strcat('problem_2\new_walking\',filename);
    img = imread(full_directory);
    save_dir = strcat('problem_2\new_walking_jpg\',string(i_img),'.jpg');
    imwrite(img,save_dir);
end


end