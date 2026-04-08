library(tidyverse)

relig <- read_csv("Utah_Religions_by_County.csv")

glimpse(relig)

tidy_relig <- relig %>%
  pivot_longer(
    cols = -c(County, Pop_2010),
    names_to = "religion",
    values_to = "proportion"
  )

# QUESTION 1

ggplot(tidy_relig, aes(x = Pop_2010, y = proportion)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ religion, scales = "free_y") +
  labs(
    title = "Population vs Religion Proportion by County",
    x = "Population (2010)",
    y = "Proportion"
  )

tidy_relig %>%
  group_by(religion) %>%
  summarise(correlation = cor(Pop_2010, proportion))


# QUESTION 2:

nonrelig <- relig %>%
  select(County, `Non-Religious`)

relig_vs_nonrelig <- tidy_relig %>%
  filter(religion != "Non-Religious") %>%
  left_join(nonrelig, by = "County")

ggplot(relig_vs_nonrelig, aes(x = `Non-Religious`, y = proportion)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ religion, scales = "free_y") +
  labs(
    title = "Religion vs Non-Religious Proportion",
    x = "Non-Religious Proportion",
    y = "Religion Proportion"
  )

relig_vs_nonrelig %>%
  group_by(religion) %>%
  summarise(correlation = cor(`Non-Religious`, proportion))