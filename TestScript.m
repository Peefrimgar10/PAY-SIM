%% Plot Solar Data:
% data = csvread('csv files/Solar Data.csv');
% w = data(:,1);
% v = data(:,2);
% scatter(w,v,'.')
%     title('Solar Output Data');
%     xlabel('Wavelength (m)');
%     ylabel('Spectral Irradiance (W/m^2/nm)');
%         xlim([0 2500*10^-9]);
%         ylim([0 2.5]);
%% Plot Spectral Reflectivity Profile of Aluminum:
% data = csvread('csv files/Aluminum Spectral Data.csv'); 
% x = data(:,1);
% y = data(:,2);
% subplot(2,1,1)
%     scatter(x,y,'.')
%     title('Aluminum Spectral Reflectivity Profile');
%     xlabel('Wavelength (m)');
%     ylabel('Amount Reflected (%)');
%         xlim([0 2500*10^-9]);
%         ylim([80 100]);
        
%% Plot Sample Efficiency Curve:
% data = csvread('csv files/SampleSysEff.csv');
% x = data(:,1);
% y = 100*data(:,2);
% subplot(2,1,1)
% scatter(x,y,'.')
%     title('Sample Effiency Data');
%     xlabel('Wavelength (m)');
%     ylabel('Effiency (%)');
% 
% set(gca, 'FontSize', 25)

std_dev = .15;
mean = 1
x = -6+mean:.01:6+mean;
y = (std_dev*sqrt(2*pi))^-1*exp(-.5*((x-mean)/std_dev).^2);
plot(x,y);
xlim([-6+mean 6+mean]);
ylim([0 .5]);
trapz(x,y) ; % To check the area under the curve