%This function utilizes Fechner's law to convert fluxes to magnitudes based
%on a set of reference values which are stored in a .xls file for easy
%formatting
clf
clearvars
c = 299792458; %Speed of light in m/s
%% Comparison with Solar Irradiance Data:
T = 5778; %Temperature of the sun
binSize = .1*10^-9;
[proportionedWavelengths,Lam] = UnitBlackBody(binSize, T); %Create Black Body Spectrum of the sun
[FullIrradiance] = applySolarConstant(proportionedWavelengths,Lam,binSize);

subplot(2,2,4)
bar(Lam,FullIrradiance(:,1),'r'); %Display the model for solar output
    title('Model of Solar Irradiance (Via Plancks Law)');
    xlabel('Wavelength (m)');
    ylabel('Spectral Irradiance (W/m^2/nm)');
        ylim([0 2]);
        xlim([0 2500*10^-9]);

%% Import the Standard Reference Values (SRV):
SRV = xlsread('csv files/Standard Reference Values.xlsx');

%% Perform Flux Conversion Operation:
%This is a test to see if the function actually works properly:
v = -30:-25;
integral = zeros(1,12);
BandFlux = zeros(length(v),12);
for j = 1:12
    for i = v
        targetMagnitude = i;
        WaveLength = SRV(j,1);
            Freq = c/WaveLength; %Frequency (in Hz) of a target
            JyToWatts = 10^-26;
        ReferenceFlux(j) = Freq*JyToWatts*SRV(j,3);
        k = 100^(1/5);
        BandFlux(i+31,j) = ReferenceFlux(j).*k.^(0-targetMagnitude);
    end
    %Plot the FWHM Distribution for each Band:
    devConv = 2*sqrt(2*log(2));
    std_dev = SRV(j,2)/devConv;
    mean = SRV(j,1);
    lowBound = mean - (SRV(j,2)/2);
    highBound = mean + (SRV(j,2)/2);
    nm = 10^-9;
        x = lowBound:nm:highBound;
        y = (std_dev*sqrt(2*pi))^-1*exp(-.5*((x-mean)/std_dev).^2);
    subplot(2,2,1)
        plot(x,y);
            title('FWHM Distributions of Reference Bands');
            xlabel('Wavelength (m)');
        xlim([0 2500*10^-9]);
        ylim([0 8*10^6]);
        hold on
        integral(j) = (sum(y)*(highBound-lowBound));
end

subplot(2,2,2)
    plot(SRV(:,1),ReferenceFlux);
    title('Reference Flux at FWHM for m = 0 Object');
    xlabel('Wavelength');
    ylabel('Flux');
    xlim([0 2500*10^-9]);
% plot(v,BandFlux);
%     title('Plot of Adjusted Fluxes Over Reference Bands');
%     xlabel('Apparent Magnitude');
%     xlim([-30 -25]);
hold on
    
%% Calculate the flux for the sun:
SunsApparentMag = -26.74;
SolarBandFlux = zeros(1,12); %Initialize the variable to increase speed
    for i = 1:12
        k = 100.^(1/5);
        WaveLength = SRV(i,1);
            Freq = c/WaveLength; %Frequency (in Hz) of a target
            JyToWatts = 10^-26; %Jansky to Watts Conversion Factor
        SolarBandFlux(i) = (ReferenceFlux(i)*(k.^(0-SunsApparentMag))/integral(i));
    end
    
WaveLengths = SRV(:,1);

subplot(2,2,3)
a = stem(WaveLengths,SolarBandFlux,'o-','color','b','LineWidth',2);
    title('Predicted Solar Irradiance (Via Fechners Law)');
    xlabel('Wavelength (m)');
    ylabel('Spectral Irradiance (W/m^2/nm)');
    hold on
subplot(2,2,3)
    
KnownSIWL = FullIrradiance(:,2);
KnownIrradiance = FullIrradiance(:,1);
for i = 1:length(WaveLengths)
    index = find(KnownSIWL <= WaveLengths(i));
    point = index(end) + 1;
    KnownSolarIrradianceValue(i) = KnownIrradiance(point);
end

subplot(2,2,3)
b = stem(WaveLengths,KnownSolarIrradianceValue,'color','r','LineWidth',2);
legend('Predicted SI Via Fechners Law','Model of SI Via Plancks Law');

%% Adjust some basic settings:
fig = get(groot,'CurrentFigure');
set(fig,'MenuBar','none','ToolBar','none','NumberTitle','off','Name','Data Processing Window')