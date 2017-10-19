function [FluxAtLens] = applyAperture(RelativeFlux,aperture)

areaOfLens = pi*((aperture./(2*100)).^2);
FluxAtLens = [RelativeFlux(:,1) areaOfLens*RelativeFlux(:,2)];

end