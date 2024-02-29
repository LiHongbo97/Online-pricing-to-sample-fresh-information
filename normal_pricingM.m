function [ output_args ] = normal_pricingM( input_args )
%%% Created: 2022-6-16
%%% Last modified: 2022-6-16
%%% Author: Hongbo Li

A=[]; % AoI set
T=30; % time horizon
t=1;  % initial time
D=5;  % average travle delay
alpha=0.8; beta=0.6; % MDP transition probabilities
s=[]; % driver arrival
Es=[]; % expected driver arrival probabilty
apt=[]; % driver accept the price
Vt=0; % cost function
pt=[]; % price
Fx=0; mu=0.6; % CDF value of cost rate pt/D, expectation is mu in (0,1)
rho=0.85; % discount factor

VD=[]; % Vt(D,1) table
pD=[];

% Hx=[];
% x=[];
% for i=1:100
%     x(i)=0.01*i;
%     fx=exp(-(x(i)-mu).^2);
%     Fx=normal_distribution(mu,x(i));
%     Hx(i)=x(i)+Fx/fx;
% end
% plot(x,Hx)
   %% Vt(D,1) table calculation
[pD,VD]=VD_lookuptable(T,D,alpha,beta,mu,rho);
% p1
% for i=1:T-D+1
%     x(i)=i;
% end
% plot(x,VD);hold on;
% plot(x(1:T-D),p1)

    %% Vt online pricing scenario

A0=4; %initial age at time 0
for t=1:D
    A(t)=A0+t;
end
for t=0:T-D-1
    if t==0
        Es0=alpha;
        pt0=compute_price(A(D),0,VD,T,D,alpha,beta,mu,rho);
        Fx=normal_distribution(mu,pt0/D);
        s0=randsrc(1,1,[0,1;1-Es0,Es0]);
        apt0=randsrc(1,1,[0,1;1-Fx,Fx]);
        if s0*apt0==1
            A(D+1)=D;
        else
            A(D+1)=A(D)+1;
        end
    elseif t==1
        Es(t)=s0*(1-beta)+(1-s0)*alpha;
        pt(t)=compute_price(A(1+D),1,VD,T,D,alpha,beta,mu,rho);
        Fx=normal_distribution(mu,pt(t)/D);
        s(t)=randsrc(1,1,[0,1;1-Es(t),Es(t)]);
        apt(t)=randsrc(1,1,[0,1;1-Fx,Fx]);
        if s(t)*apt(t)==1
            A(t+D+1)=D;
        else
            A(t+D+1)=A(t+D)+1;
        end
    else
        Es(t)=s(t-1)*(1-beta)+(1-s(t-1))*alpha;
        pt(t)=compute_price(A(t+D),t,VD,T,D,alpha,beta,mu,rho);
        Fx=normal_distribution(mu,pt(t)/D);
        s(t)=randsrc(1,1,[0,1;1-Es(t),Es(t)]);
        apt(t)=randsrc(1,1,[0,1;1-Fx,Fx]);
        if s(t)*apt(t)==1
            A(t+D+1)=D;
        else
            A(t+D+1)=A(t+D)+1;
        end
    end
end
for t=T-D:T
    pt(t)=0;
end
x=0:1:T;
t=0:1:T;
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.23]);
plot(x,[A0,A(1:T)],'-s','LineWidth',1.5,'Color','r');
xlabel('time slot t');
ylabel('Actual AoI A(t)')
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.23]);
plot(t,[pt0,pt],'-*','LineWidth',1.5,'Color','b');
xlabel('time slot t');
ylabel('Optimal Online Pricing p^*_t(A(t+D))')
 %
    