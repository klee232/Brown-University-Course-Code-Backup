function question1()
% read in transit matrices and rotation matrices
load('data/Question1/cameraIntrinsicMatrix.mat'); % K values
load('data/Question1/cameraPoses.mat'); % R and T matrices
load('data/Question1/scenePointCloud.mat'); % Provided scene point
camIntri = K;
rotation1 = R1;
rotation2 = R2;
transit1 = T1;
transit2 = T2;
world_coord = scenePointCloud.Location;

% project the world coordinates point onto image plane
length_coord = size(world_coord,1);
width_coord = size(world_coord,2);
image_coord1 = zeros(length_coord,2);
image_coord2 = zeros(length_coord,2);
for ipoint=1:length_coord
    % grab out current location
    curr_coord_x = world_coord(ipoint,1);
    curr_coord_y = world_coord(ipoint,2);
    curr_coord_z = world_coord(ipoint,3);
    curr_coord = [curr_coord_x;curr_coord_y;curr_coord_z];
    % Rotation and translation
    out1 = R1*curr_coord + T1;
    out2 = R2*curr_coord + T2;
    % intrinsic calibration
    out1 = K*out1;
    out2 = K*out2;
    out1 = out1./out1(3);
    out2 = out2./out2(3);
    % check if the outcome is within the range
    % if so, store it into the outcome matrix
    if (out1(1) <= 1600 && out1(1) >= 1) && (out1(2) <= 1200 && out1(2) >= 1)
       image_coord1(ipoint,1) = out1(1);
       image_coord1(ipoint,2) = out1(2);
    end
    if (out2(1) <= 1600 && out2(1) >= 1) && (out2(2) <= 1200 && out2(2) >= 1)
        image_coord2(ipoint,1) = out2(1);
        image_coord2(ipoint,2) = out2(2);
    end
end

% display the outcome
colors = scenePointCloud.Color;
image1_mat = zeros(1200,1600,3);
image2_mat = zeros(1200,1600,3);
for ipoint=1:length_coord
    % grab out the point 
    point_img1 = image_coord1(ipoint,:);
    img1_point_x = point_img1(1);
    img1_point_y = point_img1(2);
    point_img2 = image_coord2(ipoint,:);
    img2_point_x = point_img2(1);
    img2_point_y = point_img2(2);
    % check if it's a nonzero
    % image 1 case
    if (img1_point_x > 0) && (img1_point_y > 0)
        img1_point_x = round(img1_point_x);
        img1_point_y = round(img1_point_y);
        R1 = colors(ipoint,1);
        G1 = colors(ipoint,2);
        B1 = colors(ipoint,3);
        image1_mat(img1_point_y,img1_point_x,1)=R1;
        image1_mat(img1_point_y,img1_point_x,2)=G1;
        image1_mat(img1_point_y,img1_point_x,3)=B1;
    end
    % image 2 case 
    if (img2_point_x > 0) && (img2_point_y > 0)
        img2_point_x = round(img2_point_x);
        img2_point_y = round(img2_point_y);
        R2 = colors(ipoint,1);
        G2 = colors(ipoint,2);
        B2 = colors(ipoint,3);        
        image2_mat(img2_point_y,img2_point_x,1)=R2;
        image2_mat(img2_point_y,img2_point_x,2)=G2;
        image2_mat(img2_point_y,img2_point_x,3)=B2; 
    end    
end

figure(1);
imshow(uint8(image1_mat));

figure(2);
imshow(uint8(image2_mat));


% use meshgrid and griddata
[xq,yq] = meshgrid(1:1600, 1:1200);
x1 = image_coord1(:,1);
y1 = image_coord1(:,2);
v1_r = double(colors(:,1));
v1_g = double(colors(:,2));
v1_b = double(colors(:,3));
out1 = zeros(1200,1600,3);
out1(:,:,1) = griddata(x1,y1,v1_r,xq,yq);
out1(:,:,2) = griddata(x1,y1,v1_g,xq,yq);
out1(:,:,3) = griddata(x1,y1,v1_b,xq,yq);

x2 = image_coord2(:,1);
y2 = image_coord2(:,2);
v2_r = double(colors(:,1));
v2_g = double(colors(:,2));
v2_b = double(colors(:,3));
out2 = zeros(1200,1600,3);
out2(:,:,1) = griddata(x2,y2,v2_r,xq,yq);
out2(:,:,2) = griddata(x2,y2,v2_g,xq,yq);
out2(:,:,3) = griddata(x2,y2,v2_b,xq,yq);

figure(3);
imshow(uint8(out1));

figure(4);
imshow(uint8(out2));


end