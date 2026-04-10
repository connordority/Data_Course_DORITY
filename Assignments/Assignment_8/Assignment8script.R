library(tidyverse)
library(modelr)
library(broom)
mushroom <- read_csv("mushroom_growth.csv")

glimpse(mushroom)
summary(mushroom)

mushroom <- mushroom %>%
  mutate(
    Humidity = as.factor(Humidity),
    Species = as.factor(Species)
  )


ggplot(mushroom, aes(x = Temperature, y = GrowthRate)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal()

ggplot(mushroom, aes(x = Light, y = GrowthRate)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal()

ggplot(mushroom, aes(x = Nitrogen, y = GrowthRate)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal()

ggplot(mushroom, aes(x = Humidity, y = GrowthRate)) +
  geom_boxplot() +
  theme_minimal()

ggplot(mushroom, aes(x = Species, y = GrowthRate)) +
  geom_boxplot() +
  theme_minimal()


mod1 <- lm(GrowthRate ~ Temperature, data = mushroom)
mod2 <- lm(GrowthRate ~ Temperature + Light, data = mushroom)
mod3 <- lm(GrowthRate ~ Temperature + Light + Nitrogen, data = mushroom)
mod4 <- lm(GrowthRate ~ Temperature + Light + Nitrogen + Humidity + Species, data = mushroom)
mod5 <- lm(GrowthRate ~ Temperature * Light + Nitrogen + Humidity + Species, data = mushroom)


mse_mod1 <- mean(mod1$residuals^2)
mse_mod2 <- mean(mod2$residuals^2)
mse_mod3 <- mean(mod3$residuals^2)
mse_mod4 <- mean(mod4$residuals^2)
mse_mod5 <- mean(mod5$residuals^2)

mse_table <- tibble(
  Model = c("mod1", "mod2", "mod3", "mod4", "mod5"),
  MSE = c(mse_mod1, mse_mod2, mse_mod3, mse_mod4, mse_mod5)
)

mse_table

best_model <- mod4

summary(best_model)



real_preds <- mushroom %>%
  add_predictions(best_model) %>%
  mutate(PredictionType = "Real")



newdf <- tibble(
  Temperature = c(15, 20, 25, 30, 35),
  Light = c(0, 10, 20, 10, 0),
  Nitrogen = c(0, 5, 10, 5, 0),
  Humidity = factor(c("Low", "Low", "High", "High", "High"),
                    levels = levels(mushroom$Humidity)),
  Species = factor(c("P.ostreotus", "P.ostreotus", "P.ostreotus",
                     "P.ostreotus", "P.ostreotus"),
                   levels = levels(mushroom$Species))
)

hyp_preds <- newdf %>%
  mutate(
    pred = predict(best_model, newdata = newdf),
    PredictionType = "Hypothetical"
  )

hyp_preds


ggplot() +
  geom_point(data = mushroom,
             aes(x = Temperature, y = GrowthRate),
             color = "black", size = 2) +
  geom_point(data = real_preds,
             aes(x = Temperature, y = pred, color = PredictionType),
             size = 2) +
  geom_point(data = hyp_preds,
             aes(x = Temperature, y = pred, color = PredictionType),
             size = 3) +
  theme_minimal()

mushroom %>%
  gather_residuals(mod1, mod2, mod3, mod4, mod5) %>%
  ggplot(aes(x = model, y = resid, fill = model)) +
  geom_boxplot() +
  theme_minimal()