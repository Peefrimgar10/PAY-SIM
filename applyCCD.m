function [signal] = applyCCD(photonCountAtSensorDiscrete)

Lam = photonCountAtSensorDiscrete(:,2)';
photons = photonCountAtSensorDiscrete(:,1);

for x = 1:length(Lam)
    counts(x) = photons(x,1)/CCDResponse(Lam(x));
end

signal = [Lam' counts'];
end