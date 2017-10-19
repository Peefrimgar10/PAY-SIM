function [proportionedWavelengths,Lam] = UnitBlackBody(binSize, T)
format long
%% Establish variables and universal constants
    h = 6.62606957*10.^-34; %J s
    c = 299792458; %m/s
    k = 1.38064852*10.^-23; %J/K
    
    Lam = [binSize:binSize:(2600*10^-9)]; 
    
%% Create the "Unit" Black Body spectrum to be scaled later
    Irradiance = (2*h*c*c)./((Lam.^5).*(exp((h.*c)./(k.*T.*Lam))-1));
    Irradiance = Irradiance;%.*12.56637061;
    
    IrradianceArea = sum(Irradiance);
    proportionedWavelengths = Irradiance/IrradianceArea;


%% Plot the solar model as a test of results:

% bar(Lam,proportionedWavelengths,'r'); %Display the model for solar output
%     title('Model of Solar Output');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2/nm)');
%     axis auto
end