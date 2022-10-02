function corners1 = lab4()

% Problem 1
image1 = imread('problem_1\board.png');
image2 = imread('problem_1\coliseum.jpg');
image3 = imread('problem_1\gantrycrane.png');
corners1 = corner_detector(image1);
corners2 = corner_detector(image2);
corners3 = corner_detector(image3);
grayimage1 = rgb2gray(image1);
figure(1);
imshow(image1);
hold on
plot(corners1);


figure(2);
imshow(corners2);
figure(3);
imshow(corners3);


end