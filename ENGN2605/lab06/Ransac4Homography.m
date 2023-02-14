function finalH = Ransac4Homography(matches1, matches2)

k = 1000;

best_homat = [];
max_inlier = 0;

for i_ter=1:k
    % randomly sample four matches from matches1 and matches2
    num_match = size(matches1,1);
    n_sample = 4;
    samp_coord = randsample(num_match,n_sample);
    for i_coord=samp_coord
       % grab out matches1 and matches2 coordinates
       x_coord1 = matches1(i_coord,1);
       y_coord1 = matches1(i_coord,2);
       x_coord2 = matches2(i_coord,1);
       y_coord2 = matches2(i_coord,2);
    end

    % form a matrix
    a_matrix = [];
    % retrieve the length of x coordinate
    num_coord = size(x_coord1,1);
    for i_ind=1:num_coord
        for i_xy=1:2
            if mod(i_xy,2) == 1 
                var1 = x_coord1(i_ind);
                var2 = y_coord1(i_ind);
                var3 = 1;
                var4 = 0;
                var5 = 0;
                var6 = 0;
                var7 = (-1)*x_coord1(i_ind)*x_coord2(i_ind);
                var8 = (-1)*x_coord2(i_ind)*y_coord1(i_ind);
                var9 = (-1)*x_coord2(i_ind);
                a_vec = [var1 var2 var3 var4 var5 var6 var7 var8 var9];
                a_matrix = cat(1,a_matrix,a_vec);
            else
                var1 = 0;
                var2 = 0;
                var3 = 0;
                var4 = x_coord1(i_ind);
                var5 = y_coord1(i_ind);
                var6 = 1;
                var7 = (-1)*x_coord1(i_ind)*y_coord2(i_ind);
                var8 = (-1)*y_coord1(i_ind)*y_coord2(i_ind);
                var9 = (-1)*y_coord2(i_ind);
                a_vec = [var1 var2 var3 var4 var5 var6 var7 var8 var9];
                a_matrix = cat(1,a_matrix,a_vec);
            end
        end
    end

    % solve the minimization problem
    at_matrix = transpose(a_matrix);
    aat_matrix = at_matrix*a_matrix;
    [U,S,V] = svd(aat_matrix);
    selected_eig_v = V(:,end);
    % reshape the eigenvalues into homography matrix
    homat = reshape(selected_eig_v,3,3);
    homat = transpose(homat);

    % using homography matrix for transforming one reference image to another
    num_coord = size(matches1,1);
    outcome_coord = zeros(num_coord,2);
    for i_coord=1:num_coord
        hom_vec = [matches1(i_coord,1); matches1(i_coord,2); 1];
        out_vec = homat*hom_vec;
        outcome_coord(i_coord,1) = out_vec(1)./out_vec(3);
        outcome_coord(i_coord,2) = out_vec(2)./out_vec(3);
    end

    num_inlier = 0;
    % count the number of inliners after homography transformation
    for i_coord=1:num_coord
       out = outcome_coord(i_coord,:)-matches2(i_coord,:);
       out = power(out(1),2)+power(out(2),2);
       out = sqrt(out);
       if out <= 1
           num_inlier = num_inlier + 1;
       end
    end
    
    if num_inlier >= max_inlier
       max_inlier = num_inlier;
       best_homat = homat;
    end
    
end

disp("max_inlier:")
disp(max_inlier)

finalH = best_homat;


end