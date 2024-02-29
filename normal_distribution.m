function [ Fx ] = normal_distribution(mu,x)

fu= @(u) exp(-(u-mu).^2);

F1= integral(fu,0,1);
Fx= integral(fu,0,x)/F1;
