#----First I need to open my libraries----
library(tidyverse)   # data manipulation + ggplot2
library(grid)        # allows drawing custom graphical objects
library(png)         # reads PNG images so we can weaponize memes

#----Need to open and read a dataset to use----#

# Import cleaned dataset into R
dat <- read_csv("cleaned_covid_data.csv")


#-----Open a stupid image to use-----
# Load meme image as pixel data
img <- readPNG("memegif.png")

# Convert image into a graphical object (grob)
# so ggplot can place it INSIDE the plot
img_grob <- rasterGrob(
  img,
  
  # Make the meme large so it overwhelms data
  width = unit(1.5, "npc"),   
  height = unit(1.5, "npc"),
  
  # Smooth interpolation makes it blurry when stretched
  interpolate = TRUE
)


#----creat the ggplot----
ggplot(
  dat,
  aes(
    x = Confirmed,          # confirmed COVID cases
    y = Deaths,             # deaths
    color = Province_State, # too many colors = visual chaos
    size = Active,          # unnecessary size encoding
    shape = Province_State  # redundant aesthetic mapping
  )
) +
  
#---- adding the background----

# annotation_custom places arbitrary graphics
# across the ENTIRE plotting region
annotation_custom(
  img_grob,
  xmin = -Inf,
  xmax = Inf,
  ymin = -Inf,
  ymax = Inf
) +
  
#----Plotting data on the eye sore of a graph----

# Scatterplot of observations
geom_point(alpha = 0.9) +
  
  # Linear regression line added to every facet
  # regardless of whether it makes sense
  geom_smooth(se = TRUE, method = "lm") +
  
#----Facet into dozens of tiny unreadable panels----
facet_wrap(~ Province_State) +
  
  
#----Unbelievably terrible color scale----
# Rainbow palette destroys interpretability
scale_color_manual(values = rainbow(200)) +
  

#----Make the theme ugly----
theme(
  #Neon backgrounds
  panel.background = element_rect(fill = "hotpink"),
  plot.background  = element_rect(fill = "limegreen"),
  
  #Extremely thick grid lines
  panel.grid.major = element_line(color = "yellow", linewidth = 2),
  
  #Unreadable rotated x-axis labels
  axis.text.x = element_text(
    angle = 87,
    size = 3,
    color = "red"
  ),
  
  #Oversized and rotated y-axis labels
  axis.text.y = element_text(
    angle = 123,
    size = 20,
    color = "blue"
  ),
  
  #Massive title
  plot.title = element_text(
    size = 50,
    face = "bold",
    color = "purple"
  )
) +
  
#----Labels that are dumb
labs(
  title = "MY SEMESTER",
  x = "Unga bunga",
  y = "Mcdonald Snack Wraps are back for a Limited Time Only",
  color = "States Maybe?",
  size = "Money I want"
)