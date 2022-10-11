function [indx_1st_best, indx_2nd_best, ...
          simi_1st_best, simi_2nd_best] = find_matches_revised(D1, D2, similarity_type,alpha_in)
% setting up parameters
alpha = alpha_in;

% find out the dimension of D1 and D2
if strmatch(similarity_type, "Chi-Square")
    num_D1 = size(D1,1);
    num_D2 = size(D2,1);
    % compare the number of D1 and D2, and pick up the smaller one
    if num_D1 <= num_D2
        D1_temp = D1;
        D2_temp = D2;
        num_D1 = num_D1;
    else
        D1_temp = D2;
        D2_temp = D1;
        num_D1 = num_D2;
    end
else
    num_D1 = size(D1,3);
    num_D2 = size(D2,3);
    % compare the number of D1 and D2, and pick up the smaller one
    if num_D1 <= num_D2
        D1_temp = D1;
        D2_temp = D2;
        num_D1 = num_D1;
    else
        D1_temp = D2;
        D2_temp = D1;
        num_D1 = num_D2;
    end
end    

% create storage variable
indx_1st_best = zeros(num_D1,2);
indx_2nd_best = zeros(num_D1,2);
simi_1st_best = zeros(num_D1,1);
simi_2nd_best = zeros(num_D1,1);

for i_D1=1:num_D1
    % check the input string type
    if strmatch(similarity_type,"SSD")
        % forward matching
        % grab out corresponding D1
        corr_D1 = D1_temp(:,:,i_D1);
        % minus all D2 with corresponding D1
        diff = D2_temp-corr_D1;
        diff = power(diff,2);
        diff = sum(diff,[1 2]);
        % grab out first minimum and second minimum
        [first_min, first_min_ind] = min(diff,[],3); % checked
        second_min= min(diff(diff>first_min));
        second_min_ind = find(diff==second_min,1);
        % backward matching
        corr_D2 = D2_temp(:,:,first_min_ind);
        diff = D1_temp-corr_D2;
        diff = power(diff,2);
        diff = sum(diff,[1 2]);
        [first_min_back, first_min_ind_back] = min(diff,[],3);
        back_D1 = D1_temp(:,:,first_min_ind_back);
        % compare if the two indices are equal
        if first_min_ind_back == i_D1
            % check if the current first_min_ind existed
            if ~ismember(first_min_ind,indx_1st_best)
                % store those into index variable
                indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
                indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
                simi_1st_best(i_D1)=first_min;
                simi_2nd_best(i_D1)=second_min;
            % if the element exists in the current array, check if its get
            % the highest similarity score
            else
                % obtain that similarity score
                [row_pre_min,col_pre_min] = find(indx_1st_best(:,2)==first_min_ind);
                pre_min_score = simi_1st_best(row_pre_min);
                % if the current score is larger than the previous score,
                % reset the current index and score as zero.
                if first_min > pre_min_score
                   % store those into index variable
                   indx_1st_best(i_D1,:)=0;
                   indx_2nd_best(i_D1,:)=0;
                   simi_1st_best(i_D1)=0;
                   simi_2nd_best(i_D1)=0;
                % if the current is smaller than the previosu score, reset
                % the previous index and score as zero.
                else
                   indx_1st_best(row_pre_min,:)=0;
                   indx_2nd_best(row_pre_min,:)=0;
                   simi_1st_best(row_pre_min)=0;
                   simi_2nd_best(row_pre_min)=0;
                   indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
                   indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
                   simi_1st_best(i_D1)=first_min;
                   simi_2nd_best(i_D1)=second_min;
                end
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

    % perform NCC for NCC input
    elseif strmatch(similarity_type, "NCC")
        % forward matching
        % grab out corresponding D1
        corr_D1_temp = D1_temp(:,:,i_D1);
        % calculate the mean of the corresponding D1
        mean_corr_D1 = mean(corr_D1_temp,[1 2]);
        % get the norm of D1
        abs_cent = norm(corr_D1_temp);
        % conduct NCC calculation
        corr_D1 = corr_D1_temp - mean_corr_D1;
        corr_D1 = corr_D1./abs_cent;
        % conduct the D2 part
        corr_D2_temp = D2_temp;
        mean_corr_D2 = mean(corr_D2_temp,[1 2]);
        corr_D2 = corr_D2_temp - mean_corr_D2;
        abs_cent = pagenorm(corr_D2_temp);
        corr_D2 = corr_D2./abs_cent;
        % subtract each other and conduct the square
        diff = corr_D2 - corr_D1;
        diff = power(diff,2);
        diff = sum(diff,[1 2]);
        % grab out first minimum and second minimum
        [first_min, first_min_ind] = min(diff,[],3);
        second_min = min(diff(diff>first_min));
        second_min_ind = find(diff==second_min,1);
        % backward matching
        corr_D2_bac = D2_temp(:,:,first_min_ind);
        mean_corr_D2_bac = mean(corr_D2_bac, [1 2]);
        abs_cent = norm(corr_D2_bac);
        corr_D2_bac = corr_D2_bac - mean_corr_D2_bac;
        corr_D2_bac = corr_D2_bac./abs_cent;
        corr_D1_bac = D1_temp;
        mean_corr_D1_bac = mean(corr_D1_bac, [1 2]);
        abs_cent = pagenorm(corr_D1_bac);
        corr_D1_bac = corr_D1_bac - mean_corr_D1_bac;
        corr_D1_bac = corr_D1_bac./abs_cent;
        diff = corr_D1_bac - corr_D2_bac;
        diff = power(diff,2);
        diff = sum(diff, [1 2]);
        [first_min_bac, first_min_ind_bac] = min(diff,[],3);
        % check if the two are matched
        back_D1 = D1_temp(:,:,first_min_ind_bac);
        if back_D1 == corr_D1_temp
            % check if the current first_min_ind existed
            if ~ismember(first_min_ind,indx_1st_best)
                % store those into index variable
                indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
                indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
                simi_1st_best(i_D1)=first_min;
                simi_2nd_best(i_D1)=second_min;
            % if the element exists in the current array, check if its get
            % the highest similarity score
            else
                % obtain that similarity score
                [row_pre_min,col_pre_min] = find(indx_1st_best(:,2)==first_min_ind);
                pre_min_score = simi_1st_best(row_pre_min);
                % if the current score is larger than the previous score,
                % reset the current index and score as zero.
                if first_min >= pre_min_score
                   % store those into index variable
                   indx_1st_best(i_D1,:)=0;
                   indx_2nd_best(i_D1,:)=0;
                   simi_1st_best(i_D1)=0;
                   simi_2nd_best(i_D1)=0;
                % if the current is smaller than the previosu score, reset
                % the previous index and score as zero.
                else
                   indx_1st_best(row_pre_min,:)=0;
                   indx_2nd_best(row_pre_min,:)=0;
                   simi_1st_best(row_pre_min)=0;
                   simi_2nd_best(row_pre_min)=0;
                   indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
                   indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
                   simi_1st_best(i_D1)=first_min;
                   simi_2nd_best(i_D1)=second_min;
                end
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

    % if the input is chi-square, conduct chi-square calculation
    elseif strmatch(similarity_type, "Chi-Square")
        % forward matching
        % grab out corresponding D1
        corr_D1 = D1_temp(i_D1,:);
        diff = D2_temp-corr_D1;
        diff = power(diff,2);
        summ = D2_temp+corr_D1;
        out = diff./summ;
        out(find(isnan(out)))=0;
        out = sum(out, 2);
        out = 0.5*out;
        % grab out first minimum and second minimum
        [first_min, first_min_ind] = min(out,[],1);
        [second_min, second_min_ind]= min(out(out>first_min));
        % backward matching
        D2_bac = D2_temp(first_min_ind,:);
        diff = D1_temp-D2_bac;
        diff = power(diff,2);
        summ = D1_temp+D2_bac;
        out = diff./summ;
        out(find(isnan(out)))=0;
        out = sum(out,2);
        out = 0.5*out;
        [first_min_bac, first_min_ind_bac] = min(out,[],1);
        % check if the two are matched
        D1_bac = D1_temp(first_min_ind_bac,:);
        if D1_bac == corr_D1
           % check if the current first_min_ind existed
           if ~ismember(first_min_ind,indx_1st_best)
               % store those into index variable
               indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
               indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
               simi_1st_best(i_D1)=double(first_min);
               simi_2nd_best(i_D1)=double(second_min);
           else
               % obtain that similarity score
                [row_pre_min,col_pre_min] = find(indx_1st_best(:,2)==first_min_ind);
                pre_min_score = simi_1st_best(row_pre_min);
                % if the current score is larger than the previous score,
                % reset the current index and score as zero.
                if first_min >= pre_min_score
                   % store those into index variable
                   indx_1st_best(i_D1,:)=0;
                   indx_2nd_best(i_D1,:)=0;
                   simi_1st_best(i_D1)=0;
                   simi_2nd_best(i_D1)=0;
                % if the current is smaller than the previosu score, reset
                % the previous index and score as zero.
                else
                   indx_1st_best(row_pre_min,:)=0;
                   indx_2nd_best(row_pre_min,:)=0;
                   simi_1st_best(row_pre_min)=0;
                   simi_2nd_best(row_pre_min)=0;
                   indx_1st_best(i_D1,:)=[i_D1, first_min_ind];
                   indx_2nd_best(i_D1,:)=[i_D1, second_min_ind];
                   simi_1st_best(i_D1)=first_min;
                   simi_2nd_best(i_D1)=second_min;
                end   
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

    % output error message if the analysis method is unfound.
    else
        error("Unknown analysis has been input. Please type SSD, NCC, or Chi-Square for similarity_type");
    end

end

% filter out zero values
indx_1st_best(~any(simi_1st_best,2),:)=[];
indx_2nd_best(~any(simi_2nd_best,2),:)=[];
simi_1st_best(~any(simi_1st_best,2),:)=[];
simi_2nd_best(~any(simi_2nd_best,2),:)=[];

end