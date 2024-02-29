function [ output_args ] = Fig6multi_path_app( input_args )
%%% Created: 2021-7-13
%%% Last modified: 2021-7-12
%%% Author: Hongbo Li

A=[]; % AoI set
T=30; % time horizon
N=3;
D=[2,3,5];  % average travle delay
alpha=0.8; beta=0.6; % MDP transition probabilities
s=[]; % driver arrival
Es=[]; % expected driver arrival probabilty
apt=[]; % driver accept the price
Vt=0; % cost function
pt=[]; % price
Fx=0; mu=0.6; % CDF value of cost rate pt/D, expectation is mu in (0,1)
rho=0.85; % discount factor

VD=[]; % Vt(D,1) table


    %% multi-path online pricing scenario

A0=[2,4,3]; %initial age at time 0
Am=[];
m=0;
for i=1:N
    A(i,1)=A0(i)+D(i);
end

for t=1:T-max(D)
    t
    Am(t)=max(A(:,t));
    for j=1:N
        if A(j,t)==Am(t)
            m=j;
            break
        end
    end
    if t==1
        Es(t)=alpha;
        [V1,a]=compute_priceM(A(:,t),Am(t),0,N,T,max(D),D(m),alpha,beta,mu,rho);
        pt(m,t)=a;
        Fx=normal_distribution(mu,pt(m,t)/D(m));
        s(t)=randsrc(1,1,[0,1;1-Es(t),Es(t)]);
        apt(t)=randsrc(1,1,[0,1;1-Fx,Fx]);
        if s(t)*apt(t)==1
            A(:,t+1)=A(:,t)+1;
            A(m,t+1)=D(m);
        else
            A(:,t+1)=A(:,t)+1;
        end
        
    else
        Es(t)=s(t-1)*(1-beta)+(1-s(t-1))*alpha;
        [V1, a]=compute_priceM(A(:,t),Am(t),t-1,N,T,max(D),D(m),alpha,beta,mu,rho);
        pt(m,t)=a;
        Fx=normal_distribution(mu,pt(m,t)/D(m));
        s(t)=randsrc(1,1,[0,1;1-Es(t),Es(t)]);
        apt(t)=randsrc(1,1,[0,1;1-Fx,Fx]);
        if s(t)*apt(t)==1
            A(:,t+1)=A(:,t)+1;
            A(m,t+1)=D(m);
        else
            A(:,t+1)=A(:,t)+1;
        end
    end
end
Am(T-max(D)+1)=max(A(:,T-max(D)+1));
pt(:,T-max(D)+1)=0;



x=0:1:T-max(D);
t=0:1:T-max(D);
% y=[A(1,:);A(2,:);A(3,:);Am];
y=[A(1,:);A(2,:);A(3,:)];
py=[pt(1,:);pt(2,:);pt(3,:)];
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.23]);
% for i=1:N
%     plot(x,A(i,:),'-s','LineWidth',1.5);hold on;
% end
p=plot(x,y,'-s','LineWidth',1.5);hold on
% plot(x,Am,'-s','LineWidth',3,'Color','r');hold on;
xlabel('time slot t');
ylabel('Actual AoI A_i(t+D_i)')
% legend('Path 1','Path 2','Path 3','Maximum AoI')
legend(p(1:3),'Path 1','Path 2','Path 3')
ah=axes('position',get(gca,'position'),'visible','off');
% legend(ah,p(4),'Maximum foreseen AoI')

figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.23]);
p2=plot(t,pt,'-*','LineWidth',1.5);hold on;
xlabel('time slot t');
ylabel('Online pricing p_i(A_i(t+D_i))')
legend(p2(1:3),'Path 1','Path 2','Path 3')
 %
    