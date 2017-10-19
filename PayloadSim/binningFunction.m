function [bins] = binningFunction(binSize,signal)

Lam = signal(:,1);
Signal = signal(:,2);

% for x = 1:binSize:length(Lam)
%     binlimit(x) = Lam(x);
% end
% 
% for x = 1:length(binlimit)
%     binheretoolong = Signal(binlimit(x):binlimit(x+1));
%     bins(x) = sum(Signal(binheretoolong));
% end
% 
% bins = bins
% 
% end
[n, m] = size(Lam(1):binSize:Lam(end));
bins = zeros(m,n);
binnedLam = zeros(m,n);

for i = 1:m-1
    j = (i-1)*binSize;
    bins(i) = sum(Signal(j+1:j+binSize));
    binnedLam(i) = mean(Lam(j+1:j+binSize));
end
%{
binSizetemp = 50;
[n, m] = size(Lam(1):binSizetemp:Lam(end));
bins2 = zeros(m,n);
binnedLam2 = zeros(m,n);

for i = 1:m-1
    j = (i-1)*binSizetemp;
    bins2(i) = sum(Signal(j+1:j+binSizetemp));
    binnedLam2(i) = mean(Lam(j+1:j+binSizetemp));
end

[n m] = size(bins)
[x y] = size(binnedLam)
%}
subplot(2,2,3)
bar(binnedLam,bins)
    title('Signal Per Bin')
    xlabel('wavelengths (nm)')
    ylabel('Binned signal counts')
    xlim([300 1000])
    
%{
subplot(2,2,4)
bar(binnedLam2,bins2)
    title('Signal Per Bin')
    xlabel('wavelengths (nm)')
    ylabel('Binned signal counts')
    xlim([300 1000])
%}
