function [ Vt,pt ] = compute_priceM_logi(A1,Am1,t,N,T,DM,D,alpha,beta,mu,rho)

V_temp0=[];
V_temp1=[];
p=0;
E1=1-beta; %E[1]
E0=alpha; %E[0]

M=[];
k=T-DM-t;
A=[];

while k>=1
    for i=1:N
       A(i,t+k)=A1(i)+k;
       M(i)=0;
    end
    for j=1:k+1
        Am=max(A(:,t+k));
        for i=1:N
            if A(i,t+k)==Am
                m=i;
                break
            end
        end
        M(m)=j;
        if k==T-DM-t
            p=0;
            V_temp0(j,t+k)=Am;
            V_temp1(j,t+k)=Am;
        else
            f=rho*(V_temp1(j,t+k+1)-V_temp1(j+1,t+k+1))/D;
            p=binary_search(f,mu,D);
            V_temp1(j,t+k)=Am+E1*logistic_distribution(mu,p/D)*p+rho*((1-E1)*V_temp0(j,t+k+1)+E1*(1-logistic_distribution(mu,p/D))*V_temp1(j,t+k+1)+E1*logistic_distribution(mu,p/D)*V_temp1(j+1,t+k+1));
            V_temp0(j,t+k)=Am+E0*logistic_distribution(mu,p/D)*p+rho*((1-E0)*V_temp0(j,t+k+1)+E0*(1-logistic_distribution(mu,p/D))*V_temp1(j,t+k+1)+E0*logistic_distribution(mu,p/D)*V_temp1(j+1,t+k+1));
        end
        
        for i=1:N
           if i==m
               A(i,t+k)=D+(k-j+1)/2;
           else
               if A(i,t+k)<D+k-M(i)-1
                   A(i,t+k)=A(i,t+k)+2;
               elseif A(i,t+k)==D+k-M(i)-1
                   A(i,t+k)=A(i,t+k)+1;
               end
           end
        end
    end
    k=k-1;
end
[t,V_temp1(1,t+1),V_temp1(2,t+1)];
f=rho*(V_temp1(1,t+1)-V_temp1(2,t+1))/D;
[t,f];
p=binary_search(f,mu,D);
pt=p;
Vt=Am1+E1*logistic_distribution(mu,p/D)*p+rho*((1-E1)*V_temp0(1,t+1)+E1*(1-logistic_distribution(mu,p/D))*V_temp1(1,t+1)+E1*logistic_distribution(mu,p/D)*V_temp1(2,t+1));