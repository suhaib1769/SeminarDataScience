# download package for lme 
install.packages("nlme")

# load chicken data
library(nlme)
data(ChickWeight)
ChickWeight$Chick <- as.numeric(ChickWeight$Chick)

# Case 1 - Random effect
# fixed and random intercept model using lme
m0_lme <- lme(weight ~ 1, data=ChickWeight, random = ~ 1 | Chick, method = "ML")
summary(m0_lme)

v <- VarCorr(m0_lme)
tau <- as.numeric(v["(Intercept)", "StdDev"])
sigma <- as.numeric(attr(v, "sc")["Residual", "StdDev"])
x <- tau / (tau + sigma)
x

# fixed and random intercept model using rethinking
library(rethinking)
m0_stan <- map2stan(
  alist(
    weight ~ dnorm(mu, sigma),
    mu <- a + a[Chick],
    # Adaptive prior
    a[Chick] ~ dnorm(0, sigma_chick),
    # hyper prior
    sigma_chick ~ dcauchy(0, 50),
    # fixed prior
    a ~ dnorm(0, 50),
    sigma ~ dcauchy(0, 2)
  ), data=ChickWeight, iter = 10000, chains = 4, cores = 4, 
  log_lik = TRUE, control = list(adapt_delta = 0.99)
)
precis(m0_stan, prob = 0.95, depth=2)

# Case 2 - Fixed effect
m1_lme <- lme(weight ~ Time, data=ChickWeight, random = ~ 1 | Chick, method = "ML")
summary(m1_lme)

# fixed and random intercept model using rethinking
library(rethinking)
m1_stan <- map2stan(
    alist(
        # likelihood
        weight ~ dnorm(mu, sigma),
        # linear model
        mu <- a + a_chick[Chick] + b*Time,
        # Adaptive prior
        a_chick[Chick] ~ dnorm(0, sigma_chick),
        # hyper prior
        sigma_chick ~ dcauchy(0, 50),
        # fixed prior
        a ~ dnorm(10, 50),
        b ~ dnorm(20, 10),
        sigma ~ dcauchy(0, 10)
    ), data=ChickWeight, iter = 10000, chains = 4, cores = 4,
    log_lik = TRUE, control = list(adapt_delta = 0.99)
)
precis(m1_stan, prob = 0.95, depth=1)

# Case 3 - Include diet as fixed effect
ChickWeight$DietN <- as.numeric(ChickWeight$Diet)
m2_lme <- lme(weight ~ Time + Diet, data=ChickWeight, 
    random = ~ 1 | Chick, method = "ML")
summary(m2_lme)

# fixed and random intercept model using rethinking
library(rethinking)
m2_stan <- map2stan(
    alist(
        # likelihood
        weight ~ dnorm(mu, sigma),
        # linear model
        mu <- a_chick[Chick] + b*Time + c_diet[DietN],
        # Adaptive prior
        a_chick[Chick] ~ dnorm(0, sigma_chick),
        # hyper prior
        sigma_chick ~ dcauchy(0, 50),
        # fixed prior
        b ~ dnorm(20, 10),
        c_diet[DietN] ~ dnorm(10, 50),
        sigma ~ dcauchy(0, 10)
    ), data=ChickWeight, iter = 10000, chains = 4, cores = 4,
    log_lik = TRUE, control = list(adapt_delta = 0.99)
)
precis(m2_stan, prob = 0.95, depth=3, pars = c("b", "c_diet"))

# extend model random slope for time
m3_lme <- lme(weight ~ Time + Diet, data=ChickWeight, 
    random = ~ Time | Chick, method = "ML")
anova(m0_lme, m1_lme, m2_lme, m3_lme)

# fixed and random intercept model using rethinking
library(rethinking)
m3_stan <- map2stan(
    alist(
        # likelihood
        weight ~ dnorm(mu, sigma),
        # linear model
        mu <- a_chick[Chick] + (b+b[Chick]*Time) + c_diet[DietN],
        # Adaptive prior
        a_chick[Chick] ~ dnorm(0, sigma_chick),
        b[Chick] ~ dnorm(0, sigma_b),
        # hyper prior
        sigma_chick ~ dcauchy(0, 50),
        sigma_b ~ dcauchy(0, 50),
        # fixed prior
        b ~ dnorm(20, 10),
        c_diet[DietN] ~ dnorm(10, 50),
        sigma ~ dcauchy(0, 10)
    ), data=ChickWeight, iter = 10000, chains = 4, cores = 4,
    log_lik = TRUE, control = list(adapt_delta = 0.99)
)