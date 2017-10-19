function [ irradiance ] = SolarIrradiance( wavmax,wavmin )
%SolarIrradiance Calculate Solar Irradiance at a given wavelength range
%   By using a curve fitted solar irradiance graph, one can input a range
%   of wavelengths and calculate a flux in W/m^2


a0=-0.8039;
a1=-1.642;
b1=1.763;
a2=-0.8456;
b2=1.719;
a3=-0.1206;
b3=0.8862;
a4=0.04972;
b4=0.2181;
w=0.00173;

h = @(x) a0+a1*cos(x*w)+b1*sin(x*w)+a2*cos(2*x*w)+b2*sin(2*x*w)+a3*cos(3*x*w)+b3*sin(3*x*w)+a4*cos(4*x*w)+b4*sin(4*x*w);

irradiance=integral(h,wavmin,wavmax);

end

