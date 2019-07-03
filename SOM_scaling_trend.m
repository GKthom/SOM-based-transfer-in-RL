clear
close all
clc
Gt=0.3;
x=1:1000000;
for i=1:length(x)
    n=i;
    n_dash=(sqrt(n)+1)^2;%n+1;%(sqrt(n)+1)^2;
    dndash=(1+sqrt(n))/sqrt(n);%1;%(1+sqrt(n))/sqrt(n);%dN'/dN
    y(i)=Gt*n_dash/(n_dash-n);%generalized error
    z(i)=Gt*(n_dash-(n*dndash))/((n_dash-n)^2);%generalized rate of change of error. This reduced asymptotically to 0. This means that after a point, e does not change with N. Which means new SOMs dont form
end
% plot(x,y)
semilogy(x,y)
xlabel('SOM size','FontSize',16)
ylabel('Permissible average network error','FontSize',16)
figure
% plot(x,z)
semilogy(x,z)
xlabel('SOM size','FontSize',16)
ylabel('Rate of change of permissible average network error','FontSize',16)