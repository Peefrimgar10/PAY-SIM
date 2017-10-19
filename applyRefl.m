function [reflectedSpectrum] = applyRefl(specReflProfile,IrradianceLimited)
format long
%% Load in the actual data to be used:
percentReflected = specReflProfile(:,2);
Bands = specReflProfile(:,1);

solarOutput = IrradianceLimited(:,1);
Lam = IrradianceLimited(:,2);
[totalBands m] = size(Lam);

%% Apply the reflectivity curve to the Irradiance Model bin by bin:
    for i = 1:(totalBands - 1)
        x = find(Bands > Lam(i) & Bands < Lam(i+1));
        [n m] = size(x);
        if n == 1 %Exactly one match was found; multiply directly
            reflectedIrradiance(i) = (percentReflected(x))*solarOutput(i);
        elseif n > 1 %More than one match was found; take average then multiply
            avgSpecRefl = sum(percentReflected(x))/n;
            reflectedIrradiance(i) = avgSpecRefl*solarOutput(i);
        elseif isempty(x) == 1 %No matches were found; take average of surrounding values
            %Estimate potential values to fill in the gaps
            for j = i:(totalBands - 1)
                y = find(specReflProfile > Lam(j) & specReflProfile < Lam(j+1));
                [n m] = size(y);
                if n == 1 %Exactly one match was found; multiply directly
                    reflectedIrradiance(i) = (percentReflected(y))*solarOutput(i);
                    break
                elseif n > 1 %More than one match was found; take average then multiply
                    avgSpecRefl = sum(percentReflected(y))/n;
                    reflectedIrradiance(i) = avgSpecRefl*solarOutput(i);
                    break
                end

            end
        end
    end
    reflectedIrradiance(totalBands) = (specReflProfile(end))*solarOutput(totalBands);
    
reflectedSpectrum = [IrradianceLimited(:,2) reflectedIrradiance'];

%% Plot the reflected model as a test of results:

% subplot(2,2,1)
% bar(Lam, solarOutput,'r'); %Test the output
%     title('Model of Solar Output');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2)');
%     axis auto
%     xlim([400*10^-9 1100*10^-9])
%     set(gca, 'FontSize', 20)
% subplot(2,2,2)
% bar(Lam, reflectedIrradiance,'r'); %Test the output
%     title('Model of Reflected spectrum');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2)');
%     ylim([0 2])
%     xlim([400*10^-9 1100*10^-9])
%     
%     set(gca, 'FontSize', 20)
end