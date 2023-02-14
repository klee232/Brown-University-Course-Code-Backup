function [coord1,coord2] = coordinates_find(best_match,simi_match,input_corners1,input_corners2)
% form best match paired with similarity 
in_best_match = [best_match, simi_match];
% sort out the order for similairty 
sort_best_match = sortrows(in_best_match,3);
% grab out the coordinates
length_best_match = size(sort_best_match,1);
% generate the corresponding coordinates
coord1=zeros(length_best_match,2);
coord2=zeros(length_best_match,2);

% check which input_corners posses the larger dimension
max_sort_best_match1 = max(sort_best_match(:,1));
max_sort_best_match2 = max(sort_best_match(:,2));
if max_sort_best_match1 >= max_sort_best_match2
    large_match = sort_best_match(:,1);
    sec_match = sort_best_match(:,2);
else
    large_match = sort_best_match(:,2);
    sec_match = sort_best_match(:,1);
end

num_corner1 = size(input_corners1,1);
num_corner2 = size(input_corners2,1);
if num_corner1 > num_corner2
    ind_corn1_temp = large_match;
    ind_corn2_temp = sec_match;
else
    ind_corn1_temp = sec_match;
    ind_corn2_temp = large_match;
end


for i_match=1:length_best_match
    % grab out the index for corners
    ind_corn1=ind_corn1_temp(i_match);
    ind_corn2=ind_corn2_temp(i_match);
    corners1 = input_corners1(ind_corn1,1:2); 
    corners2 = input_corners2(ind_corn2,1:2);
    coord1(i_match,:)=[corners1(2), corners1(1)];
    coord2(i_match,:)=[corners2(2), corners2(1)];
end

end