function [coord1,coord2] = coordinates_find_sift(best_match,simi_match,input_f1,input_f2)
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

num_corner1 = size(input_f1,2);
num_corner2 = size(input_f2,2);
if num_corner1 > num_corner2
    ind_f1_temp = large_match;
    ind_f2_temp = sec_match;
else
    ind_f1_temp = sec_match;
    ind_f2_temp = large_match;
end


for i_match=1:length_best_match
    % grab out the index for corners
    ind_f1=ind_f1_temp(i_match);
    ind_f2=ind_f2_temp(i_match);
    f1 = input_f1(1:2,ind_f1); 
    f2 = input_f2(1:2,ind_f2);
    coord1(i_match,:)=[f1(1), f1(2)];
    coord2(i_match,:)=[f2(1), f2(2)];
end

end