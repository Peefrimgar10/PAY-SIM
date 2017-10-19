function [photonCountAtSensorDiscrete,photonCountAtSensor] = applyPhotonEnergy(FluxAtCCD, exposure)

%% Establish variables and universal constants
    h = 6.62606957*10.^-34; %J s
    c = 299792458; %m/s

    wavelength = FluxAtCCD(:,1)';
    spectralIrradiance = FluxAtCCD(:,2);
    
    for i = 1:length(wavelength)
    photonEnergies(i) = (h*c)/(wavelength(i)*10^-9);
    end
    
    for i = 1:length(photonEnergies)
        photonCountAtSensor(i,1) = (exposure*spectralIrradiance(i))/photonEnergies(i);
        photonCountAtSensorDiscrete(i,1) = floor(exposure*spectralIrradiance(i)/photonEnergies(i));
    end
    
    photonCountAtSensor(:,2) = wavelength';
    photonCountAtSensorDiscrete(:,2) = wavelength';
    
end