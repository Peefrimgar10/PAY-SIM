clf
clearvars
%% Setup useful factors and shit:
c = 299792458; %Speed of light in m/s
T = 5778; %Temperature of the sun
JyToWatts = 10^-26; %Jansky to Watts Covnersion Factor
targetMagnitude = -26.74; %The Apparent Magnitude of the Sun
k = 100^(1/5); %Fechner's Law Coefficient
nm = 10^-9; %Size of a nanometer (in meters)
devConv = 2*sqrt(2*log(2)); %Conversion for FWHM to Standard Deviation

%% Initialize some shit:
integral = zeros(1,12);
Freq = zeros(1,12);
ReferenceFlux = zeros(1,12);
BandFlux = zeros(1,12);

%% Comparison with Solar Irradiance Data:
binSize = .1*10^-9;
[proportionedWavelengths,Lam] = UnitBlackBody(binSize, T); %Create Black Body Spectrum of the sun
[FullIrradiance] = applySolarConstant(proportionedWavelengths,Lam,binSize);

%% Import the Standard Reference Values (SRV):
SRV = xlsread('csv files/Standard Reference Values.xlsx');
    WaveLength = SRV(:,1);
        for i = 1:length(WaveLength)
            Freq(i) = c/WaveLength(i);
        end
    FWHM = SRV(:,2);
    for i = 1:length(SRV(:,3))
        ReferenceFlux(i) = Freq(i)*JyToWatts*SRV(i,3);
    end
%% Perform Flux Conversion Operation for the Sun:
for i = 1:12
    std_dev = FWHM(i)/devConv;
        
    lowBound = WaveLength(i) - (FWHM(i)/2);
    highBound = WaveLength(i) + (FWHM(i)/2);
    
    x = lowBound:nm:highBound;
    y = (std_dev*sqrt(2*pi)).^-1*exp(-.5*((x-WaveLength(i))/std_dev).^2);
    integral(i) = (sum(y)*(highBound-lowBound));
    
    BandFlux(i) = ReferenceFlux(i).*k.^(0-targetMagnitude);
    BandFlux2(i) = BandFlux(i)/integral(i);
end

%% Plot all that data stuff:
%Solar Model using Plancks Law:
subplot(2,2,1)
    bar(Lam,FullIrradiance(:,1),'r');
    title('Model of Solar Irradiance (Via Plancks Law)');
    xlabel('Wavelength (m)');
    ylabel('Spectral Irradiance (W/m^2/nm)');
    xlim([0 2500*10^-9]);
    ylim([0 2]);
        
%Raw Reference Data:
subplot(2,2,2)
    scatter(WaveLength,SRV(:,3))
    title('Reference Flux values for m = 0');
    xlabel('Wavelength (m)');
    ylabel('Reference Flux (Jy)');
    xlim([0 2500*10^-9]);
    
%Predicted Solar Irradiance using the Reference Flux values at m = 0        
subplot(2,2,3)
    plot(WaveLength,BandFlux,'r');
    title('Apply Fechners law to Each Band (STEP 1)');
    xlabel('Wavelength (m)');
    ylabel('Irradiance (W/m^2)');
    xlim([0 2500*10^-9]);
    
%Predicted Solar Irradiance #2
subplot(2,2,4)
    plot(WaveLength,BandFlux2,'r');
    title('Apply FWHM Integrals (STEP 2)');
    xlabel('Wavelength (m)');
    ylabel('Irradiance (W/m^2)');
    xlim([0 2500*10^-9]);
    
%% Adjust some basic settings:
fig = get(groot,'CurrentFigure');
set(fig,'ToolBar','none','NumberTitle','off','Name','Data Processing Window')