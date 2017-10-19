function [grateff] = grating3(wavelength)

%{
h0=-237.4; %OCEANOPTICS GRATING #3 SENSITIVITY FUNCTION
h1=-238.7;
i1=362.3;
h2=51.27;
i2=168.6;
h3=27.47;
i3=5.403;
z=0.003018;

gratingfun = @(x) h0+h1*cos(x*z)+i1*sin(x*z)+h2*cos(2*x*z)+i2*sin(2*x*z)+h3*cos(3*x*z)+i3*sin(3*x*z);

figure
fplot(gratingfun,[350 800])
%}
%Old stuff
%{
Grating = csvread('C:\Users\Benjamin\Documents\SCI\SORA_Payload_Sim\Grating3NewData.csv');
Gx = Grating(:,1);
Gy = Grating(:,2);
%}

a1 = 4.213;  
b1 = 438.9; 
c1 = 25.39;  
a2 = 36.16;  
b2 = 463.6;  
c2 = 116.7;  
a3 = 13.68; 
b3 = 560.9; 
c3 = 125.2; 
a4 = 33.65;  
b4 = 355.4;  
c4 = 84.63;  
a5 = 34.31;  
b5 = 641.5;  
c5 = 183.1; 
a6 = 29.55;  
b6 = 933.9;  
c6 = 287.3;  
a7 = 1.438;  
b7 = 487.5;  
c7 = 49.66;

grating3fun = @(x) a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2) + a3*exp(-((x-b3)/c3)^2) + a4*exp(-((x-b4)/c4)^2) + a5*exp(-((x-b5)/c5)^2) + a6*exp(-((x-b6)/c6)^2) + a7*exp(-((x-b7)/c7)^2);

grateff = grating3fun(wavelength);
%{
figure
fplot(grating3fun,[300 800])
%}
end

