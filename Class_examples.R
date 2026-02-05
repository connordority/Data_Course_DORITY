read.csv(wingspan_vs_mass.csv)
/Desktop/Data_Course_DORITY/Data
getwd
read.csv('Data/wingspan_vs_mass.csv')

Fruit = c('peach', 'apple', 'strawberry')
is.character(Fruit)

num = (1, 2, 3)
as.logical(num)
is.numeric(num)
vec = c('1', 2, T)
is.character(vec)

#2. matrix (two dim, same type of data)
matrix(c(1:6), nrow = 3, ncol = 2)
matrix(c(1:6), nrow = 3, ncol = 2, byrow = T)
matrix(c(1:6), nrow = 3, ncol = 2, byrow = F)

# 4. Data fram (two dim, different type of data, same length)
str(df)

#3 array (multiple dim, same type)
array(c(1:12), dim = c(2, 2, 3))

#5. list (mult dim, different type, differnt length)
list(df,
     num = c(1:6)
     Fruit = 'strawberry')

#6. function (store a function)
function

color = c('red', 'orange', 'blue', 'green', 'purple', 'gray', 'pink')
length(color)
as.factor(color)


# 1. create a data frame contains favorite fruit (at least 6)
# 2. add calories to the data frame
# 3. write a loop to print out name of fruit and their calories


df_1 = data.frame(fruit = c('peach', 'apple', 'blackberry'),
                  calaries = c(100, 97, 44)
                  
fruit_data <- data.frame(
  fruit = c('apple', 'peach', 'pineapple'),
  calories = c(95, 34, 65)
  
)
str(fruit_data)

fruit_data$new_col = 
  
for (i in 1:3) {
  print(fruit_data$new_col[i])

dim(mtcars)
View(mtcars)
df_car = mtcars
df_car$cccc = 333


str(df_car)
df_car$mpg
df_car$mpg > 20
df_car[df_car$mpg > 20, ]

good_cars = df_car[df_car$mpg > 20, ]
dim(good_cars)
max(good_cars)
min(good_cars)
View(good_cars)

write.csv(good_cars, file = 'good_cars.csv')

good_cars = df_car[df_car$cyl == 4, ]

View(good_cars)
View(mtcars)

## warm up 1. get the car with cyl euql to 4 (save to new obj)
good_cars = df_car[df_car$cyl == 4, ]
View(good_cars)

## 2. save both mph > 20 and cyl euql to 4 into a new obj
super_good_car = good_cars[good_cars$mpg > 20 & good_cars$cyl == 4, ]
View(super_good_car)

## 3. what are the data type of each cols?
## convert all cols to characters


# my note levvec# my note level 1 ####
## my note level 2 ####