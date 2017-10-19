function [FullIrradiance] = applySolarConstant(proportionedWavelengths,Lam,binSize)

ratio = (binSize)/(10^-9);

FullIrradiance(:,1) = 1367.7*proportionedWavelengths/ratio;
FullIrradiance(:,2) = Lam;
    
% bar(Lam,FullIrradiance(:,1),'r'); %Display the model for solar output
%     title('Model of Solar Output');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2/nm)');
%         ylim([0 2.5]);
%         xlim([0 2500*10^-9]);
        
end