sample <- data.frame(age=rnorm(10,50,10))
hist(sample$age)
t.test(sample$age, mu=60, conf.level = 0.9)

library(rethinking)
da <- sample
m <-ulam(
  alist(
    age ~ dnorm(mu, sigma),
    mu ~ dnorm(42.4, 20),
    sigma ~ dunif(0.001, 10)
  ), data = da ,iter = 10000, chains = 4, cores = 4,
)
precis(m,prob=0.95)
traceplot(m)

sample2 <- data.frame(usability = rnorm(34,7.2))
library(rethinking)
da <- sample2
m0 <-ulam(
  alist(
    usability ~ dnorm(mu, sigma),
    mu ~ dnorm(5, 5),
    sigma ~ dunif(0.1, 5)
  ), data = da ,iter = 10000, chains = 4, cores = 4,
)
precis(m,prob=0.95)
traceplot(m)


