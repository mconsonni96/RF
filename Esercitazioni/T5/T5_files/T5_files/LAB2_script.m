%%%% LAB 2: PLL Design

clc; clear;

%%
% settings
tstop = 30; % [s]

% PLL parameters
dw = 0.1;   % [rad/s]
tau = 0.5;  % [s]
Kpd = 1;    % [V/rad]
Kvco = 1;   % [rad/s/V]
w0 = 1e3;   % [rad/s]
wfr = w0;   % [rad/s]

K = Kpd*Kvco;

% second order TF
omega_n = sqrt(K/tau);
zeta = 1/(2*sqrt(K*tau));
Q = 1/(2*zeta);

% Exercise 1: Settling Time:
omega_err = dw*1/100;
ts = 1/(zeta*omega_n)*log(dw/(omega_err*sqrt(1-zeta^2)));
% Case 1: K=1 tau = 0.5 ->  ts_sim = 4.6s; 
% Case 2: K=2 tau = 1 -> ts_theory = 9.4s;  ts_sim = 7.7s


% Exercise 2: 
% a) derive the frequency and the amplitude of the vtune ripple
% definition of Filter TF
H = @(x) 1./(1 + 1i.*x.*tau );

% plot |H(jw)|
figure(1); w = linspace(1e-2,1e2,1e3);
semilogx(w,20*log10(abs(H(w)))); 
ylim([-35 10]);
title('Filter TF');
xlabel('\omega [rad/s]');
ylabel('20 log_{10} ( |H(j\omega)| )');
grid on; grid minor;

% vtune ripple voltage evaluation:
Vripple = Kpd * abs(H(2*(w0+dw)));

% theory: frequency ripple = 2*(w0+dw) Vripple = 1mV
% simulation: check the plot -> same as theory

% b) lock range
% maximum Vpd = Kpd 
% From theory: wmax = wfr + Deltaw_lock_range 
% wmin = wfr - Deltaw_lock_range 
Deltaw_lock_range = Kpd*Kvco;

% Capture range: 
% wmax = wfr + Deltaw_capture_range
% wmin = wfr - Deltaw_capture_range

% input step
Deltaw_step = linspace(1e-2,1e2,1e3);
% capture range: the pll locks if Deltaw_out > Deltaw_step
Deltaw_out = Kpd * abs(H(Deltaw_step))*Kvco;

figure(2); 
semilogx(Deltaw_step, Deltaw_out-Deltaw_step); grid on; grid minor;
title('Capture Range [\Delta\omega_{out} - \Delta\omega_{in} > 0]');
xlabel('\Delta\omega in [rad/s]');
ylabel('\Delta\omega_{out} - \Delta\omega_{in}');
ylim([-15 10]);



%% Exercise 3: define the ripple on Vtune.
% definition of Fourier Series coefficients for Vpd(t)
Tr = (2*pi)/w0;
Vtune_steady_state = 0.1; % [V]
teps = Tr/(2*pi)*(pi/2-Vtune_steady_state); % from PD characteristic

D = (Tr/2-teps)/(Tr/2);
A0 = pi;
offset = -pi/2;

gamma0 = D*A0+offset;
gamma = @(n) D*A0*sin(pi*D*n)/(pi*D*n);


% Plot of the periodic signal Vpd(t)
% with Fourier Series coefficients
Ts = Tr/128;
t = 0:Ts:2*Tr;

% play with the nnharmonics parameters
nharmonics = 7;
Vtune = gamma0;
figure(3);
for i=1:nharmonics
    Vtunei = 2*gamma(i)*H(2*w0*i);
    Vtune = Vtune + abs(Vtunei) .*cos(2.*w0.*t.*i + angle(Vtunei));
    plot(t,Vtune); hold on;
end


plot(t,Vtune); grid on; grid minor;
xlabel('Time [s]');
ylabel('Amplitude [V]');
title('Vpd(t)')
legend('1 harmonic','2H','3H','4H','5H','6H','7H');
hold off;






