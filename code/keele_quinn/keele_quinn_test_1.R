#   Testing the Stan implementation of the Keele and Quinn (2017) mixture model
#   Juraj Medzihorsky
#   2022-07-02

library(rstan)
library(parallel)
options(mc.cores=3, stringsAsFactors=F)

#   'naive' estimates
nd <- data.frame(d=c(0,0,1,1), 
                 y=c(0,1,0,1), 
                 w=c(164,163,3,18))

summary(lm(y~1+d, data=nd, weights=w))





test0 <- stanc('keele_quinn_2.stan')


mod0 <- stan_model('keele_quinn_2.stan')

#   data from the KQ paper
#   order 
#       (d=0, y=0)
#       (d=0, y=1)
#       (d=1, y=0)
#       (d=1, y=1)
#   a prior is for theta, this is Jeffrey's
#   b and c priors are beta(b_i, c_i) for psi
dl <- list('n'=c(164,163,3,18), 
           'a'=rep(0.25, 4), 
           'b'=rep(0.5, 4), 
           'c'=rep(0.5, 4))

pos <- sampling(mod0, dl, chains=3, iter=2e3, seed=42)

print(pos, pars=c('ATE_s', 'ATE_lo', 'ATE_hi'), digits=3)

#   under "uniform" priors
#   0.023 [-0.342, 0.387]
#   but I get
#   0.023 [-0.042, 0.088]


#   SCRIPT END

#   TABLE 4: Estimates
#
#   Monotonicity
#   ------------
#   Weak    0.213   -0.024  0.455
#   Medium  0.238    0.005  0.472
#   Strong  0.257    0.025  0.489
#
#   Selection
#   ---------
#   Weak    0.163   -0.107  0.436
#   Medium -0.025   -0.304  0.248
#   Strong -0.165   -0.426  0.082 

tab7 <- read.csv('Table_7.csv')

ii <- 15
dl <- list('n'=c(164,163,3,18), 
           'a'=rep(0.25, 4), 
           'b'=as.numeric(tab7[ii, paste0('b', c('00','01','10','11'))]), 
           'c'=as.numeric(tab7[ii, paste0('c', c('00','01','10','11'))]))

pos <- sampling(mod0, dl, chains=3, iter=2e3, seed=1235)
print(pos, pars=c('ATE_s'), digits=3)

#      monotonicity selection   got     should
#
#   7          weak      weak   0.045   0.355
#   8        medium      weak   0.063   0.379
#   9        strong      weak   0.157   0.398
#
#   10         weak    medium   0.041   0.166
#   11       medium    medium   0.059   0.190
#   12       strong    medium   0.152   0.209
#
#   13         weak    strong   0.036   0.026
#   14       medium    strong   0.055   0.049
#   15       strong    strong   0.148   0.068

#   DOES NOT REPLICATE
