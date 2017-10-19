
clc 
close all
clearvars

%Plot/Function Setup
setup = 1; %1 is OFF AXIS and 2 is ON AXIS
shape = 1; %1 is CIRCLE, 2 is SQUARE, 3 is RECTANGLE

bin_10 = 1;  bin_20 = 0;  bin_30 = 0;  bin_40 = 0;  bin_50 = 0;  bin_100 = 0;
exp_45_14 = 0; exp_45_13 = 0; exp_45_12 = 0; exp_45_11 = 0; exp_45_10 = 0;
exp_240_14 = 0; exp_240_13 = 0; exp_240_12 = 0; exp_240_11 = 0; exp_240_10 = 0;
exp_300_14 = 0; exp_300_13 = 0; exp_300_12 = 0; exp_300_11 = 0; exp_300_10 = 0;
wav_14 = 0; wav_13 = 0; wav_12 = 0; wav_11 = 0; wav_10 = 0;

if bin_10
%10 nm binning
mirrorsizemod(1.5,2,700,350,10,1,.9,550,30,8.5,1,shape,setup); 
mirrorsizemod(1.5,2,700,350,10,1,.9,550,25,8.5,1,shape,setup); 
mirrorsizemod(1.5,2,700,350,10,1,.9,550,15,8.5,1,shape,setup);
end

if bin_20
%20 nm binning
mirrorsizemod(1.5,2,700,350,25,.9,1,550,30,6.5,1,shape,setup);
mirrorsizemod(1.5,2,700,350,25,.9,1,550,30,6,1,shape,setup);
mirrorsizemod(1.5,2,700,350,25,.9,1,550,30,7,1,shape,setup);
end

if bin_30
%30 nm binning
mirrorsizemod(1.5,2,700,350,35,.90,1,550,30,6.5,1,shape,setup);
mirrorsizemod(1.5,2,700,350,35,.90,1,550,30,6,1,shape,setup);
mirrorsizemod(1.5,2,700,350,35,.90,1,550,30,7,1,shape,setup);
end

if bin_40
%40 nm binning
mirrorsizemod(1.5,2,700,350,40,.9,1,550,30,6.5,1,shape,setup);
mirrorsizemod(1.5,2,700,350,40,.9,1,550,30,6,1,shape,setup);
mirrorsizemod(1.5,2,700,350,40,.9,1,550,30,7,1,shape,setup);
end

if bin_50
%50 nm binning
mirrorsizemod(1.5,2,700,350,50,.9,1,550,30,6.5,1,shape,setup);
mirrorsizemod(1.5,2,700,350,50,.9,1,550,30,6,1,shape,setup);
mirrorsizemod(1.5,2,700,350,50,.9,1,550,30,7,1,shape,setup);
end

if bin_100
%100 nm binning
mirrorsizemod(1.5,2,700,350,100,.85,.85,550,30,14.35,1,shape,setup);
mirrorsizemod(1.5,2,700,350,100,.85,.85,550,100,14.35,1,shape,setup);
mirrorsizemod(1.5,2,700,350,100,.85,.85,550,240,14.35,1,shape,setup);
end


%differing exposure times (0-45 seconds) mag 14
if exp_45_14
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,45,14,2,shape,setup);
end

%differing exposure times (0-45 seconds) mag 13 
if exp_45_13
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,45,13,2,shape,setup);
end

%differing exposure times (0-45 seconds) mag 12
if exp_45_12
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,45,12,2,shape,setup);
end

%differing exposure times (0-45 seconds) mag 11
if exp_45_11
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,45,11,2,shape,setup);
end

%differing exposure times (0-45 seconds) mag 10
if exp_45_10
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,45,10,2,shape,setup);
end

%differing exposure times (0-240 seconds) mag 14
if exp_240_14
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,240,14,2,shape,setup);
end

%differing exposure times (0-240 seconds) mag 13 
if exp_240_13
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,240,13,2,shape,setup);
end

%differing exposure times (0-240 seconds) mag 12
if exp_240_12
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,240,14,2,shape,setup);
end

%differing exposure times (0-240 seconds) mag 11
if exp_240_11
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,240,13,2,shape,setup);
end

%differing exposure times (0-240 seconds) mag 10
if exp_240_10
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,240,14,2,shape,setup);
end

%differing exposure times (0-300 seconds) mag 14
if exp_300_14
mirrorsizemod(1.5,2,700,350,10,.9,1,550,450,14,2,shape,setup);
end

%differing exposure times (0-300 seconds) mag 13
if exp_300_13
mirrorsizemod(1.5,2,700,350,10,.9,1,550,450,13,2,shape,setup);
end

%differing exposure times (0-300 seconds) mag 12
if exp_300_12
mirrorsizemod(1.5,2,700,350,10,.9,1,550,450,12,2,shape,setup);
end

%differing exposure times (0-300 seconds) mag 11
if exp_300_11
mirrorsizemod(1.5,2,700,350,10,.9,1,550,450,11,2,shape,setup);
end

%differing exposure times (0-300 seconds) mag 10
if exp_300_10
mirrorsizemod(1.5,2,700,350,10,.9,1,550,450,10,2,shape,setup);
end

% Range of wavelengths and magnitudes VARIABLE (just change it manually)
% exposure time mag 14
if wav_14
mirrorsizemod(1.5,2,1100,350,10,.85,.85,550,30,14.35,3,shape,setup);
end

%mag 13
if wav_13
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,30,13,3,shape,setup);
end

%mag 12
if wav_12
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,30,12,3,shape,setup);
end

%mag 11
if wav_11
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,30,11,3,shape,setup);
end

%mag 10
if wav_10
mirrorsizemod(1.5,2,700,350,10,.85,.85,550,30,10,3,shape,setup);
end








