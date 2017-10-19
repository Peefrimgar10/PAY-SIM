function [scaledOutput] = applyLuminosity(proportionedWavelengths,Lum,Rad,starsOutputWavelengths,wavelengthTop,wavelengthBottom,binSize)
%% Determine the amount of flux that actually reaches the earth (given the stars distance and it's luminosity)   
fluxAtEarth = Lum/(4*pi*(Rad.^2));

%% Apply the flux at earth to the whole black body spectrum
scaledOutputTemp = fluxAtEarth*starsOutputWavelengths;
Lam = [binSize:binSize:(2600*10^-9)];

input = [scaledOutputTemp' Lam'];

[IrradianceLimited] = limitIrradiance(input,wavelengthTop,wavelengthBottom,binSize);

values = IrradianceLimited(:,1);
scale = sum(values);

scaledOutput = scale*proportionedWavelengths;
end