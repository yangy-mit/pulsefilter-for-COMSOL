function [E, A] = cos2pulse(t, fwhm, wc, phi_ce)
% COS2PULSE  Produce the electric field and intensity envelope (each 
% normalized to peak of 1) cos^2 shaped pulse. Units are set by the user
% (i.e. t, fwhm, wc all have to be consistent).  
%
% Inputs:
% ------------
%  t --> time 
%  fwhm --> full width at half max
%  wc --> central angular frequency (rad/unit time) 
%  phi_ce --> CEP 
%
% Outputs:
% ---------------
%  E --> Normalized field (peak of 1)
%  A --> Normalized intensity envelope (peak of 1)

% We can write a cos2 pulse intensity envelope
% as cos^4(alpha*t).  Then we have that:
alpha = 2*acos(2^(-0.25))/fwhm;

% We then calculate the envelope as being the cos2 pulse
% over the time window that we are in the positive half-cycle:
A = (abs(t) <= pi/2/alpha).*((cos(t*alpha)).^4);

%Finally, calculate the electric field:
E = sqrt(A).*cos(wc*t + phi_ce);

end
