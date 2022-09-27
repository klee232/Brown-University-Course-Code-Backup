function outimage = filter_thre_img(image, threshold)
% threshold = double(threshold);
% image = double(image);
% Obtain the size of the image
length_img = size(image,1);
width_img = size(image,2);
% Looping through each pixel to see if it's above or below the threshold
outimage = image;
for i_len=1:length_img
   for i_wid=1:width_img
       current_pixel = image(i_len,i_wid);
       disp('current_pixel')
       disp(current_pixel)
       if current_pixel < threshold
          outimage(i_len,i_wid) = 0;
          disp('it reached here')
          disp(outimage(i_len,i_wid) )
       end
   end
end

end