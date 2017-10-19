%% payloadModelTest
%Run this script to actually call the payloadModel with specific inputs.
%The end goal will be to use this script to run the payloadModel with a
%wide range of apertures, to provide us with the ability to compare
%aperture size/optical performance with the ability to perform the mission.
clc
close all
clear

%% The Model's current run setup:
wavelengthTop = 900; %highest wavelength we're observing nm

wavelengthBottom = 350; %lowest wavelength we're observing nm

binSize = 25; %bin size of optical system in nm *initially in m
bin = 25; %bin size for aperture

eff1 = 1; %set to 1 for lens, 0.85 for mirror

eff2 = 0.9; %set to 0.9 for lens, 0.85 for mirror

apparentMagnitude = 7.3; %apparent magnitude of target
appmag = 8.3;

setup = 1; %1 = off axis, 2 = on axis, when simulating lens use setup 1

exposure = 67; %The exposure time in seconds
exposureoptics = 13.4; %Exposure time for aperture calculation

aperture = OpticalFeed(1.5,2,wavelengthBottom,wavelengthTop,bin,eff1,eff2,550,exposureoptics,appmag,setup);
%Diameter opening in cm.  This will later be a range of values (MAYBE).
%do not alter anything above except 
specReflProfile = csvread('csv files/Aluminum Spectral Data.csv'); %This is the directory to the target's reflectivityprofile

sysEff = csvread('csv files/SampleSysEff.csv');

T = 5778; %K  (Temperature of the sun)
%% Run the payloadModel with the desired input data:
payloadModel(wavelengthTop, wavelengthBottom, binSize, apparentMagnitude, aperture, specReflProfile, sysEff, T, exposure)
