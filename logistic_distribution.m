function [ Fx ] = logistic_distribution(mu,x)

fu= @(u) exp(u-mu)/((1+exp(u-mu)).^2);

F1= integral(fu,0,1,'ArrayValued',true);
test=integral(fu,0,x, 'ArrayValued',true);
Fx= test/F1;
