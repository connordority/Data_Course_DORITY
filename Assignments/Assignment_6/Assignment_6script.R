library(tidyverse)
library(gganimate)

dat <- read_csv("../../Data/BioLog_Plate_Data.csv")

tidy_dat <- dat %>%
  pivot_longer(
    cols = c(Hr_24, Hr_48, Hr_144),
    names_to = "Hour",
    values_to = "Absorbance"
  ) %>%
  mutate(
    Hour = parse_number(Hour),
    Habitat = case_when(
      `Sample ID` %in% c("Clear_Creek", "Waste_Water") ~ "water",
      `Sample ID` %in% c("Soil_1", "Soil_2") ~ "soil"
    )
  )

count(tidy_dat, `Sample ID`, Habitat)

plot_dat <- tidy_dat %>%
  filter(Dilution == 0.1)

ggplot(plot_dat, aes(x = Substrate, y = Absorbance, fill = Habitat)) +
  stat_summary(fun = mean, geom = "col", position = "dodge") +
  facet_wrap(~Hour) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

anim_dat <- tidy_dat %>%
  filter(Substrate == "Itaconic Acid") %>%
  group_by(`Sample ID`, Habitat, Dilution, Hour) %>%
  summarise(mean_absorbance = mean(Absorbance, na.rm = TRUE), .groups = "drop")

p <- ggplot(anim_dat, aes(x = factor(Dilution), y = mean_absorbance, group = `Sample ID`)) +
  geom_point(aes(shape = Habitat, size = mean_absorbance)) +
  facet_wrap(~Habitat) +
  labs(
    x = "Dilution",
    y = "Mean absorbance",
    title = "Hour: {closest_state}"
  ) +
  theme_bw() +
  transition_states(Hour)

animate(p)
anim_save("itaconic_acid_animation.gif", animation = last_animation())