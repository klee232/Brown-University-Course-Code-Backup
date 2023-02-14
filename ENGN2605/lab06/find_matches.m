function [indx_1st_best, indx_2nd_best, ...
          simi_1st_best, simi_2nd_best] = find_matches(D1, D2, similarity_type,alpha_in)
% setting up parameters
alpha = alpha_in;

% find out the dimension of D1 and D2
if strmatch(similarity_type, "Chi-Square")
    num_D1 = size(D1,1);
elseif strmatch(similarity_type, "SIFT")
    num_D1 = size(D1,2);
else
    num_D1 = size(D1,3);
end    

% create storage variable
indx_1st_best = zeros(num_D1,2);
indx_2nd_best = zeros(num_D1,2);
simi_1st_best = zeros(num_D1,1);
simi_2nd_best = zeros(num_D1,1);

for i_D1=1:num_D1
    % check the input string type
    if strmatch(similarity_type,"SSD")
        % grab out corresponding D1
        corr_D1 = D1(:,:,i_D1);
        % minus all D2 with corresponding D1
        diff = D2-corr_D1;
        diff = power(diff,2);
        diff = sum(diff,[1 2]);
        % grab out first minimum and second minimum
        [first_min, first_min_ind] = min(diff,[],3); % checked
        second_min= min(diff(diff>first_min));
        second_min_ind = find(diff==second_min,1);
        % store those into index variable
        indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
        indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
        simi_1st_best(i_D1)=first_min;
        simi_2nd_best(i_D1)=second_min;
    % perform NCC for NCC input
    elseif strmatch(similarity_type, "NCC")
        % grab out corresponding D1
        corr_D1_temp = D1(:,:,i_D1);
        % calculate the mean of the corresponding D1
        mean_corr_D1 = mean(corr_D1_temp,[1 2]);
        % get the norm of D1
        abs_cent = norm(corr_D1_temp);
        % conduct NCC calculation
        corr_D1 = corr_D1_temp - mean_corr_D1;
        corr_D1 = corr_D1./abs_cent;
        % conduct the D2 part
        corr_D2_temp = D2;
        mean_corr_D2 = mean(corr_D2_temp,[1 2]);
        corr_D2 = corr_D2_temp - mean_corr_D2;
        num_corr_D2 = size(corr_D2,3);
        abs_cent = zeros(1,1,num_corr_D2);
        for i=1:num_corr_D2
            abs_cent(:,:,i) = norm(corr_D2_temp(:,:,i));
            corr_D2(:,:,i) = corr_D2(:,:,i)./abs_cent(:,:,i);
        end
%         abs_cent = pagenorm(corr_D2_temp);
%         corr_D2 = corr_D2./abs_cent;
        % subtract each other and conduct the square
        diff = corr_D2 - corr_D1;
        diff = power(diff,2);
        diff = sum(diff,[1 2]);
        % grab out first minimum and second minimum
        [first_min, first_min_ind] = min(diff,[],3);
        second_min = min(diff(diff>first_min));
        second_min_ind = find(diff==second_min,1);
        % store those into index variable
        indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
        indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
        simi_1st_best(i_D1)=first_min;
        simi_2nd_best(i_D1)=second_min;
    % if the input is chi-square, conduct chi-square calculation
    elseif strmatch(similarity_type, "Chi-Square")
        % grab out corresponding D1
        corr_D1 = D1(i_D1,:);
        diff = D2-corr_D1;
        diff = power(diff,2);
        summ = D2+corr_D1;
        out = diff./summ;
        out(find(isnan(out)))=0;
        out = sum(out, 2);
        out = 0.5*out;
        % grab out first minimum and second minimum
        [first_min, first_min_ind] = min(out,[],1);
        [second_min, second_min_ind]= min(out(out>first_min));
        % store those into index variable
        indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
        indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
        simi_1st_best(i_D1)=double(first_min);
        simi_2nd_best(i_D1)=double(second_min);
    % implement SIFT distance calculation
    elseif strmatch(similarity_type, "SIFT")
        corr_D1 = D1(:,i_D1);
        diff = D2-corr_D1;
        diff = power(diff,2);
        diff = sum(diff,1);
        diff = sqrt(diff);
        % grab out first minimum and second minimum
        [first_min, first_min_ind] = min(diff,[],2);
        second_min= min(diff(diff>first_min));
        second_min_ind = find(diff==second_min,1);
        % store those into index variable
        indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
        indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
        simi_1st_best(i_D1)=first_min;
        simi_2nd_best(i_D1)=second_min;
    % output error message if the analysis method is unfound.
    else
        error("Unknown analysis has been input. Please type SSD, NCC, or Chi-Square for similarity_type");
    end
    % Lowe's Test Ratio
    % if it fails the test, discard the value
    if simi_1st_best(i_D1) >= alpha*simi_2nd_best(i_D1)
        indx_1st_best(i_D1,:)=0;
        indx_2nd_best(i_D1,:)=0;
        simi_1st_best(i_D1)=0;
        simi_2nd_best(i_D1)=0;
    end
end

% filter out zero values
indx_1st_best(~any(simi_1st_best,2),:)=[];
indx_2nd_best(~any(simi_2nd_best,2),:)=[];
simi_1st_best(~any(simi_1st_best,2),:)=[];
simi_2nd_best(~any(simi_2nd_best,2),:)=[];

end