function [ pt ] = compute_price(A,t,VD,T,D,alpha,beta,mu,rho)

V_temp0=[];
V_temp1=[];
p=0;


V_temp1(T-D)=A+T-D-t;
V_temp0(T-D)=A+T-D-t;
E1=1-beta; %E[1]
E0=alpha; %E[0]
if t==T-D-1
    f=rho*(V_temp1(T-D)-VD(T-D))/D;
    p=binary_search(f,mu,D);
else
    for i=2:T-D-t
        V_temp1(T-D-i+1)=(A+T-D-i+1-t)+E1*normal_distribution(mu,p/D)*p+rho*((1-E1)*V_temp0(T-D-i+2)+E1*(1-normal_distribution(mu,p/D))*V_temp1(T-D-i+2)+E1*normal_distribution(mu,p/D)*VD(T-D-i+2));
        V_temp0(T-D-i+1)=(A+T-D-i+1-t)+E0*normal_distribution(mu,p/D)*p+rho*((1-E0)*V_temp0(T-D-i+2)+E0*(1-normal_distribution(mu,p/D))*V_temp1(T-D-i+2)+E0*normal_distribution(mu,p/D)*VD(T-D-i+2));
        f=rho*(V_temp1(T-D-i+1)-VD(T-D-i+1))/D;
        p=binary_search(f,mu,D);
    end
end
pt=p;