function [ res ] = CCDResponse(wavelength)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


pa1 = 147.5;
pb1 = 235.9;
pc1 = 411.5;
pa2 = -110.7;
pb2 = 407.4;
pc2 = 76.31;
pa3 = 30.07;
pb3 = 599.8;
pc3 = 65.63;
%curve fitted phododiode sensitivity
pfunc = @(x) pa1*exp(-((x-pb1)/pc1)^2)+pa2*exp(-((x-pb2)/pc2)^2)+pa3*exp(-((x-pb3)/pc3)^2);
%figure
%fplot(pfunc,[400 1100]);

%scaling photodiode sensitivity
scale1=pfunc(550);

for x=400:1100
    diodescale(x)=pfunc(x)./scale1;
end
%figure
%plot(400:1100,diodescale(400:1100));

%applying quantum efficiency to scaled graph
h=6.62607004E-34; %m^2kg/s
qeff=0.17; %A/W @ 550 nanometers
e=1.60217662*10^-19; %coulombs/electron
ejoule=qeff*(1/e); %electron/joule
qeffconv=1/(ejoule*((h*3E8)/(550*10^-9))); %photons/electron

for x=400:1100
    diodeqeff(x)=diodescale(x).*qeffconv;
end
%figure
%plot(400:1100,diodeqeff(400:1100));

%Data from Spectrometer and Photodiode Measurements
Presponse=0.3; %Backcurrent in micro Amps
PresponseA=Presponse./1000000; %Backcurrent in Amps (c/s)
SensArea=7.02; %mm^2

%Finding Environmental Flux
eflux=(PresponseA/e)/SensArea; %electrons/mm^2*s

%Photonic Environmental Flux at Spectrometer Peak Wavelength
%522.519 peak wavelength

psa1 = 0.8175;
psb1 = 599.8;
psc1 = 65.63;
psa2 = -3.01;
psb2 = 407.4;
psc2 = 76.31;
psa3 = 4.011;
psb3 = 235.9;
psc3 = 411.5;

pscalefunc= @(x) psa1*exp(-((x-psb1)/psc1)^2)+psa2*exp(-((x-psb2)/psc2)^2)+psa3*exp(-((x-psb3)/psc3)^2); %photons/electrons function
%figure
%fplot(pscalefunc,[400 1100])%%%%%%%%%
photonflux=eflux*pscalefunc(522.519); %photon/mm^2*s

%Scaling the Spectrometer Sensitivity Curve

sa1 = 0.0601;
sb1 = 511.4;
sc1 = 54.84;
sa2 = 0.2934;
sb2 = 407.6;
sc2 = 87.8;
sa3 = 0.9866;
sb3 = 592.2;
sc3 = 238.6;

sensfunc= @(x) sa1*exp(-((x-sb1)/sc1)^2)+sa2*exp(-((x-sb2)/sc2)^2)+sa3*exp(-((x-sb3)/sc3)^2);
%fplot(sensfunc,[300 1100])
scale2=sensfunc(522.519);
for x=200:1100
    sensscale(x)=sensfunc(x)./scale2;
end
%figure
%plot(200:1100,sensscale(200:1100)) %CORRECT THUS FAR

%Finding the Spectrometer Responsivity
counts=958326.8; %integrated entire intensity response???

%64063.36 singular intensity response???
sls=0.2; %slit diameter mm
slA=pi*(sls/2)^2; %slit area mm^2
inttime=(3.8/1000); %integration time in s

responsivity=((photonflux*slA*inttime)/counts);


sca1 = 0.05913;
scb1 = 511.4;
scc1 = 54.84;
sca2 = 0.9706;
scb2 = 592.2;
scc2 = 238.6;
sca3 = 0.2886;
scb3 = 407.6;
scc3 = 87.8;

soptfunc = @(x) sca1*exp(-((x-scb1)/scc1)^2)+sca2*exp(-((x-scb2)/scc2)^2)+sca3*exp(-((x-scb3)/scc3)^2); %extended scaled function


for x=200:1100
    squant(x)=soptfunc(x)*(1/responsivity);
end


%{
figure
subplot(1,3,1)
plot(200:1100,squant(200:1100))%counts/photon matching quantum efficiency
title('CCD Responsivity')
xlabel('Wavelength (nm)')
ylabel('Responsivity (counts/photon)')
%}

for x=200:1100
    response(x)=1./squant(x);
end

%{
subplot(1,3,2)
plot(200:1100,response(200:1100));
title('CCD Responsivity 200-1100 nm')
xlabel('wavelength (nm)')
ylabel('responsivity (photons/count)')
subplot(1,3,3)
plot(350:700,response(350:700));
title('CCD Responsivity 350-700 nm')
xlabel('wavelength (nm)')
ylabel('responsivity (photons/count)')
%}

ra1 = 9.85e+04;
rb1 = 1394;
rc1 = 171.8;
ra2 = 1.321e+17;
rb2 = 9029;
rc2 = 1407;
ra3 = 2.002e+11;
rb3 = -2682;
rc3 = 661.6;

responsefinal = @(x) ra1*exp(-((x-rb1)/rc1)^2)+ra2*exp(-((x-rb2)/rc2)^2)+ra3*exp(-((x-rb3)/rc3)^2);

%{
figure
fplot(responsefinal,[350 700]);
title('Gaussian Approximation of CCD Response')
xlabel('wavelength (nm)')
ylabel('responsivity (photons/count)')
%}

for x=200:1100
    diff(x)=response(x)-responsefinal(x);
end
%{
figure
subplot(1,2,1)
plot(200:1100,diff(200:1100));
title('Error in Approximation Function')
xlabel('wavelength (nm)')
ylabel('responsivity (photons/count)')
%}

da0 = 20.74;
da1 = 6.32;
db1 = 12.47;
da2 = 26.96;
db2 = 2.897;
da3 = -8.787;
db3 = 21.21;
da4 = -10.33;
db4 = 12.98;
dw =  0.005199;

diffunc = @(x) da0+da1*cos(x*dw)+db1*sin(x*dw)+da2*cos(2*x*dw)+db2*sin(2*x*dw)+da3*cos(3*x*dw)+db3*sin(3*x*dw)+da4*cos(4*x*dw)+db4*sin(4*x*dw);
%{
subplot(1,2,2)
fplot(diffunc,[200 1100]);
title('Approximated Error Function')
xlabel('wavelength (nm)')
ylabel('responsivity (photons/count)')
%}


totalfunc = @(x) (ra1*exp(-((x-rb1)/rc1)^2)+ra2*exp(-((x-rb2)/rc2)^2)+ra3*exp(-((x-rb3)/rc3)^2)+(da0+da1*cos(x*dw)+db1*sin(x*dw)+da2*cos(2*x*dw)+db2*sin(2*x*dw)+da3*cos(3*x*dw)+db3*sin(3*x*dw)+da4*cos(4*x*dw)+db4*sin(4*x*dw)));
%{
figure
subplot(1,2,1)
plot(350:700,response(350:700));
title('CCD Responsivity 350-700 nm')
xlabel('wavelength (nm)')
ylabel('responsivity (photons/count)')
subplot(1,2,2)
fplot(totalfunc,[350 700]);
title('CCD Responsivity Approximation Function 350-700 nm')
xlabel('wavelength (nm)')
ylabel('responsivity (photons/count)')
%}

totalfunc(550);
response(550);

res = response(wavelength);
end

