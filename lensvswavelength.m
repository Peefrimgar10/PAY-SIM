function [ sizes ] = lensvswavelength( SNR,FS,wavmax,wavmin,binsize,mirroreff1,mirroreff2,exposuretime,apparentmagnitude,shape,axis)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%same shit as before, modified for each possible mirror setup, utilizes grating #3 

h0=-237.4; %OCEANOPTICS GRATING #3 SENSITIVITY FUNCTION
h1=-238.7;
i1=362.3;
h2=51.27;
i2=168.6;
h3=27.47;
i3=5.403;
z=0.003018;

gratingfun = @(x) h0+h1*cos(x*z)+i1*sin(x*z)+h2*cos(2*x*z)+i2*sin(2*x*z)+h3*cos(3*x*z)+i3*sin(3*x*z);

for bandwave = 1:(wavmax-wavmin)
    
SNRpix = SNR*FS; 
bins = (wavmax-wavmin)/binsize; 
Noise = (1.3827.*exposuretime)+55.014;
Signal = SNRpix.*Noise;
lccd = (Signal.*CCDResponse((wavmin+bandwave))); 
lgrat = lccd./(gratingfun(wavmin+bandwave)./100); %in photons
lsecondary = lgrat./mirroreff2;
llens = lgrat./mirroreff1; %in photons
msun = -26.74; %apparent magnitude of sun
S = SolarIrradiance(wavmax,wavmin); %W/m^2 solar constant (J/m^2*s)
h = 6.626.*10.^-34; %Planck's constant J*s
lam = (wavmin+bandwave).*10.^-9; %wavelength in meters of a teal photon
c = 3.*10.^8; %speed of light m/s
E = (h.*c)./lam; %Energy per photon of teal photon (J/photon)
PFsun = S./E; %Photonic flux of sun at specific color (Photon/m^2*s)
PFapp = PFsun.*2.512.^(msun-apparentmagnitude); %Using Fechner's Law apparent photonic flux is calculated (Photon/m^2*s)
arealens = (llens./(PFapp.*exposuretime)); %area of lens in square meters
if axis == 1
    areanew = arealens;
    type='Off-Axis';
else if axis == 2 
        areanew = arealens + 0.25.*arealens;
        type='On-Axis';
    end
end


if shape ==1 %circle
radlens(bandwave) = sqrt(areanew./pi).*100; %radius of mirror in inches
val='Circle';
else if shape ==2 %square
        radlens(bandwave) = sqrt(areanew).*100;
        val='Square';
    else if shape ==3 %rectangle
            radlens(bandwave) = (areanew./9.409).*100; %239 mm side in inches;
            val='Rectangle';
        end
    end
end

        
    


end

    
figure
plot(linspace(wavmin,wavmax),radlens(1:length(linspace(wavmin,wavmax))))

title({['Side Length/Radius vs. Wavelength' val];['Exposure Time ' num2str(exposuretime) ' Seconds, SNR ' num2str(SNR*FS)];['Magnitude ' num2str(apparentmagnitude)];[type]})
xlabel('Wavelength (nanometers)')
ylabel('Size (cm)')
sizes = radlens;

d=length(radlens);

end

