function [filteredEMG] = filterRawEMG(rawEMG, fs)
	fn=fs/2;    %Hz - Nyquist Frequency - 1/2 Sampling Frequency
	[B,A]= butter(3,[10,479]/fn);
	filteredEMG = zeros(size(rawEMG,1),size(rawEMG,2));
	filteredEMG(:, 2:end)=filtfilt(B, A, rawEMG(:, 2:end));
	filteredEMG(:,1) = rawEMG(:, 1);
	clear A B