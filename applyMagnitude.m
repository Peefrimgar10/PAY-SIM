function [wavelengthsAtSORA] = applyMagnitude(bandProportions,avgSpectralIrradiance)

wavelengthsAtSORA = [bandProportions(:,1) bandProportions(:,2)*avgSpectralIrradiance];

%% Test the outputs
% subplot(2,2,1)
% bar(wavelengthsAtSORA(:,1),wavelengthsAtSORA(:,2),'r'); %Display the model for solar output
%     title('Magnitude');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2)');
%     axis auto
%     xlim([400*10^-9 1100*10^-9])
%     
%     set(gca, 'FontSize', 20)

end