function [ V ] = iterative_costM(A1,t,N,s,j,T,D,alpha,beta,mu,rho)

V_temp=0;
p=0;
E1=1-beta; %E[1]
E0=alpha; %E[0]

k=T-max(D)-t;
A=A1;

A(:)=A1(:)+1;
if j~=-1 && j~=0
    A(j)=D(j);
end

Am=max(A);
for i=1:N
    if A(i)==Am
        m=i;
        break
    end
end

if t==T-max(D)
   t
%    [Am, A]
   V=A(m);
   return
end

V0=iterative_costM(A,t+1,N,0,-1,T,D,alpha,beta,mu,rho);
V1=iterative_costM(A,t+1,N,1,0,T,D,alpha,beta,mu,rho);
Vm=iterative_costM(A,t+1,N,1,m,T,D,alpha,beta,mu,rho);
f=rho*(V1-Vm)/D(m);
p=binary_search(f,mu,D(m));

if s==1
    V_temp=Am+E1*normal_distribution(mu,p/D(m))*p+rho*((1-E1)*V0+E1*(1-normal_distribution(mu,p/D(m)))*V1+E1*normal_distribution(mu,p/D(m))*Vm);
else
    V_temp=Am+E0*normal_distribution(mu,p/D(m))*p+rho*((1-E0)*V0+E0*(1-normal_distribution(mu,p/D(m)))*V1+E0*normal_distribution(mu,p/D(m))*Vm);
end
V=V_temp;
t;