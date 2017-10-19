function [avgSpectralIrradiance] = importStarData(proportionedWavelengths,apparentMagnitude,wavelengthTop,wavelengthBottom,binSize)

%% Import Physical Constants:
    L = 3.846*10^26; %Luminosity of the sun in Watts
    R = 696342000; %Radius of the sun
    
    ly =  9.454254955488000e+15; %meters in a lightyear
    
%% Import the Star Database
starDatabase = xlsread('csv files/Star Data.xlsx');
    Magnitude = starDatabase(:,1);
    T = starDatabase(:,3);
    
    Distance = ly*starDatabase(:,2);
    
    Luminosity = L*starDatabase(:,4); %%why multiply luminosity of sun by luminosity of stars??
    
%% Process the Star Database to produce Magnitude/Irradiance Relationship
for i = 2:length(T)%% why index at i=2?
Lum = Luminosity(i);
Rad = Distance(i);
    [starsOutputWavelengths,Lam] = UnitBlackBody(binSize,T(i)); %what is lam??
    [scaledOutput] = applyLuminosity(proportionedWavelengths,Lum,Rad,starsOutputWavelengths,wavelengthTop,wavelengthBottom,binSize);
    
starPhotonData(:,i) = mean(scaledOutput);
end
% starPhotonData(end+1) = 1362;
% Magnitude(end+1) = -26.74;
%% Perform Curve Fitting analysis:
Data = [Magnitude starPhotonData'];
% ignore = find(Data(:,1) > apparentMagnitude - 3);
%     Data(ignore,:) =[];

fittedData = fit(Data(:,1),Data(:,2),'exp1');
coeff = coeffvalues(fittedData);
    
    a = coeff(1);
    b = coeff(2);
    
avgSpectralIrradiance = a*exp(b*apparentMagnitude);  %Star Database

%% Plot the Data to verify results:
% plot(fittedData,Magnitude,starPhotonData');
%     title('Spectral Irradiance vs Apparent Magnitude');
%     xlabel('Apparent Magnitude');
%     ylabel('Spectral Irradiance (W/m^2/nm)');
%     axis auto
%     hold on 

% set(gca, 'FontSize', 20)

end