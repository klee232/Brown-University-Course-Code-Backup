# load packages
install.packages("gapminder")
library(gapminder)
# view some contents of the data
str(gapminder)

# install package dplyr
install.packages("dplyr")

# Question 1: Find out the number of  countries
n_distinct(gapminder$country)

# Question 2: Find out the European country that posses the lowest gdp in the year of 1997
# Logic: 1. Filter out the countries that are in Europe
#        2. Filter out the data that are in year 1997
#        3. Arrange the data based on the ranking of gdpPercap
gapminder %>% filter(continent=="Europe") %>% filter(year==1997) %>% arrange(gdpPercap)

# Questions 3: Find out the Average Life Expanse in 1980s accross each continent
# Logic: 1. Group the data by continent
#        2. Filter out the data that are in the interval from year of 1980 to 1989
#        3. Select out only lifeExp data
#        4. Use summarise function to display the mean of the data 
gapminder %>% group_by(continent) %>% filter(year>=1980 & year<=1989) %>% select(lifeExp) %>% summarise(avg = mean(lifeExp,na.rm=TRUE))

# Question 4: Find out the countries over all years posses the highest total GDP
# Logic: 1. Select out the data: country, year, gdpPercap, and pop
#        2. Group the data based on country
#        3. Calculate the outcomes based on the formula: total_gdp = sum(gdpPercap*pop)
#        4. Display the outcome in descending ourder based on total_gdp
gapminder %>% select(country,year,gdpPercap,pop) %>% group_by(country) %>% summarise(total_gdp = sum(gdpPercap*pop), .groups='drop') %>% arrange(desc(total_gdp))

# Question 5: Find out the countries in which year posses a life expectancies of at leat 80 years
# Logic: 1. Select out only data: country, year, and lifeExp
#        2. Filter out only data that posses lifeExp that exceed 80
#        3. Print out the entire data table
out<-gapminder %>% select(country,year,lifeExp) %>% filter(lifeExp>=80)
print(out,n=nrow(out))

# Question 6: Find out the three countries with the most consistent population
# Logic: 1. Select out only data: country, pop
#        2. Group the data based on country
#        3. Calculate the standard deviation of each country
#        4. Arrange the outcomes based on the value of standard deviation in ascending order
gapminder %>% select(country,pop) %>% group_by(country) %>% summarise(std_pop = sd(pop), .groups='drop') %>% arrange(std_pop)

# Question 7: Find out which continent and year has the highest average population across all countries
# Logic: 1. Select out only data: continent, year, and pop
#        2. Group the data based on continent and year
#        3. Calculate the average population for each group
#        4. Filter out the data that is not Asia
#        5. Arrange the outcomes based on the average population in descending order
gapminder %>% select(continent,year,pop) %>% group_by(continent,year) %>% summarise(avg_pop = mean(pop), .groups='drop') %>% filter(continent!='Asia') %>% arrange(desc(avg_pop))

# Question 8
install.packages("nycflights13")
library(nycflights13)
# Original Code from Manual
hourly_delay <- filter( 
  summarise( 
    group_by( 
      filter( 
        flights,  
        !is.na(dep_delay) 
      ), 
      month, day, year, hour 
    ), 
    delay=mean(dep_delay), 
    n=n() 
  ), 
  n>10 
) 
# Modified Piping Version
# Logic: 1. Filter out flights that doesn't have NA for for dep_deply
#        2. Group the data based on: month, day, year, and then hour
#        3. Calculate the mena of dep_deply for each group
#        4. Filter out data that has n>10
hourly_delay2 <- filter(flights,!is.na(dep_delay)) %>% group_by(month,day,year, hour) %>% summarise(dealy=mean(dep_delay),n=n()) %>% filter(n>10)