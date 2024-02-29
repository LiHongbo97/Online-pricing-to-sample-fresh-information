function [ pt ] = binary_search(f,mu,D)

delta=0.01;

f1=exp(-(1-mu)^2);
Hb=1+1/f1;
Ha=0;
max=1/delta;
b=1;
a=0;

if Hb<=f
    pt=D;
else
    for k=1:max
        c=(a+b)/2;
        fc=exp(-(c-mu)^2);
        Fc=normal_distribution(mu,c);
        Hc=c+Fc/fc;
        if Hc==f
            Ha=c;Hb=c;
        elseif Hc>f
            Hb=Hc;b=c;
        else
            Ha=Hc;a=c;
        end
        if b-a<delta
            break
        end
    end
    c=(a+b)/2;
    pt=c*D;
end