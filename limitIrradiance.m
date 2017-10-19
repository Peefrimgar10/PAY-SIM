function [IrradianceLimited] = limitIrradiance(FullIrradiance,wavelengthTop,wavelengthBottom,binSize)
    
wavelengths = FullIrradiance(:,1);
tooLow = find(wavelengths < wavelengthBottom);
        FullIrradiance(tooLow,:) = [];
wavelengths = FullIrradiance(:,1);
toohigh = find(wavelengths > wavelengthTop);
        FullIrradiance(toohigh,:) = [];
        
IrradianceLimited = FullIrradiance;

%% Test to verify proper behavior
% bar(IrradianceLimited(:,2),IrradianceLimited(:,1),'r'); %Display the model for solar output
%     title('Model of Solar Output');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2/nm)');
%     axis auto
%{    
ratio = (binSize)/(10^-9);
area = ratio*sum(IrradianceLimited(:,1));
%}
end