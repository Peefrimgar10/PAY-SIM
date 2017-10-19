function [snrratio] = signalToNoiseFunc(bins,exposure,binSize)

Noise = sqrt((binSize/10)*((1.3827.*exposure)+55.014)^2); %Since by default, the diffraction grating bins
%into 10 nm per pixel, to find the number of pixels in each bin, divide bin
%size by 10 nm. Now apply gaussian noise, taking into account standard
%deviation by multiplying noise^2 by n number of pixels and taking the
%square root

for x = 1:length(bins)
    SNR(x) = bins(x)/(Noise);
end

snrratio = SNR;
figure(1)
subplot(2,2,4)
bar(1:length(bins),snrratio);
title('Signal to Noise Ratio per Bin');
xlabel('Wavelength (nm)');
ylabel('SNR');


figure(2);
bar(1:length(bins),snrratio);
title('Signal to Noise Ratio per Bin','FontSize', 15);
xlabel('Bin #','FontSize', 15);
ylabel('SNR','FontSize', 15);

end