function accuracy_rate = accuracy_compute(image_dir,best_match1, best_match2)
% read transform matrix
mat_dir = strcat(image_dir, "H_1to2.txt");
hom_mat = readmatrix(mat_dir);
% transform all corners to corresponding pairs
length_corners = size(best_match1,1);
success_time = 0;
for i_len_corners=1:length_corners
    % obtain the current corner coordinates
    x_curr = best_match1(i_len_corners,1);
    y_curr = best_match1(i_len_corners,2);
    % conduct transformation
    trans_vec = [x_curr; y_curr;1];
    out = hom_mat*trans_vec;
    x_proj = out(1);
    y_proj = out(2);
    scale = out(3);
    x_proj = x_proj./scale;
    y_proj = y_proj./scale;
    % extract the corresponding x and y coordinates in best match 2
    x_corr = best_match2(i_len_corners,1);
    y_corr = best_match2(i_len_corners,2);
    % compute the euclidean different 
    var_x = power((x_corr-x_proj),2);
    var_y = power((y_corr-y_proj),2);
    magnitude = sqrt(var_x+var_y);
    if magnitude <= 2
        success_time = success_time + 1;
    end
end

% calculate the accuracy rate
accuracy_rate = success_time/length_corners;



end