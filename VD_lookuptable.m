function [ p2,V ] = VD_lookuptable(T,D,alpha,beta,mu,rho)

VD=[];
VD(T-D)=D; %store the cost function at time T-D into the table
p=0; % store the temp price
p1=[];
E1=1-beta; %E[1]
E0=alpha; %E[0]
V_temp_1=[]; %store the temp cost function with s=1
V_temp_0=[]; %store the temp cost function with s=0
V_temp_0(T-D+1)=0;V_temp_1(T-D+1)=0;VD(T-D+1)=0;p1(T-D)=0;
for i=1:T-D-1
    for j=1:i
        V_temp_1(T-D-j+1)=(D+i+1-j)+E1*normal_distribution(mu,p/D)*p+rho*((1-E1)*V_temp_0(T-D-j+2)+E1*(1-normal_distribution(mu,p/D))*V_temp_1(T-D-j+2)+E1*normal_distribution(mu,p/D)*VD(T-D-j+2));
        V_temp_0(T-D-j+1)=(D+i+1-j)+E0*normal_distribution(mu,p/D)*p+rho*((1-E0)*V_temp_0(T-D-j+2)+E0*(1-normal_distribution(mu,p/D))*V_temp_1(T-D-j+2)+E0*normal_distribution(mu,p/D)*VD(T-D-j+2));
        f=rho*(V_temp_1(T-D-j+1)-VD(T-D-j+1))/D;
        p=binary_search(f,mu,D);
    end
%     f
    p1(T-D-i)=p;
    VD(T-D-i)=D+E1*normal_distribution(mu,p/D)*p+rho*((1-E1)*V_temp_0(T-D-j+1)+E1*(1-normal_distribution(mu,p/D))*V_temp_1(T-D-j+1)+E1*normal_distribution(mu,p/D)*VD(T-D-j+1)); %store the cost function at time T-D-i into the table
end
p2=p1;
V=VD;