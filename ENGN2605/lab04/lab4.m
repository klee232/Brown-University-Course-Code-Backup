function corners = lab4()

% % Problem 1
% image1 = imread('problem_1\board.png');
% image2 = imread('problem_1\coliseum.jpg');
% image3 = imread('problem_1\gantrycrane.png');
% image = checkerboard(50,10,10);
% corner_check = corner_detector(image);
% corners1 = corner_detector(image1);
% corners2 = corner_detector(image2);
% corners3 = corner_detector(image3);
% grayimage1 = rgb2gray(image1);
% grayimage2 = rgb2gray(image2);
% grayimage3 = rgb2gray(image3);
% figure(1);
% imshow(grayimage1);
% hold on
% plot(corners1(:,2),corners1(:,1),"ro");
% hold off
% figure(2);
% imshow(grayimage2);
% hold on
% plot(corners2(:,2),corners2(:,1),"ro");
% hold off
% figure(3);
% imshow(grayimage3);
% hold on
% plot(corners3(:,2),corners3(:,1),"ro");
% hold off

% Problem 2
M = 20;
dir1 = "problem_2\rubix";
corners = KLT_tracker(dir1,M);
dir1 = "problem_2\car";
corners = KLT_tracker(dir1,M);
dir1 = "problem_2\walking";
corners = KLT_tracker(dir1,M);

% Problem 3
dir = "problem_3_and_4";
set = "set1";
problem3(dir,set);

% Problem 4
[pairs] = problem4(dir,set);
[pairs_revised] = problem4_revised();

% Problem 5
[pairs_seq] = problem5();
[pairs_seq_revised] = problem5();


end