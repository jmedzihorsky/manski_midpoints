#   replicating Keele and Quinn 2017
#   Juraj Medzihorsky
#   2022-07-02

library(MCMCpack) # for rdirichlet

#   load the function from library(SimpleTable)
source('SimpleTable_analysis.R')


#   the data
nd <- data.frame(d=c(0,0,1,1), 
                 y=c(0,1,0,1), 
                 w=c(164,163,3,18))

#   all order (d,y) 0,0 - 0,1 - 1,0 - 1,1
out <- 
    analyze2x2(164, 163, 3, 18,         #   data
               0.25, 0.25, 0.25, 0.25,  #   a for theta~dirichlet(a)
               1, 1, 1, 1,              #   b for psi ~ beta(b, c)
               1, 1, 1, 1,              #   c for psi ~ beta(b, c)
               nsamp=5e4)

moo <- function(x) c(mean(x), quantile(x, probs=c(0.025, 0.975)))

round(moo(out$ATE.sens), 3)

#   KQ: under "uniform" priors
#   0.023 [-0.342, 0.387]
#   more or less ...

round(moo(out$psi00), 3)
round(moo(out$psi01), 3)
round(moo(out$psi10), 3)
round(moo(out$psi11), 3)


