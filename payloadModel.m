function payloadModel(wavelengthTop, wavelengthBottom, binSize, apparentMagnitude, aperture, specReflProfile, sysEff, T, exposure)
format long
%% Read Empirical Solar Data
[TrueIrradiance] = SolarRead();

%% Limit Solar Irradiance Model to Desired Range:
[IrradianceLimited] = limitIrradiance(TrueIrradiance,wavelengthTop,wavelengthBottom,binSize);

%% New Magnitude Function, Applies Apparent Magnitude to Each Wavelength Across the Spectrum
[RelativeFlux] = relativeFlux(IrradianceLimited,apparentMagnitude);

%% Apply relative flux to the surface area of aperture.
[FluxAtLens] = applyAperture(RelativeFlux,aperture);

%% Apply System efficiency (include Grating, Lens, etc.)
%[wavelengthsAtSensor] = applySystemEfficiency(sysEff,wavelengthsAtLens);

%% Apply Grating Efficiency
[FluxAtCCD] = applyGrating(FluxAtLens);

%% Divide by Photon Energy:
[photonCountAtSensorDiscrete,photonCountAtSensor] = applyPhotonEnergy(FluxAtCCD, exposure);

%% Apply CCD Responsivity
[signal] = applyCCD(photonCountAtSensorDiscrete);

%% Apply Binning
[bins] = binningFunction(binSize,signal);

%% Find the Signal to Noise Ratio
[snrratio] = signalToNoiseFunc(bins,exposure,binSize)

%% Results
%The reults here represent the number of photons from each wavelength that
%actually get through the optical system and reach the sensor.  The goal is
%to determine an optical system (or an "average" optical system) and run
%this function MANY times, allowing the aperture to vary.  By comparing the
%results with what we need to obtain, we can detemrine the minimum size
%aperture we need, which is the important part for structures.

% subplot(2,1,2)
% h = subplot(2,1,2)
% bar(photonCountAtSensor(:,2),photonCountAtSensor(:,1),'r'); %Display the model for solar output
%     title(['Number of photons vs wavelength for Exposure = ', num2str(exposure),'s'],'FontSize', 25);
%     xlabel('Wavelength (m)','FontSize', 25);
%     ylabel('Number of photons','FontSize', 25);
%     axis auto
figure(1)
subplot(2,2,1)
bar(signal(:,1),signal(:,2),'r');
    title(['signal vs \lambda for ', num2str(exposure),'s'],'FontSize', 20);
    xlabel('Wavelength (nm)','FontSize', 25);
    ylabel('Signal (counts)','FontSize', 25);
    axis auto
subplot(2,2,2)
bar(photonCountAtSensorDiscrete(:,2),photonCountAtSensorDiscrete(:,1),'r'); %Display the model for solar output
    title(['photons vs \lambda for ', num2str(exposure),'s'],'FontSize', 20);
    xlabel('Wavelength (nm)','FontSize', 25);
    ylabel('Number of photons','FontSize', 25);
    axis auto
m = max(photonCountAtSensor(:,1));
find(photonCountAtSensor(:,1) == m);
photonCountAtSensor(15,2);

totalNumberOfPhotons = sum(photonCountAtSensor(:,1));

%set(figure(1), 'FontSize', 25)
%set(figure(2), 'FontSize', 25)
%set(h,'FontSize',25)

end
