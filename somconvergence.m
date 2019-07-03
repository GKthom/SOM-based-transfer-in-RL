clear all
close all
clc

for i=1:10000
% y(i)=(1+(sqrt(2)*i)-i)/(1+(sqrt(2))*i);
% y(i)=1000*(2+3*sqrt(2)*i-i)/2/(1+sqrt(2)*i);
y(i)=0.3*((sqrt(i)+1)^2)/((sqrt(i)+1)^2-i);
end
plot(y)