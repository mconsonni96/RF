%--------------------------------------------------------------------------
% RF Circuit Design - T1
% Author: Prof. Salvatore Levantino
%--------------------------------------------------------------------------

% Raised Cosine Filter
N = 8;
R = 0.5;
ord = 256;
p = rcosdesign(R,ord/N,N,'normal');
k = ( -ord/2:1:ord/2 );

% Random Bit Sequence I/Q Signals
Nbit = 3000;
s = sign( rand( Nbit,1 )-0.5 );
I = s( 1:2:end );
Q = s( 2:2:end );
xI = conv( upsample( I, N ), p );
xQ = conv( upsample( Q, N ), p );
xI = xI( ord/2:end-ord/2-1 );
xQ = xQ( ord/2:end-ord/2-1 );

% BB saving
file_name='bb_id.txt';
save_data=[xI xQ];
save(file_name,'save_data','-ascii','-tabs')

%--------------------------------------------------------------------------
%                       Part II - LO Quadrature Error
%--------------------------------------------------------------------------

% Raised Cosine Filter
N = 8;
R = 0.5;
ord = 256;
p = rcosdesign(R,ord/N,N,'normal');
k = ( -ord/2:1:ord/2 );

% Random Bit Sequence I/Q Signals
Nbit = 3000;
s = sign( rand( Nbit,1 )-0.5 );
I = s( 1:2:end );
Q = s( 2:2:end );
xI = conv( upsample( I, N ), p );
xQ = conv( upsample( Q, N ), p );
xI = xI( ord/2:end-ord/2-1 );
xQ = xQ( ord/2:end-ord/2-1 );

% Quadrature Error Addition
theta = 10*pi/180;
xI = xI*cos( theta /2 ) - xQ*sin( theta /2 );
xQ = -xI*sin( theta /2 ) + xQ*cos( theta /2 );

% BB saving
file_name='bb_IQerror.txt';
save_data=[xI xQ];
save(file_name,'save_data','-ascii','-tabs')

%--------------------------------------------------------------------------
%                        Part III - LO Phase Noise
%--------------------------------------------------------------------------

% Raised Cosine Filter
N = 8;
R = 0.5;
ord = 256;
p = rcosdesign(R,ord/N,N,'normal');
k = ( -ord/2:1:ord/2 );

% Random Bit Sequence I/Q Signals
Nbit = 3000;
s = sign( rand( Nbit,1 )-0.5 );
I = s( 1:2:end );
Q = s( 2:2:end );
xI = conv( upsample( I, N ), p );
xQ = conv( upsample( Q, N ), p );
xI = xI( ord/2:end-ord/2-1 );
xQ = xQ( ord/2:end-ord/2-1 );

% Phase noise (1° RMS variance)
phi = 1 * pi/180 * randn( length(xI),1 );
xI = xI.*cos( phi ) + xQ.*sin( phi );
xQ = -xI.*sin( phi ) + xQ.*cos( phi );

% BB saving
file_name='bb_PN_1deg.txt';
save_data=[xI xQ];
save(file_name,'save_data','-ascii','-tabs')