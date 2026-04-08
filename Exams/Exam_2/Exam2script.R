library(tidyverse)

## Read UNICEF data
unicef_raw <- read_csv("unicef-u5mr.csv")

## Make UNICEF data tidy
unicef_tidy <- unicef_raw |>
  pivot_longer(
    cols = starts_with("U5MR."),
    names_to = "Year",
    names_pattern = "U5MR\\.(\\d+)",
    values_to = "U5MR"
  ) |>
  mutate(Year = as.integer(Year))

glimpse(unicef_tidy)

## Plot each country's U5MR over time
p1 <- ggplot(unicef_tidy, aes(x = Year, y = U5MR, group = CountryName)) +
  geom_line(alpha = 0.4) +
  facet_wrap(~ Continent) +
  theme_bw()

## plot 1
ggsave("DORITY_Plot_1.png", p1, width = 12, height = 6, dpi = 300)

## Create a data frame with mean U5MR for each continent at each year
unicef_mean <- unicef_tidy |>
  group_by(Continent, Year) |>
  summarize(mean_U5MR = mean(U5MR, na.rm = TRUE), .groups = "drop")

## Plot mean U5MR for continents over time
p2 <- ggplot(unicef_mean, aes(x = Year, y = mean_U5MR, color = Continent)) +
  geom_line() +
  theme_bw()

## plot 2
ggsave("DORITY_Plot_2.png", p2, width = 12, height = 6, dpi = 300)

## Create three models of U5MR
mod1 <- lm(U5MR ~ Year, data = unicef_tidy)

mod2 <- lm(U5MR ~ Year + Continent, data = unicef_tidy)

mod3 <- lm(U5MR ~ Year * Continent, data = unicef_tidy)

## Compare model performance
model_compare <- tibble(
  model = c("mod1", "mod2", "mod3"),
  AIC = c(AIC(mod1), AIC(mod2), AIC(mod3)),
  adj_r2 = c(
    summary(mod1)$adj.r.squared,
    summary(mod2)$adj.r.squared,
    summary(mod3)$adj.r.squared
  )
)

model_compare

## Create prediction grid for all continents across years
pred_grid <- expand_grid(
  Continent = unique(unicef_tidy$Continent),
  Year = seq(
    min(unicef_tidy$Year, na.rm = TRUE),
    max(unicef_tidy$Year, na.rm = TRUE)
  )
)

pred_grid <- pred_grid |>
  mutate(
    pred_mod1 = predict(mod1, newdata = pred_grid),
    pred_mod2 = predict(mod2, newdata = pred_grid),
    pred_mod3 = predict(mod3, newdata = pred_grid)
  )

pred_long <- pred_grid |>
  pivot_longer(
    cols = starts_with("pred_mod"),
    names_to = "model",
    values_to = "pred"
  ) |>
  mutate(
    model = recode(
      model,
      pred_mod1 = "mod1",
      pred_mod2 = "mod2",
      pred_mod3 = "mod3"
    )
  )

## Plot model predictions
p3 <- ggplot(pred_long, aes(x = Year, y = pred, color = model)) +
  geom_line() +
  facet_wrap(~ Continent) +
  theme_bw()

ggsave("Model_predictions_by_continent.png",
       p3, width = 12, height = 6, dpi = 300)

## BONUS
ecuador_continent <- unicef_tidy |>
  filter(CountryName == "Ecuador") |>
  distinct(Continent) |>
  pull()

ecuador_2020 <- tibble(
  Continent = ecuador_continent,
  Year = 2020
)

ecuador_pred_mod3 <- predict(mod3, newdata = ecuador_2020)

ecuador_bonus_mod3 <- tibble(
  CountryName = "Ecuador",
  Year = 2020,
  model = "mod3",
  pred = ecuador_pred_mod3,
  reality = 13,
  diff = pred - reality,
  abs_diff = abs(pred - reality)
)

mod4 <- lm(log(U5MR) ~ poly(Year, 2) * Continent, data = unicef_tidy)

ecuador_pred_mod4_log <- predict(mod4, newdata = ecuador_2020)
ecuador_pred_mod4 <- exp(ecuador_pred_mod4_log)

ecuador_bonus_mod4 <- tibble(
  CountryName = "Ecuador",
  Year = 2020,
  model = "mod4",
  pred = ecuador_pred_mod4,
  reality = 13,
  diff = pred - reality,
  abs_diff = abs(pred - reality)
)

ecuador_compare <- bind_rows(ecuador_bonus_mod3, ecuador_bonus_mod4)

ecuador_compare
## mod4 may be closer to the real value of 13 than mod3.