clf
clearvars
%% Setup useful factors and shit:
c = 299792458; %Speed of light in m/s
T = 5778; %Temperature of the sun
JyToWatts = 10^-26; %Jansky to Watts Covnersion Factor
targetMagnitude = -26.74:.1:15; %The Apparent Magnitude of the Sun
k = 100^(1/5); %Fechner's Law Coefficient
nm = 10^-9; %Size of a nanometer (in meters)
devConv = 2*sqrt(2*log(2)); %Conversion for FWHM to Standard Deviation
wavelengthTop = 1.1*10^-6; %highest wavelength we're observing
wavelengthBottom = 4*10^-7; %lowest wavelength we're observing
binSize = 10*10^-9; %bin size of optical system in nm

%% Comparison with Solar Irradiance Data:
binSize = .1*10^-9;
[proportionedWavelengths,Lam] = UnitBlackBody(binSize, T); %Create Black Body Spectrum of the sun


%% Import the Standard Reference Values (SRV):
for j = 1:12
SRV = xlsread('csv files/Standard Reference Values.xlsx');
    WaveLength = SRV(j,1);
        Freq = c/WaveLength;

    FWHM = SRV(j,2);
        std_dev = FWHM/devConv;
        lowBound = WaveLength - (FWHM/2);
        highBound = WaveLength + (FWHM/2);
   
    ReferenceFlux = Freq*JyToWatts*SRV(j,3);
    
%% Perform Flux Conversion Operation for the range of apparent magnitudes:
for i = 1:length(targetMagnitude)
    mag = targetMagnitude(i);
    
    x = lowBound:nm:highBound;
    y = (std_dev*sqrt(2*pi)).^-1*exp(-.5*((x-WaveLength)/std_dev).^2);
    integral = (sum(y)*(highBound-lowBound));
    
    BandFlux(i) = ReferenceFlux.*k.^(0-mag);
    BandFlux2(i) = BandFlux(i)/integral;
end

%% Import the star Data set:
    [Magnitude,starPhotonData,fittedData] = importStarData(proportionedWavelengths,targetMagnitude,wavelengthTop,wavelengthBottom,binSize);

%% Scale the data using Unit Blackbody System
    index = find(Lam <= WaveLength);
    point = index(end) + 1;
    scale = BandFlux2/proportionedWavelengths(point);
    Irradiance = BandFlux2.*scale;
    
starPhotonData(end+1) = 1362;
Magnitude(end+1) = -26.74;

    
%% Plot the results of the output
semilogy(targetMagnitude,Irradiance)
    title('Photon Flux vs Apparent Magnitude (Fechners Law)','FontSize',16);
    xlabel('Apparent Magnitude');
    ylabel('Spectral Irradiance (W/m^2/nm)');
hold on
end


plot(fittedData,Magnitude,starPhotonData','o')
    legend({'U band','B band','g band','V band','R band','r Band','I band','i Band','z band','J band','H band','K band'},'FontSize',12)
    legend({'Star Data','Flux Model based on Star Data'},'FontSize',12,'FontWeight','bold')
    xlabel('Apparent Magnitude','FontSize',16);
    ylabel('Spectral Irradiance (W/m^2/nm)','FontSize',16);
hold on