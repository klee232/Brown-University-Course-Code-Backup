# library setup
install.packages("ggplot2")
library(ggplot2)
library(dplyr)

# read csv file 
hospital <- read.csv("hospital.csv")

# conduct exploratory data analysis (eda)  to describe the relevant information (variables) 
# collected in this study

# overall observation for both insurance company
overall_group_data <- hospital %>% group_by(company)

# Patient Characteristics:

# Age Analysis (By t test, it can be stated that the age distribution between the two insurance company are the same)
# In terms of the length of staying in the hospital, age can serve as a critical factor
# of the length of how long the patient is going to stay. To make sure the two insurance
# company have similar data distribution of age, we can perform eda on age distribution
# statistical information of age of two groups (insurance company)
mean_group_age <- overall_group_data %>% summarise(mean_ls = mean(age,na.rm=TRUE))
std_group_age <- overall_group_data %>% summarise(std_ls = sd(age,na.rm=TRUE))
max_group_age <- overall_group_data %>% summarise(max_ls = max(age,na.rm=TRUE))
min_group_age <- overall_group_data %>% summarise(min_ls = min(age,na.rm=TRUE))
# generate boxplot for age distribution of two groups (insurance company)
ggplot(data=overall_group_data,aes(x=company,y=age))+geom_boxplot()
# conduct hypothesis testing
test_data <- data.frame(hospital$age,hospital$company)
t.test(hospital$age~hospital$company,data=overall_group_data,var.eqaul=F)

# Gender Analysis
# It might not be obvious but gender might be another factor that have relation to
# the length of staying in the hospital
# To test it out, the length of staying for each gender is tested and examined if the 
# length of staying in each gender are statisticallly different from each other
group_gender_data <- hospital %>% group_by(sex)
# obtain the statistical information from the grouped gender data
mean_group_gender_type <- group_gender_data %>% summarise(mean_gen_ls=mean(los,na.rm=TRUE))
std_group_gender_type <- group_gender_data %>% summarise(std_gen_ls=sd(los,na.rm=TRUE))
max_group_gender_type <- group_gender_data %>% summarise(max_gen_ls = max(los,na.rm=TRUE))
min_group_gender_type <- group_gender_data %>% summarise(min_gen_ls = min(los,na.rm=TRUE))
# conduct the t test
group_gender_data_male <- group_gender_data %>% filter(sex=="boy")
group_gender_data_female <- group_gender_data %>% filter(sex=="girl")
los_male <- group_gender_data_male$los
los_female <- group_gender_data_female$los
t.test(los_male,los_female)
group1_data <- overall_group_data %>% filter(company=="Insurer A")
group2_data <- overall_group_data %>% filter(company=="Insurer B")
group1_gender <- group1_data$sex
group2_gender <- group2_data$sex
# generate histogram plot for gender distribution of two groups (insurance company)
ggplot(data.frame(group1_gender), aes(x=group1_gender))+geom_bar()
ggplot(data.frame(group2_gender), aes(x=group2_gender))+geom_bar()

# Race Analysis
# It might not be relevant, but races might have some influences on the length of 
# staying.
group1_race <- group1_data$race
group2_race <- group2_data$race
# generate histogram plot for gender distribution of two groups (insurance company)
ggplot(data.frame(group1_race), aes(x=group1_race))+geom_bar()
ggplot(data.frame(group2_race), aes(x=group2_race))+geom_bar()


# Hospital Characteristics:
# Bed Number Analysis
# It might be relevant to the length of stay for patients 
group1_beds <- group1_data$beds
group2_beds <- group2_data$beds
# statistical information for the number of beds for each insurance company hospital
mean_group1_beds <- mean(group1_beds,na.rm=TRUE)
mean_group2_beds <- mean(group2_beds,na.rm=TRUE)
std_group1_beds <- sd(group1_beds)
std_group2_beds <- sd(group2_beds)
# perform two sample t test 
t.test(beds~company, data=hospital,var.equal=F)

# Type Analysis
# It might be relevant to the length of stay for patients in terms of it's either 
# private or public
group1_type <- group1_data$type
group2_type <- group2_data$type
# generate histogram plot for bed distribution of two groups (insurance company)
ggplot(data.frame(group1_type), aes(x=group1_type))+geom_bar()
ggplot(data.frame(group2_type), aes(x=group2_type))+geom_bar()
# test if the hospital type affect the length of staying
group_hosp_type_data <- hospital %>% group_by(type)
mean_group_data_type <- group_hosp_type_data %>% summarise(mean_typ_ls=mean(los,na.rm=TRUE))
std_group_data_type <- group_hosp_type_data %>% summarise(std_typ_ls=sd(los,na.rm=TRUE))
max_group_data_type <- group_hosp_type_data %>% summarise(max_typ_ls = max(los,na.rm=TRUE))
min_group_data_type <- group_hosp_type_data %>% summarise(min_typ_ls = min(los,na.rm=TRUE))
ggplot(data=group_hosp_type_data, aes(x=type,y=los))+geom_boxplot()
t.test(los~type, data=hospital,var.equal=F)


# Perform overall statistical analysis on length of staying
# statistical information for dataset 
mean_group_data <- overall_group_data %>% summarise(mean_ls = mean(los,na.rm=TRUE))
std_group_data <- overall_group_data %>% summarise(std_ls = sd(los,na.rm=TRUE))
max_group_data <- overall_group_data %>% summarise(max_ls = max(los,na.rm=TRUE))
min_group_data <- overall_group_data %>% summarise(min_ls = min(los,na.rm=TRUE))
ggplot(data=overall_group_data, aes(x=company,y=los))+geom_boxplot()
t.test(los~company, data=hospital,var.equal=F)
