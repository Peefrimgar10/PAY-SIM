function [FluxAtCCD] = applyGrating(FluxAtLens)

Lam = transpose(FluxAtLens(:,1));

for x = 1:length(Lam)
    GratFlux(x) = (grating3(Lam(x))/100).*FluxAtLens(x,2);
end

 FluxAtCCD = [FluxAtLens(:,1) transpose(GratFlux)];

end