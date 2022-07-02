// Stan implementation of the Keele and Quinn (2017) mixture model 
// Juraj Medzihorsky
// 2022-07-02 
//
// n order (d,y): 0,0 - 0,1 - 1,0 - 1,1
data {
    vector[4] n; // order!
    vector[4] a; // for theta ~ dirichlet
    vector[4] b;
    vector[4] c;
}
parameters {
    simplex[4] theta;
    vector<lower=0.0, upper=1.0>[4] psi;
}
model {
    vector[4] log_theta = log(theta);
    vector[4] log_self_psi = log(psi) + log1m(psi);
    theta ~ dirichlet(a);
    for (i in 1:4)
        psi[i] ~ beta(b[i], c[i]);
    target += sum(n .* (log_theta + log_self_psi));
}
generated quantities {
    //  theta and psi order: 0,0 - 0,1 - 1,0 - 1,1
    vector[4] log_theta = log(theta);
    vector[4] log_psi = log(psi);
    vector[4] log1m_psi = log1m(psi);
    real p_y0_is_0 = exp(log_theta[3]+log1m_psi[3]) + exp(log_theta[4]+log1m_psi[4]) + theta[1]; 
    real p_y0_is_1 = exp(log_theta[3]+log_psi[3])   + exp(log_theta[4]+log_psi[4])   + theta[2]; 
    real p_y1_is_0 = exp(log_theta[1]+log1m_psi[1]) + exp(log_theta[2]+log1m_psi[2]) + theta[3]; 
    real p_y1_is_1 = exp(log_theta[1]+log_psi[1])   + exp(log_theta[2]+log_psi[2])   + theta[4]; 
    real ATE_s = p_y1_is_1 - p_y0_is_1;
    real ATE_lo = -(theta[2]+theta[3]);
    real ATE_hi = +(theta[1]+theta[4]);
}


