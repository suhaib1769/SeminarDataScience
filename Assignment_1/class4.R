# Part 1
data(mtcars)
mtcars$am <- factor(mtcars$am, levels=c(0:1), labels=c("automatic", "manual"))
boxplot(mpg ~ am, data=mtcars)

am <- rbinom(32, 1, 0.5)
mpg <- rnorm(32, mean=30+am*5, sd=5)
am <- factor(am, levels=c(0:1), labels=c("automatic", "manual"))
d <- data.frame(mpg, am)
d

# model verification with lm
m1 <- lm(mpg ~ am, data=d)
m0 <- lm(mpg ~ 1, data=d)
(anova(m0, m1))

# model verification with map2stan
library(rethinking)
m0_stan <- map2stan(
  alist(
    mpg ~ dnorm(mu, sigma),
    mu <- a,
    a ~ dnorm(25, 10),
    sigma ~ dcauchy(0, 2)
  ), data=mtcars, iter = 10000, chains = 4, cores = 4
)
m1_stan <- map2stan(
    alist(
        mpg ~ dnorm(mu, sigma),
        mu <- a + b*am,
        a ~ dnorm(25, 10),
        b ~ dnorm(0, 5),
        sigma ~ dcauchy(0, 2)
    ), data=mtcars, iter = 10000, chains = 4, cores = 4
)

precis(m0_stan)
precis(m1_stan)
compare(m0_stan, m1_stan) 

# compare(list(m0_stan = m0_stan, m1_stan = m1_stan), labels = c("Model 0", "Model 1"))

# Part 2
course <- rbinom(100,1,0.5)
success_rate <- exp(1+0.1*course)
success <- rpois(100, success_rate)
d_2 <- data.frame(success, course)
hist(d$success)

# fit model with glm
m0_2 <- glm(success ~ 1, data=d, family=poisson)
m1_2 <- glm(success ~ course, data=d, family=poisson)
summary(m0)
summary(m1)
anova(m0,m1)
anova(m0, m1, test="Chisq")

# fit model with bayesian
library(rethinking)
m0_stan_2 <- map2stan(
  alist(
    success ~ dpois(lambda),
    log(lambda) <- a,
    a ~ dexp(1)
  ), data=d, iter = 10000, chains = 4, cores = 4
)
m1_stan_2 <- map2stan(
  alist(
    success ~ dpois(lambda),
    log(lambda) <- a + b*course,
    a ~ dexp(1),
    b ~ dexp(0.1)
  ), data=d, iter = 10000, chains = 4, cores = 4
)
precis(m0_stan_2)
precis(m1_stan_2)

compare(m0_stan_2, m1_stan_2)

