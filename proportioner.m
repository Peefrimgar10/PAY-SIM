function [bandProportions] = proportioner(reflectedSpectrum)
format long

%% Determine the proportion of each wavelength reflected:
    IrradianceValues = reflectedSpectrum(:,2);
    Lam = reflectedSpectrum(:,1);
    
    totalArea = sum(IrradianceValues);
    
    [n m] = size(IrradianceValues);
    for i = 1:n
        bandProportions(i) = IrradianceValues(i)/totalArea;
    end
    
    bandProportions = [Lam bandProportions'];
    
    
%% Plot the proportion model as a test of results:

% bar(Lam, bandProportions(:,2),'r'); %Test the output
%     title('Proportionate "amount" of each wavelength');
%     xlabel('Wavelength (m)');
%     ylabel('Amount (%)');
%     axis auto
end
