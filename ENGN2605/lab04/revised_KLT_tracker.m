function tracked_corners = revised_KLT_tracker(image_dir,level,M)

% check if the folder is empty
directory = image_dir;
if ~isfolder(directory)
    error("The folder is empty");
end

% concatenate image in the folder
% check how many images in the folder
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
% looping through each image files and store them into one storage variable
for i_file=1:num_files
   currentfilename = imagefiles(i_file).name;
   currentfiledir = imagefiles(i_file).folder;
   currentfile = strcat(currentfiledir, "\", currentfilename);
   currentfile = imread(currentfile);
   currentfile = rgb2gray(currentfile);
   store_image(:,:,i_file) = currentfile;
end

% Setup the number of levels of intended image pyramid
num_levels = level;

for i_level=1:num_levels
    % Obtain corner information of the first frame
    first_img = store_image(:,:,1);
    % Create image pyramid 
    resolution = power(2,(i_level-1));
    first_img = imresize(first_img,1/resolution);
    corner_info1 = corner_detector(first_img);

    diff_thresdhold = 1;
    % grab out only the features from previous pyramid
    if i_level>1
       % scale the features from previous level
       tracked_corners_prev  = tracked_corners_prev./2;
       num_corners = size(tracked_corners_prev,1);
       % check if the current corner exist in the previous pyramid outcome
       corner_info1_temp = [];
       for i=1:num_corners
            corner_info = [corner_info1(:,2) corner_info1(:,1)];
            magnitudes = corner_info-tracked_corners_prev(i,:);
            [min_out,min_ind] = min(magnitudes,[],'all');
            if min_out < diff_thredhold
               corner_info1_temp =cat(1,corner_info1_temp,corner_info1(min_ind,:));
            end
       end
       corner_info1 = corner_info1_temp;
       % check if the current corner is empty
       if isempty(corner_info1)
           error("Error: Empty corner for this level")
       end

    end
    
    % Sorted out M Strongest Corners
    sorted_strong_corners = sortrows(corner_info1,3,'descend');
    num_M = size(sorted_strong_corners,1);
    
    % Create sotrage variable
    tracked_corners = zeros(num_M,2,num_files);
    for i_frame=1:num_files-1
        tracked_corners(:,:,i_frame) = 0;
        [dx, dy] = gradient(store_image(:,:,i_frame));
        strong_corners = zeros(num_M,2);
        for i_strength=1:num_M
            px = sorted_strong_corners((i_strength),2);
            py = sorted_strong_corners((i_strength),1);
            % create meshgrid with window size of 5*5
            m = 2;
            x = px-m:0.125:px+m;
            y = py-m:0.125:py+m;
            [X,Y] = meshgrid(x,y);
            % conduct interpolation for w and Ix and Iy
            W0 = interp2(store_image(:,:,i_frame),X,Y,'linear',0);
            Ix = interp2(dx,X,Y,'linear',0);
            Iy = interp2(dy,X,Y,'linear',0);
            % create variable for storing in M
            Ix2 = 0;
            Ixy = 0;
            Iy2 = 0;
            % looping through each element, sum up all the results and store them into correponding variables 
            x_num = size(Ix,1);
            y_num = size(Ix,2);
            for i_x=1:x_num
                for i_y=1:y_num
                    % create variable 
                    Ix2 = Ix2 + power(Ix(i_x,i_y),2);
                    Ixy = Ixy + Ix(i_x,i_y)*Iy(i_x,i_y);
                    Iy2 = Iy2 + power(Iy(i_x,i_y),2);
                end
            end
            % Compute the final M
            M = [Ix2 Ixy;Ixy Iy2];
            % Setup V0 bar
            V0_bar = [0 0];
            v_bar_k_1 = V0_bar;
            % iteration through K
            K = 15;
            threshold = 0.01;
            for k=1:K
                nx = x+v_bar_k_1(1);
                ny = y+v_bar_k_1(2);
                [wkx, wky] = meshgrid(nx,ny);
                Wk = interp2(store_image(:,:,i_frame+1),wkx,wky,'linear',0);
                delta_Ik = W0-Wk;
                % compute b_bar matrix
                % create variable for storing
                x_num = size(delta_Ik,1);
                y_num = size(delta_Ik,2);
                upp = 0;
                low = 0;
                for i_x=1:x_num
                    for i_y=1:y_num
                        upp = upp+delta_Ik(i_x,i_y)*Ix(i_x,i_y);
                        low = low+delta_Ik(i_x,i_y)*Iy(i_x,i_y);
                    end
                end
                b_bar = [upp;low];
                % compute error vector
                error_k = inv(M)*b_bar;
                % compute the displacement vector for current iteration
                v_bar_k = v_bar_k_1+error_k;
                % if the magnitude of the current error is under the threshold
                % terminate the iteration
                if norm(error_k) < threshold
                   strong_corners(i_strength,:) = [px py] + [v_bar_k(1) v_bar_k(2)];
                   break
                % if it's not, update the current displacement vector and move
                % on to the next iteration
                else
                    strong_corners(i_strength,:) = 0;
                    v_bar_k_1 = v_bar_k;
                end 
            end
        end
        min_num_feat = 10;
        % check how many rows are entirely zero
        strong_corners(all(strong_corners==0,2),:)=[];
        num_nonzeros = size(strong_corners,1);
        % if the number of features falls under the number of the minimum
        % requirement, conpensate that number to the minimum requirement
        if num_nonzeros < min_num_feat
           conpensate_num = num_nonzeros - min_num_feat;
           corners_conmpensate = corner_detector(store_image(:,:,i_frame));
           % Sorted out M Strongest Corners
           sorted_corners_conpentate = sortrows(corners_conmpensate,3,'descend');
           sorted_corners_conpentate = sorted_corners_conpentate(1:conpensate_num,:);
           % concatenate the conpensate corners into strong corners and move on
           strong_corners = cat(1, strong_corners, sorted_corners_conpentate);
        end
        size_strong_corners = size(strong_corners,1);
        tracked_corners(1:size_strong_corners,:,i_frame) = strong_corners;

        % save the latest features for current level of pyramid
        if i_frame==num_files-1 && ~isempty(tracked_corners)
           tracked_corners_prev = tracked_corners(:,:,i_frame);
        end
        
        if i_level==num_levels
            % plot the current figure
            % check outcome
            x_coord = [];
            y_coord = [];
            for i_len=1:num_M
                x = tracked_corners(i_len,1,i_frame);
                y = tracked_corners(i_len,2,i_frame);
                if x~=0 || y~=0
                    x_coord = cat(1, x_coord,x);
                    y_coord = cat(1, y_coord,y);
                end
            end
            % plot the outcomes
            % plot the final picture
            imgs_dir = strcat(image_dir,'\*.ppm');
            imgs_dir = dir(imgs_dir);
            pic_dir = strcat(image_dir,'\',imgs_dir(i_frame+1).name);
            img = imread(pic_dir);
            imshow(img);
            hold on 
            plot(y_coord,x_coord,"ro");
            mkdir problem_2\new_walking_revised
            newfilename = strcat('problem_2\new_walking_revised','\','new',imgs_dir(i_frame+1).name);
            disp(newfilename);
            saveas(gcf,newfilename);
        end
    end
end
    
% check outcome
x_coord = [];
y_coord = [];
for i_len=1:num_M
    x = tracked_corners(i_len,1,num_files-1);
    y = tracked_corners(i_len,2,num_files-1);
    if x~=0 || y~=0
       x_coord = cat(1, x_coord,x);
       y_coord = cat(1, y_coord,y);
    end
end



end
