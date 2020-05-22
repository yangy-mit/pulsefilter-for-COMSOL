clear;
clc;
close all;

%%Plot Setup%%
format compact;
format short g;
more on;

FontSize = 15;    %12
LineWidth = 2;  %1

set(0, 'DefaultTextFontSize', FontSize);
set(0, 'DefaultAxesFontSize', FontSize);
set(0, 'DefaultAxesFontName', 'Verdana');
set(0, 'DefaultAxesLineWidth', LineWidth);
set(0, 'DefaultAxesTickLength', [0.02 0.025]);
set(0, 'DefaultAxesBox', 'on');
set(0, 'DefaultLineLineWidth', LineWidth);
set(0, 'DefaultLineMarkerSize', 5);
set(0, 'DefaultPatchLineWidth', LineWidth);
set(0, 'DefaultFigureColor', [1 1 1]);
set(0, 'DefaultFigurePaperPosition',[2.65 4.3 3.2 2.4]);
set(0, 'DefaultFigurePosition', [800 500 360 270])
% 360x260 pixels on screen keeps same aspect ratio as 3.2x2.4 printed
set(0, 'DefaultFigurePosition', [300 100 720 540])
set(0, 'DefaultFigureDockControls', 'off')
%%Plot Setup%%

% physical constants
c_const = 299792458;    % speed of light

% generate incident electric field waveform 
fwhm = 10e-15;  % 10 fs FWHM pulse duration
lam = 1177e-9;  % 1177 nm central wavelength
L = 5000;       % lenght of signal
t = linspace(-100e-15,100e-15,L);   % time vector
fc = c_const/lam;   % central frequency
wc = 2*pi*fc;       % central angular frequency
phi_ce = 0;         % pulse carrier-envelope-phase (CEP)
[E, A] = cos2pulse(t, fwhm, wc, phi_ce);    % incident cos^2 shaped pulse

% calculate enhanced waveforms from COMSOL simulation results; this example
% compares the effect of 5 different COMSOL models; the last one
% corresponds to propagation in vacuum and is considered as the incident
% pulse
FEname = 'ET016aDose8ArrayC_wire_x';
FEname200 = 'ET016aDose8ArrayC_wire_x200_normalE';
[Etenhance200 At200 f200 Ef200] = pulsefilter(t, E, [FEname200 '.csv']);
FEname120 = 'ET016aDose8ArrayC_wire_x120_normalE';
[Etenhance120 At120 f120 Ef120] = pulsefilter(t, E, [FEname120 '.csv']);
FEname50 = 'ET016aDose8ArrayC_wire_x50_normalE';
[Etenhance50 At50 f50 Ef50] = pulsefilter(t, E, [FEname50 '.csv']);
FEname00 = 'ET016aDose8ArrayC_nowire_normalE';
[Etenhance00 At00 f00 Ef00] = pulsefilter(t, E, [FEname00 '.csv']);
FEnamevac = 'ET016aDose8ArrayC_wire_vacuum_normalE';
[Etvac Atvac fvac Efvac] = pulsefilter(t, E, [FEnamevac '.csv']);

% spectral response (magnitude)
Ef200mag = abs(Ef200);
Ef120mag = abs(Ef120);
Ef50mag = abs(Ef50);
Ef00mag = abs(Ef00);
Efvacmag = abs(Efvac);

% spectral response (phase)
Ef200phase = angle(Ef200);
Ef120phase = angle(Ef120);
Ef50phase = angle(Ef50);
Ef00phase = angle(Ef00);
Efvacphase = angle(Efvac);

% additional plotting parameters
t = t/1e-15;    % [s] --> [fs]
plotlinewidth = 1.5;

% plot results
figure()    % plot enhanced electric field waveforms with offsets in y
offset = 40;
plot(t,Etenhance200 + 3*offset,'LineWidth',plotlinewidth);xlim([-20 60]);ylim([-60 150]);
xlabel('time (fs)');ylabel('optical near-field (arb. unit)');
hold on;
plot(t,Etenhance120 + 2*offset,'LineWidth',plotlinewidth);
plot(t,Etenhance50 + offset,'LineWidth',plotlinewidth);
plot(t,Etenhance00,'LineWidth',plotlinewidth);
plot(t,Etvac*10 - offset, 'k', 'LineWidth',plotlinewidth);

figure()    % plot normalized enhanced electric field waveforms
plot(t,Etenhance200/max(abs(Etenhance200)),'LineWidth',plotlinewidth);xlim([-40 60]);ylim([-1.2 1.8]);
xlabel('time (fs)');ylabel('normalized electric field (arb. unit)');
hold on;
plot(t,Etenhance120/max(abs(Etenhance120)),'LineWidth',plotlinewidth);
plot(t,Etenhance50/max(abs(Etenhance50)),'LineWidth',plotlinewidth);
plot(t,Etenhance00/max(abs(Etenhance00)),'LineWidth',plotlinewidth);
plot(t,Etvac/max(Etvac),'k','LineWidth',plotlinewidth);
legend('X_w_i_r_e = 200 nm','X_w_i_r_e = 120 nm', ...
    'X_w_i_r_e = 50 nm','bow-tie only','incident pulse');

figure()    % plot 1 normalized waveform; CEP is labeled (from manual
            % measurement)
plot(t,Etvac/max(abs(Etvac)),'k','LineWidth',plotlinewidth);
xlabel('time (fs)');ylabel('normalized electric field (arb. unit)');
xlim([-40 60]);ylim([-1.2 1.8]);
hold on;
plot(t,Atvac/max(Atvac),'k--','LineWidth',plotlinewidth);
text(-35,0.2,'incident','Color','k');
text(0,1.2,'CEP = 0 rad (0°)','Color','k','FontSize',20);

figure()    % plot 1 normalized waveform; CEP is labeled (from manual
            % measurement)
corder = get(gca,'colororder');
plot(t,Etenhance200/max(abs(Etenhance200)),'color',corder(1,:),'LineWidth',plotlinewidth);
xlabel('time (fs)');ylabel('normalized electric field (arb. unit)');
xlim([-40 60]);ylim([-1.2 1.8]);
hold on;
plot(t,At200/max(At200),'--','color',corder(1,:),'LineWidth',plotlinewidth);
text(-35,0.2,'X_w_i_r_e= 200 nm','Color',corder(1,:));
text(0,1.2,'CEP = -0.36\pi rad (-64.8°)','Color',corder(1,:),'FontSize',20);

figure()    % plot 1 normalized waveform; CEP is labeled (from manual
            % measurement)
plot(t,Etenhance120/max(abs(Etenhance120)),'color',corder(2,:),'LineWidth',plotlinewidth);
xlabel('time (fs)');ylabel('normalized electric field (arb. unit)');
xlim([-40 60]);ylim([-1.2 1.8]);
hold on;
plot(t,At120/max(At120),'--','color',corder(2,:),'LineWidth',plotlinewidth);
text(-35,0.2,'X_w_i_r_e= 120 nm','Color',corder(2,:));
text(0,1.2,'CEP = -0.14\pi rad (-25.2°)','Color',corder(2,:),'FontSize',20);

figure()    % plot 1 normalized waveform; CEP is labeled (from manual
            % measurement)
plot(t,Etenhance50/max(abs(Etenhance50)),'color',corder(3,:),'LineWidth',plotlinewidth);
xlabel('time (fs)');ylabel('normalized electric field (arb. unit)');
xlim([-40 60]);ylim([-1.2 1.8]);
hold on;
plot(t,At50/max(At50),'--','color',corder(3,:),'LineWidth',plotlinewidth);
text(-35,0.2,'X_w_i_r_e= 50 nm','Color',corder(3,:));
text(0,1.2,'CEP = -1.33\pi rad (-239.4°)','Color',corder(3,:),'FontSize',20);

figure()    % plot 1 normalized waveform; CEP is labeled (from manual
            % measurement)
plot(t,Etenhance00/max(abs(Etenhance00)),'color',corder(4,:),'LineWidth',plotlinewidth);
xlabel('time (fs)');ylabel('normalized electric field (arb. unit)');
xlim([-40 60]);ylim([-1.2 1.8]);
hold on;
plot(t,At00/max(At00),'--','color',corder(4,:),'LineWidth',plotlinewidth);
text(-35,0.2,'bow-tie only','Color',corder(4,:));
text(0,1.2,'CEP = -0.35\pi rad (-63°)','Color',corder(4,:),'FontSize',20);

figure()    % plot spectral magnitude
plot(f200,Ef200mag,'LineWidth',plotlinewidth);
xlim([150e12 350e12]);
xlabel('frequency (Hz)');ylabel('spectrum (arb. unit)');
hold on;
plot(f120,Ef120mag,'LineWidth',plotlinewidth);
plot(f50,Ef50mag,'LineWidth',plotlinewidth);
plot(f00,Ef00mag,'LineWidth',plotlinewidth);
plot(fvac,Efvacmag,'k','LineWidth',plotlinewidth);
legend('X_w_i_r_e = 200 nm','X_w_i_r_e = 120 nm', ...
    'X_w_i_r_e = 50 nm','bow-tie only','incident pulse');

figure()    % plot normalized spectral magnitude
plot(f200,Ef200mag/max(Ef200mag),'LineWidth',plotlinewidth);
xlim([150e12 350e12]);
ylim([0 1.4]);
xlabel('frequency (Hz)');ylabel('normalized spectrum (arb. unit)');
hold on;
plot(f120,Ef120mag/max(Ef120mag),'LineWidth',plotlinewidth);
plot(f50,Ef50mag/max(Ef50mag),'LineWidth',plotlinewidth);
plot(f00,Ef00mag/max(Ef00mag),'LineWidth',plotlinewidth);
plot(fvac,Efvacmag/max(Efvacmag),'k','LineWidth',plotlinewidth);
legend('X_w_i_r_e = 200 nm','X_w_i_r_e = 120 nm', ...
    'X_w_i_r_e = 50 nm','bow-tie only','incident pulse','Location','Northwest');

figure()    % plot spectral phase
plot(f200,Ef200phase,'LineWidth',plotlinewidth);
xlim([150e12 350e12]);
ylim([-4 8]);
xlabel('frequency (Hz)');ylabel('spectral phase (rad)');
hold on;
plot(f120,Ef120phase,'LineWidth',plotlinewidth);
plot(f50,Ef50phase,'LineWidth',plotlinewidth);
plot(f00,Ef00phase,'LineWidth',plotlinewidth);
plot(fvac,Efvacphase,'k','LineWidth',plotlinewidth);
legend('X_w_i_r_e = 200 nm','X_w_i_r_e = 120 nm', ...
    'X_w_i_r_e = 50 nm','bow-tie only','incident pulse','Location','Northwest');
