function [RelativeFlux] = relativeFlux(IrradianceLimited,apparentMagnitude)

Lam = transpose(IrradianceLimited(:,1));
Flux = IrradianceLimited(:,2)';
logfactor = nthroot(100,5);

for x = 1:length(Lam)
    MagnitudeRad(x) = Flux(x)*logfactor.^(-26.74-(apparentMagnitude));
end

RelativeFlux = [IrradianceLimited(:,1) transpose(MagnitudeRad)]