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




plot_dat <- tidy_dat %>%
  filter(Dilution == 0.1) %>%
  group_by(Substrate, Habitat, Hour) %>%
  summarise(
    mean_absorbance = mean(Absorbance, na.rm = TRUE),
    .groups = "drop"
  )

p1 <- ggplot(plot_dat, aes(x = Hour, y = mean_absorbance, color = Habitat)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 1.5) +
  facet_wrap(~ Substrate) +
  labs(
    x = "Time",
    y = "Mean absorbance",
    color = "Habitat"
  ) +
  theme_bw()

p1

ggsave(
  filename = "substrate_plot.png",
  plot = p1,
  width = 16,
  height = 10
)




anim_dat <- tidy_dat %>%
  filter(Substrate == "Itaconic Acid") %>%
  group_by(`Sample ID`, Dilution, Hour) %>%
  summarise(
    mean_absorbance = mean(Absorbance, na.rm = TRUE),
    .groups = "drop"
  )

p2 <- ggplot(
  anim_dat,
  aes(
    x = Hour,
    y = mean_absorbance,
    color = `Sample ID`,
    group = `Sample ID`
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  facet_wrap(~ Dilution, nrow = 1) +
  labs(
    x = "Time",
    y = "Mean_absorbance",
    title = "Hour: {closest_state}"
  ) +
  theme_bw() +
  transition_states(Hour, transition_length = 2, state_length = 1)

animate(p2, width = 700, height = 700, fps = 2)
anim_save("itaconic_acid_animation.gif", animation = last_animation())



full_plot_dat <- tidy_dat %>%
  filter(Dilution == 0.1) %>%
  group_by(Substrate, `Sample ID`, Hour) %>%
  summarise(
    mean_absorbance = mean(Absorbance, na.rm = TRUE),
    .groups = "drop"
  )

p_full <- ggplot(
  full_plot_dat,
  aes(
    x = Hour,
    y = mean_absorbance,
    color = `Sample ID`,
    group = `Sample ID`
  )
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  facet_wrap(~ Substrate) +
  labs(
    x = "Time",
    y = "Mean_absorbance",
    color = "Sample ID"
  ) +
  theme_bw()

p_full

ggsave(
  filename = "full_substrate_plot.png",
  plot = p_full,
  width = 16,
  height = 10
)