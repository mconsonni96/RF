%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Tutorial 9 Matlab Script  %%%
%%% 1.5GHz LC oscillator Design %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear;

% Technology
Kn = 120e-6; 
Kp = 60e-6;
Lmin = 60e-9;
Vdd = 1.5;
Q = 20;
Fa = 1;
w0 = 2.*pi.*1.5e9;
T = 300;
Kb = physconst('Boltzmann');
dw = 2.*pi.*1e6;
Iss = 3e-3;
% Iss = linspace(10e-6,10e-3,1e3);

% design parameters
A0 = 0.9;
% A0 = linspace(0.1,1.5,1e3);
R = A0.*pi./(Iss.*4);
L = R./(w0.*Q);
C = 1./(w0.^2.*L);

% startup 
EGF = 5;
gm = EGF./R;
WL_n = (gm./2).^2./(0.5.*Kn.*Iss./2);
WL_p = (gm./2).^2./(0.5.*Kp.*Iss./2);
W_n = WL_n .* Lmin;
W_p = WL_p .* Lmin;

% Noise performances
Pdiss = Vdd.*Iss;
Pout = 0.5.*A0.^2./R;
eta = Pout./Pdiss;

ELL = 10.*log10(Kb.*T./Q.^2.*(w0./dw).^2.*Fa./(2.*eta.*Pdiss));
FoM = -ELL -10.*log10(Pdiss./1e-3)+20.*log10(w0./dw);

%% plot parameters vs A0 or vs Iss
figure(1); plot(Iss,eta);
figure(2); plot(Iss,FoM);
figure(3); plot(Iss,ELL);
figure(4); plot(Iss,R);
figure(5); plot(Iss,L);
figure(6); plot(Iss,C);







