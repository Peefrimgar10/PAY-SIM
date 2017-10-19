function [sizes] = mirrorsizemod(SNR,FS,wavmax,wavmin,binsize,mirroreff1,mirroreff2,bandwavelength,exposuretime,apparentmagnitude,mode,shape,axis)
%lenssize Calculates the radius and area of a mirror (in inches, square inches) required to meet a
%desired SNR, stored in a 1x2 row vector.
%   Working from a known/desired signal to noise ratio (SNR) and factor of
%   safety (FS), the user may output the mirror size required to obtain this
%   parameter. By specifying the total noise of a system, the maximum
%   and minimum wavelengths the optical array is seeing (wavmax, wavmin IN NANOMETERS),
%   the bin size (IN NANOMETERS), and the sensitivity of a CCD sensor, the
%   program works from SNR up to calculating the light entering the CCD in
%   photons. If the efficiency of a grating and mirror, the band wavelength
%   (wavelength of the color of light you are looking at IN NANOMETERS), exposure time
%   (amount of time the object is being viewed for in SECONDS), and
%   apparent magnitude of the viewed object are specificed, the function
%   may work from the light entering the CCD to the mirror area. Each segment
%   of calculations is further explained below.
%   UPDATE: Added various setups for mirrors including square and
%   rectangular configurations. For the rectangular configuration the
%   largest side length of the satellite cross section is used.

%1 IS ON AXIS AND 2 IS OFF AXIS

h0=-237.4; %OCEANOPTICS GRATING #3 SENSITIVITY FUNCTION
h1=-238.7;
i1=362.3;
h2=51.27;
i2=168.6;
h3=27.47;
i3=5.403;
z=0.003018;

gratingfun = @(x) h0+h1*cos(x*z)+i1*sin(x*z)+h2*cos(2*x*z)+i2*sin(2*x*z)+h3*cos(3*x*z)+i3*sin(3*x*z);

if mode == 1 %size vs bin number
    
%Using a known SNR with factor of safety, find the true SNR
SNRpix = SNR*FS; %True SNR of pixel
bins = (wavmax-wavmin)/binsize;%the number of bins equals the number of pixels
pix = bins; %divide pixels into an array from 1 to max bin number in steps of 1 (pixel number)
%edit, just solve for largest number of bins
%Find the signal using true SNR and total noise
Noise = sqrt(bins*((1.3827.*exposuretime)+55.014)^2);
Signal = SNRpix.*Noise.*pix; %digital counts

%Find the number of pixels exposed to light and then find the light
%entering the CCD
%nanometers

lccd = (Signal.*CCDResponse(bandwavelength)); %in photons

%Find light entering grating using grating efficiency
lgrat = lccd./(gratingfun(bandwavelength)/100); %in photons

%Find light entering lens using lens efficiency
lsecondary = lgrat./mirroreff2; %in photons
llens=lsecondary./mirroreff1;


%Using apparent magnitude, sun apparent magnitude, flux, and exposure time,
%find the area of the lens required
msun = -26.74; %apparent magnitude of sun
S = SolarIrradiance(wavmax,wavmin); %W/m^2 solar constant (J/m^2*s)
h = 6.626.*10.^-34; %Planck's constant J*s
w = bandwavelength.*10.^-9; %wavelength in meters of a teal photon
c = 3.*10.^8; %speed of light m/s
E = (h.*c)./w; %Energy per photon of teal photon (J/photon)
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

%UPDATE: INCORPORATE SHAPES HERE
%NOTE THAT SOME VARIABLE NAMES HAVE NOT BEEN CHANGED CUZ FUK IT

%OFF AXIS SETUP

%Find the required side length of the mirror were it a square
if shape == 2
radlens=sqrt(areanew).*100;
val = 'Square';
%Find the required side length of the mirror were it a rectangle with the
%largest cross sectional side length (239 mm side ~ 9.409 in)
else if shape == 3
        radlens = (areanew./9.409).*100;
        val = 'Rectangle';

%Find the required radius of the mirror were it a circle
else if shape == 1
radlens = (sqrt(areanew./pi).*100).*2; %diameter of mirror in inches too lazy to change variable name
sizes = radlens
val = 'Circle';
    end
    end
end
end
%{
figure
plot(pix,radlens(1:length(pix)))

title({['Size vs. Number of Bins '' (Bin Size: ' num2str(binsize) ' nm)'];['Exposure Time ' num2str(exposuretime) ' Seconds, SNR ' num2str(SNR*FS) ', Wavelength ' num2str(bandwavelength) ' nm'];['Range: ' num2str(wavmin) ' to ' num2str(wavmax) ' nm'];['Magnitude ' num2str(apparentmagnitude)];[val];[type]})
xlabel('Bin #')
ylabel('Diameter/Side Length (cm)')
sizes = radlens

figure
plot(pix,areanew(1:length(pix)))

title({['Area vs. Number of Bins '' (Bin Size: ' num2str(binsize) ' nm)'];['Exposure Time ' num2str(exposuretime) ' Seconds, SNR ' num2str(SNR*FS) ', Wavelength ' num2str(bandwavelength) ' nm'];['Range: ' num2str(wavmin) ' to ' num2str(wavmax) ' nm'];['Magnitude ' num2str(apparentmagnitude)];[val];[type]})
xlabel('Bin #')
ylabel('Area (m^2)')
sizes = areanew;
%}
%plost not necessary for final sim
if mode == 2 %size vs exposure time
        
SNRpix = SNR*FS; 
bins = (wavmax-wavmin)/binsize; 
Noise = sqrt(bins*((1.3827.*linspace(1,exposuretime,exposuretime))+55.014)^2);
Signal = SNRpix.*Noise*bins;
lccd = (Signal.*CCDResponse(bandwavelength)); 
lgrat = lccd./(gratingfun(bandwavelength)/100); %in photons
lsecondary = lgrat./mirroreff2;
llens = lgrat./mirroreff1; %in photons
msun = -26.74; %apparent magnitude of sun
S = SolarIrradiance(wavmax,wavmin); %W/m^2 solar constant (J/m^2*s)
h = 6.626.*10.^-34; %Planck's constant J*s
w = bandwavelength.*10.^-9; %wavelength in meters of a teal photon
c = 3.*10.^8; %speed of light m/s
E = (h.*c)./w; %Energy per photon of teal photon (J/photon)
PFsun = S./E; %Photonic flux of sun at specific color (Photon/m^2*s)
PFapp = PFsun.*2.512.^(msun-apparentmagnitude); %Using Fechner's Law apparent photonic flux is calculated (Photon/m^2*s)
arealens = (llens./(PFapp.*linspace(0,exposuretime,exposuretime))); %area of lens in square meters
if axis == 1
    areanew = arealens;
    type='Off-Axis';
else if axis == 2 
        areanew = arealens + 0.25.*arealens;
        type='On-Axis';
    end
end
if shape == 1
radlens = (sqrt(areanew./pi).*100).*2; %diameter of lens in inches too lazy to change variable name
sizes = radlens;
val = 'Circle';
%square
else if shape == 2
        radlens = sqrt(areanew).*100;
        val = 'Square';
%rectangle using 239 mm side
    else if shape == 3
            radlens = (areanew./9.409).*100;
            val = 'Rectangle';
        end
    end
end
end

%{
figure
plot(linspace(0,exposuretime,exposuretime),radlens(1:exposuretime))

title({['Radius vs. Exposure Time ' '(For One Bin)'];['SNR ' num2str(SNR*FS) ', Wavelength ' num2str(bandwavelength) ' nm'];['Range: ' num2str(wavmin) ' to ' num2str(wavmax) ' nm'];['Magnitude ' num2str(apparentmagnitude)];[val];[type]})
xlabel('Exposure Time (seconds)')
ylabel('Size/Diameter (cm)')

figure
plot(linspace(0,exposuretime,exposuretime),areanew(1:exposuretime))

title({['Area vs. Exposure Time ' '(For One Bin)'];['SNR ' num2str(SNR*FS) ', Wavelength ' num2str(bandwavelength) ' nm'];['Range: ' num2str(wavmin) ' to ' num2str(wavmax) ' nm'];['Magnitude ' num2str(apparentmagnitude)];[val];[type]})
xlabel('Exposure Time (seconds)')
ylabel('Area (m^2)')
%}


if mode == 3
        sizes=lensvswavelength(SNR,FS,wavmax,wavmin,binsize,mirroreff1,mirroreff2,exposuretime,apparentmagnitude,shape,axis);
end       
    
end