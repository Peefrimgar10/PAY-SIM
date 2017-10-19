function [specReflProfile] = processSpecReflProf(specReflProfile, wavelengthTop, wavelengthBottom)
format long
%% Identify the data that actually falls within our bounds:   
specReflWaveLengths = specReflProfile(:,1);

tooLow = find(specReflWaveLengths < wavelengthBottom);
    specReflProfile(tooLow,:) = [];

specReflWaveLengths = specReflProfile(:,1);
    
tooHigh = find(specReflWaveLengths > wavelengthTop);
    specReflProfile(tooHigh,:) = []; 
        
%% Generate the reflectivity curve:
percentReflected = .01*specReflProfile(:,2);

specReflProfile(:,2) = percentReflected;

end