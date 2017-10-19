function [wavelengthsAtSensor] = applySystemEfficiency(sysEff,wavelengthsAtLens)

efficiency = sysEff(:,2);
Bands = sysEff(:,1);

wavelengths = wavelengthsAtLens(:,2);
Lam = wavelengthsAtLens(:,1);

[totalBands m] = size(Lam);

%% Apply the System Efficiency Data to the wavelengths Model bin by bin:
    for i = 1:(totalBands - 1)
        x = find(Bands > Lam(i) & Bands < Lam(i+1));
        [n m] = size(x);
        if n == 1 %Exactly one match was found; multiply directly
            wavelengthsAtSensor(i) = (efficiency(x))*wavelengths(i);
        elseif n > 1 %More than one match was found; take average then multiply
            avgEff = sum(efficiency(x))/n;
            wavelengthsAtSensor(i) = avgEff*wavelengths(i);
        elseif isempty(x) == 1 %No matches were found; take average of surrounding values
            %Estimate potential values to fill in the gaps
            for j = i:(totalBands - 1)
                y = find(sysEff > Lam(j) & sysEff < Lam(j+1));
                [n m] = size(y);
                if n == 1 %Exactly one match was found; multiply directly
                    wavelengthsAtSensor(i) = (efficiency(y))*wavelengths(i);
                    break
                elseif n > 1 %More than one match was found; take average then multiply
                    avgEff = sum(efficiency(y))/n;
                    wavelengthsAtSensor(i) = avgEff*wavelengths(i);
                    break
                end
            end
        end
    end
    wavelengthsAtSensor(totalBands) = (sysEff(end))*wavelengths(totalBands);
    
wavelengthsAtSensor = [Lam wavelengthsAtSensor'];

%% Test the outputs
% subplot(2,2,2)
% bar(wavelengthsAtSensor(:,1),wavelengthsAtSensor(:,2),'r'); %Display the model for solar output
%     title('Filtering');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2)');
%     axis auto
%     xlim([400*10^-9 1100*10^-9])
%     
%     set(gca, 'FontSize', 20)

end
