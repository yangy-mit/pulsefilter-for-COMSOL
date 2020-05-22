function [Etenhance Atenhance f Efenhanceshift] = pulsefilter(t, E, FEname)
% This function takes an input pulse electric field waveform, and produces
% the electric field waveform, the envelope, the frequency vector, and the
% frequency-domain complex electric field, after enhancement induced by a
% nanostructure simulated in COMSOL. 
% 
% 
% Inputs:
%     t --> time vector of the input pulse (requires uniform spacing)
%     E --> input pulse electric field waveform
%     FEname --> filename of field enhancement csv file exported from 
%                COMSOL
% 
% Outputs:
%     Etenhance --> output pulse electric field waveform after field 
%                   enhancement
%     Atenhance --> output pulse envelope  
%     f --> frequency vector for frequency domain response, positive [Hz]
%     Efenhanceshift --> complex electric field in frequency domain (to get
%                        the correct spectral phase, the time domain 
%                        waveform is shifted, so that time t = 0 
%                        corresponds to the envelope peak and is at the 
%                        start of the time vector)
%
% Developed by: Yujia Yang, May 2020 
% 
% How to cite: please cite the following papers in any published work for
%              which you used this function or a modified version of it.
%
% (1) 	Yang, Y.; Turchetti, M.; Vasireddy, P.; Putnam, W. P.; Karnbach,
% O.; Nardi, A.; Kärtner, F. X.; Berggren, K. K.; Keathley, P. D. Light
% Phase Detection with On-Chip Petahertz Electronic Networks.
% arXiv:1912.07130 [physics] 2019.
% 
% (2) 	Keathley, P. D.; Putnam, W. P.; Vasireddy, P.; Hobbs, R. G.; Yang,
% Y.; Berggren, K. K.; Kärtner, F. X. Vanishing
% Carrier-Envelope-Phase-Sensitive Response in Optical-Field Photoemission
% from Plasmonic Nanoantennas. Nature Physics 2019, 15 (11), 1128–1133.
% https://doi.org/10.1038/s41567-019-0613-6.
% 
% (3) 	Putnam, W. P.; Hobbs, R. G.; Keathley, P. D.; Berggren, K. K.;
% Kärtner, F. X. Optical-Field-Controlled Photoemission from Plasmonic
% Nanoparticles. Nature Physics 2017, 13 (4), 335–339.
% https://doi.org/10.1038/nphys3978.
% 



L = length(t);                  % Signal length
dt = t(2)-t(1);                 % Time vector interval
Ts = dt;                        % Sampling period
Fs = 1/Ts;                      % Sampling frequency
dF = Fs/L;                      % Frequency vector interval
f = (-Fs/2:dF:Fs/2-dF)';        % Frequency vector

%% Fourier transform
Ef = fft(E);                    % Frequency domain electric field
Efshift = fftshift(Ef);         % Shift zero frequency to center
fshift = (-Fs/2:dF:Fs/2-dF);    % Shift zero frequency to center

%% Import field enhancement from tabulated data exported from COMSOL
FE = csvread(FEname,5,0);       % Field enhancement exported from COMSOL; 
                                % data starting from row 5; this line of 
                                % code can be changed depending on the data
                                % file format
wl = FE(:,1);                   % COMSOL wavelength
freq = FE(:,2);                 % COMSOL frequency
FEmag = FE(:,3);                % COMSOL field enhancement magnitude
FEphase = FE(:,4);              % COMSOL field enhancement phase
field = FEmag.*exp(1i*FEphase); % COMSOL complex field enhancement
% adding negative frequency part
freq2 = -flip(freq);
field2 = flip(conj(field));
% extrapolation using the grid defined by the frequency vector
fieldex1 = interp1(freq,field,fshift,'linear',0);   % linear interpolation
                                                    % and extrapolation, 
                                                    % field enhancement is 
                                                    % 0 for frequency 
                                                    % outside the COMSOL 
                                                    % simulated frequency 
                                                    % band
fieldex2 = interp1(freq2,field2,fshift,'linear',0);
fieldex = fieldex1 + fieldex2;

%% Filter with the field enhancement
Efenhance = Efshift.*fieldex;  % Field with enhancement in frequency domain

%% Inverse Fourier transform
Etenhance = ifft(fftshift(Efenhance));     % Field with enhancement in 
                                           % time domain

Etenhance = real(Etenhance);               % Remove the tiny imaginary part
                                           % caused by numerical artifacts

%% Pulse envelope using single-sided Fourier transform
Efshift_singleside = Efshift .* (fshift >= 0) * 2;
Efenhance_singleside = Efshift_singleside .* fieldex1;
Etenhance_singleside = ifft(fftshift(Efenhance_singleside));
Atenhance = abs(Etenhance_singleside);

%% Spectral response in frequency domain (positive and negative frequency)
[Amax, Amaxind] = max(Atenhance);    % Find max and argmax of envelope
Etenhanceshift = circshift(Etenhance,-Amaxind);   % Shift time-domain 
                                                  % waveform to get the 
                                                  % correct spectral phase
Efenhanceshift = fftshift(fft(Etenhanceshift));
f = fshift;
