function [ output_args ] = Fig7multi_path_err( input_args )
%%% Created: 2021-7-13
%%% Last modified: 2021-7-12
%%% Author: Hongbo Li

A=[]; % AoI set
T=13; % time horizon
alpha=0.8; beta=0.6; % MDP transition probabilities
s=[]; % driver arrival
Es=[]; % expected driver arrival probabilty
apt=[]; % driver accept the price
Vt=0; % cost function
pt=[]; % price
pt_logi=[];
Fx=0; mu=0.6; % CDF value of cost rate pt/D, expectation is mu in (0,1)
rho=0.85; % discount factor

VD=[]; % Vt(D,1) table

%% test 1
% N3=3;
% N6=7;
% N10=15;
% D=[2,4,5,1,3,4,1,1,3,4,5,2,1,3,4];  % average travle delay
% A=[3,7,5,2,4,4,2,3,4,6,6,3,1,4,6]; %perfect result
% % D=[2,3,5,1,3,4,1,1,3,4,5,2,1,3,4];  % perfect result
% % A=[3,7,5,2,3,6,5,3,4,4,5,3,4,4,6]; %perfect result
% pr_t=[];
% p_delta3=[];
% p_delta6=[];
% p_delta10=[];
% 
% Am=max(A);
% for j=1:N3
%     if A(j)==Am
%         m=j;
%         break
%     end
% end
% Tm=11;
% 
% for T=max(D)+1:Tm
%     pt(T)=compute_priceM(A(1:N3),0,N3,T,max(D),D(m),alpha,beta,mu,rho);
%     
%     V1=iterative_costM(A(1:N3),1,N3,1,0,T,D(1:N3),alpha,beta,mu,rho);
%     Vm=iterative_costM(A(1:N3),1,N3,1,m,T,D(1:N3),alpha,beta,mu,rho);
%     f=rho*(V1-Vm)/D(m);
%     pr_t(T)=binary_search(f,mu,D(m));
%     p_delta3(T)=abs(pr_t(T)-pt(T));
% end
% 
% for T=max(D)+1:Tm
%     pt(T)=compute_priceM(A(1:N6),0,N6,T,max(D),D(m),alpha,beta,mu,rho);
%     
%     V1=iterative_costM(A(1:N6),1,N6,1,0,T,D(1:N6),alpha,beta,mu,rho);
%     Vm=iterative_costM(A(1:N6),1,N6,1,m,T,D(1:N6),alpha,beta,mu,rho);
%     f=rho*(V1-Vm)/D(m);
%     pr_t(T)=binary_search(f,mu,D(m));
%     p_delta6(T)=abs(pr_t(T)-pt(T));
% end
% 
% for T=max(D)+1:Tm
%     pt(T)=compute_priceM(A(1:N10),0,N10,T,max(D),D(m),alpha,beta,mu,rho);
%     
%     V1=iterative_costM(A(1:N10),1,N10,1,0,T,D(1:N10),alpha,beta,mu,rho);
%     Vm=iterative_costM(A(1:N10),1,N10,1,m,T,D(1:N10),alpha,beta,mu,rho);
%     f=rho*(V1-Vm)/D(m);
%     pr_t(T)=binary_search(f,mu,D(m));
%     p_delta10(T)=abs(pr_t(T)-pt(T));
% end
% 
% x=max(D)+1:1:Tm;
% x1=max(D)+1:1:Tm+1;
% figure
% % plot(x,pt(max(D)+1:Tm),'-*','LineWidth',1.5);hold on;
% plot(x,p_delta3(max(D)+1:Tm),'-s','LineWidth',2,'Color','g');hold on;
% plot(x,p_delta6(max(D)+1:Tm),'-o','LineWidth',2);hold on;
% plot(x,p_delta10(max(D)+1:Tm),'-*','LineWidth',2,'Color','b');
% set(gca,'xtick',0:1:x(end));  
% set(gca,'ytick',0:0.05:1);
% set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.25]);
% xlabel('time horizon T');
% ylabel('approximation error');
% legend('N=3','N=7','N=15');
    %% multi-path online pricing scenario
    N3=3;
N6=7;
N10=15;
D=[2,4,5,1,3,4,1,1,3,4,5,2,1,3,4];  % average travle delay
A=[3,7,5,2,4,4,2,3,4,6,6,3,1,4,6]; %perfect result
% D=[2,3,5,1,3,4,1,1,3,4,5,2,1,3,4];  % perfect result
% A=[3,7,5,2,3,6,5,3,4,4,5,3,4,4,6]; %perfect result
pr_t=[];
p_delta3=[];
p_delta6=[];
p_delta10=[];
V_delta3=[];
V_delta6=[];
V_delta10=[];
V_t=[];
Vr_t=[];

pr_t_logi=[];
p_delta3_logi=[];
p_delta6_logi=[];
p_delta10_logi=[];
V_delta3_logi=[];
V_delta6_logi=[];
V_delta10_logi=[];
V_t_logi=[];
Vr_t_logi=[];


E1=1-beta; %E[1]
E0=alpha; %E[0]

Am=max(A);
for j=1:N3
    if A(j)==Am
        m=j;
        break
    end
end
Tm=12;

for T=max(D)+1:Tm
    % normal distribution
    [Vr_t(T),pt(T)]=compute_priceM(A(1:N3),Am,0,N3,T,max(D),D(m),alpha,beta,mu,rho);
    
    V1=iterative_costM(A(1:N3),1,N3,1,0,T,D(1:N3),alpha,beta,mu,rho);
    V0=iterative_costM(A(1:N3),1,N3,0,0,T,D(1:N3),alpha,beta,mu,rho);
    Vm=iterative_costM(A(1:N3),1,N3,1,m,T,D(1:N3),alpha,beta,mu,rho);
    f=rho*(V1-Vm)/D(m);
    pr_t(T)=binary_search(f,mu,D(m));
    p_delta3(T)=abs(pr_t(T)-pt(T));
    V_t(T)=Am+E1*normal_distribution(mu,pr_t(T)/D(m))*pr_t(T)+rho*((1-E1)*V0+E1*(1-normal_distribution(mu,pr_t(T)/D(m)))*V1+E1*normal_distribution(mu,pr_t(T)/D(m))*Vm);
    V_delta3(T)=Vr_t(T)-V_t(T);
    
    % logistic distribution
    [Vr_t_logi(T),pt_logi(T)]=compute_priceM_logi(A(1:N3),Am,0,N3,T,max(D),D(m),alpha,beta,mu,rho);
    
    V1=iterative_costM_logi(A(1:N3),1,N3,1,0,T,D(1:N3),alpha,beta,mu,rho);
    V0=iterative_costM_logi(A(1:N3),1,N3,0,0,T,D(1:N3),alpha,beta,mu,rho);
    Vm=iterative_costM_logi(A(1:N3),1,N3,1,m,T,D(1:N3),alpha,beta,mu,rho);
    f=rho*(V1-Vm)/D(m);
    pr_t_logi(T)=binary_search(f,mu,D(m));
    p_delta3_logi(T)=abs(pr_t_logi(T)-pt_logi(T));
    V_t_logi(T)=Am+E1*logistic_distribution(mu,pr_t_logi(T)/D(m))*pr_t_logi(T)+rho*((1-E1)*V0+E1*(1-logistic_distribution(mu,pr_t_logi(T)/D(m)))*V1+E1*logistic_distribution(mu,pr_t_logi(T)/D(m))*Vm);
    V_delta3_logi(T)=Vr_t_logi(T)-V_t_logi(T);
end

for T=max(D)+1:Tm
    [Vr_t(T),pt(T)]=compute_priceM(A(1:N6),Am,0,N6,T,max(D),D(m),alpha,beta,mu,rho);
    
    V1=iterative_costM(A(1:N6),1,N6,1,0,T,D(1:N6),alpha,beta,mu,rho);
    V0=iterative_costM(A(1:N6),1,N6,0,0,T,D(1:N6),alpha,beta,mu,rho);
    Vm=iterative_costM(A(1:N6),1,N6,1,m,T,D(1:N6),alpha,beta,mu,rho);
    f=rho*(V1-Vm)/D(m);
    pr_t(T)=binary_search(f,mu,D(m));
    p_delta6(T)=abs(pr_t(T)-pt(T));
    V_t(T)=Am+E1*normal_distribution(mu,pr_t(T)/D(m))*pr_t(T)+rho*((1-E1)*V0+E1*(1-normal_distribution(mu,pr_t(T)/D(m)))*V1+E1*normal_distribution(mu,pr_t(T)/D(m))*Vm);
    V_delta6(T)=abs(Vr_t(T)-V_t(T));
    
    % logistic distribution
    [Vr_t_logi(T),pt_logi(T)]=compute_priceM_logi(A(1:N6),Am,0,N6,T,max(D),D(m),alpha,beta,mu,rho);
    
    V1=iterative_costM_logi(A(1:N6),1,N6,1,0,T,D(1:N6),alpha,beta,mu,rho);
    V0=iterative_costM_logi(A(1:N6),1,N6,0,0,T,D(1:N6),alpha,beta,mu,rho);
    Vm=iterative_costM_logi(A(1:N6),1,N6,1,m,T,D(1:N6),alpha,beta,mu,rho);
    f=rho*(V1-Vm)/D(m);
    pr_t_logi(T)=binary_search(f,mu,D(m));
    p_delta6_logi(T)=abs(pr_t_logi(T)-pt_logi(T));
    V_t_logi(T)=Am+E1*logistic_distribution(mu,pr_t_logi(T)/D(m))*pr_t_logi(T)+rho*((1-E1)*V0+E1*(1-logistic_distribution(mu,pr_t_logi(T)/D(m)))*V1+E1*logistic_distribution(mu,pr_t_logi(T)/D(m))*Vm);
    V_delta6_logi(T)=abs(Vr_t_logi(T)-V_t_logi(T));
end

for T=max(D)+1:Tm
    [Vr_t(T),pt(T)]=compute_priceM(A(1:N10),Am,0,N10,T,max(D),D(m),alpha,beta,mu,rho);
    
    V1=iterative_costM(A(1:N10),1,N10,1,0,T,D(1:N10),alpha,beta,mu,rho);
    V0=iterative_costM(A(1:N10),1,N10,0,0,T,D(1:N10),alpha,beta,mu,rho);
    Vm=iterative_costM(A(1:N10),1,N10,1,m,T,D(1:N10),alpha,beta,mu,rho);
    f=rho*(V1-Vm)/D(m);
    pr_t(T)=binary_search(f,mu,D(m));
    p_delta10(T)=abs(pr_t(T)-pt(T));
    V_t(T)=Am+E1*normal_distribution(mu,pr_t(T)/D(m))*pr_t(T)+rho*((1-E1)*V0+E1*(1-normal_distribution(mu,pr_t(T)/D(m)))*V1+E1*normal_distribution(mu,pr_t(T)/D(m))*Vm);
    V_delta10(T)=abs(Vr_t(T)-V_t(T));
    
    % logistic distribution
    [Vr_t_logi(T),pt_logi(T)]=compute_priceM_logi(A(1:N10),Am,0,N10,T,max(D),D(m),alpha,beta,mu,rho);
    
    V1=iterative_costM_logi(A(1:N10),1,N10,1,0,T,D(1:N10),alpha,beta,mu,rho);
    V0=iterative_costM_logi(A(1:N10),1,N10,0,0,T,D(1:N10),alpha,beta,mu,rho);
    Vm=iterative_costM_logi(A(1:N10),1,N10,1,m,T,D(1:N10),alpha,beta,mu,rho);
    f=rho*(V1-Vm)/D(m);
    pr_t_logi(T)=binary_search(f,mu,D(m));
    p_delta10_logi(T)=abs(pr_t_logi(T)-pt_logi(T));
    V_t_logi(T)=Am+E1*logistic_distribution(mu,pr_t_logi(T)/D(m))*pr_t_logi(T)+rho*((1-E1)*V0+E1*(1-logistic_distribution(mu,pr_t_logi(T)/D(m)))*V1+E1*logistic_distribution(mu,pr_t_logi(T)/D(m))*Vm);
    V_delta10_logi(T)=abs(Vr_t_logi(T)-V_t_logi(T));
end

x=max(D)+1:1:Tm;
x1=max(D)+1:1:Tm+1;
figure
% plot(x,pt(max(D)+1:Tm),'-*','LineWidth',1.5);hold on;
plot(x,V_delta3(max(D)+1:Tm),'-s','LineWidth',2,'Color','g','MarkerSize',10);hold on;
plot(x,V_delta6(max(D)+1:Tm),'-o','LineWidth',2,'Color','r','MarkerSize',10);hold on;
plot(x,V_delta10(max(D)+1:Tm),'-*','LineWidth',2,'Color','b','MarkerSize',10);
set(gca,'xtick',0:1:x(end));  
% set(gca,'ytick',0:0.05:1);
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.25]);
xlabel('Time horizon T');
ylabel('Actual performance error');
legend('N=3','N=7','N=15');

figure
plot(x,V_delta3_logi(max(D)+1:Tm),'-s','LineWidth',2,'Color','g','MarkerSize',10);hold on;
plot(x,V_delta6_logi(max(D)+1:Tm),'-o','LineWidth',2,'Color','r','MarkerSize',10);hold on;
plot(x,V_delta10_logi(max(D)+1:Tm),'-*','LineWidth',2,'Color','b','MarkerSize',10);
set(gca,'xtick',0:1:x(end));
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.25]);
xlabel('Time horizon T');
ylabel('Actual performance error');
legend('N=3','N=7','N=15');

% x2=11.96:0.02:12;
% x_a(1)=V_delta6_logi(Tm)-(V_delta6_logi(Tm)-V_delta6_logi(Tm-1))*0.04
% x_a(2)=V_delta6_logi(Tm)-(V_delta6_logi(Tm)-V_delta6_logi(Tm-1))*0.02
% x_a(3)=V_delta6_logi(Tm)
% x_b(1)=V_delta6(Tm)-(V_delta6(Tm)-V_delta6(Tm-1))*0.04
% x_b(2)=V_delta6(Tm)-(V_delta6(Tm)-V_delta6(Tm-1))*0.02
% x_b(3)=V_delta6(Tm)
% 
% ax=axes('Position',[0.8 0.95 0.15 0.15]);
% 
% plot(ax,x2,x_b(:),'-s','LineWidth',2,'Color','g','MarkerSize',10);hold on;
% plot(ax,x2,x_a(:),'--s','LineWidth',2,'Color','k','MarkerSize',10);hold on;
% axis([11.96 12.00 0.065 0.075])
% legend('N=3, normal','N=3, logistic');
