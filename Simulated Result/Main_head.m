clear all;
close all;
clc;
%%
SNR = 5;
Var_mean = 97; %
Iter = 1; % Number of iteration
%% Parameters defined
r = 85; % radius of brain from origin in 'mm'
Inter_grid_gap = 1; % step size
sigma = 0.33; % conductivity of medium Seimen/m
t_indx = 200; % Number of snapshots
N = 6; % Head Harmonics order
orientation = 'R'; % represent radial orientationo of pyramidal neurons
%% Parameters
Root_error_music = [];
Root_error_music_head = [];
%% Generating signals
signal = @(m,std)(exp(-0.5*((((1:t_indx) - m)./std).^2))); % 
S=[signal(50,20); signal(Var_mean,20)]; %zeros(1,100)]; %signal(68,12.5)]; % signal(70,10)];
corr=(S(1,:)*S(2,:)')/((norm(S(1,:))*norm(S(2,:)))); % correlation of two dipole waveform. Change the correlation by changing the var_mean value 
P = length(S(:,t_indx)); % number of dipoles
%% Sensor placement
coords = sensor_coords; % Calling function for getting sensor coordinates as 3x63,leaving the ground at fpz
coords(:,[5 10 21 26])=[]; % FT9, FT10, TP9 and TP10 have been removed from sensor coords.
I = length(coords); % total 59 sensor coords
%% Source information
z_coord = 20; % Source placed at z=20mm
d_loc = [13,30,z_coord; -13,-30,z_coord]'; % Active dipole location
%% Defining theta and phi of sensors placed over scalp.
% sensors places over hemisphere has theta = [0,pi/2] & phi = [-pi,pi]
for i=1:I
    x = coords(1,i);
    y = coords(2,i);
    z = coords(3,i);
    theta(i) = acos(z/r); % acos(_) entire range is [0,pi] but [0,pi/2] theta value occur only for our hemisphere case
    if(x==0 && y ==0)
        phi(i)=0;
    else
        %phi(i)=atan(y/x);  % problem being, the range [-pi/2, pi/2]
        phi(i)=atan2(y,x); % atan2(Y,X), returns values in the closed interval [-pi,pi]
    end
end
H = Head_Basis(I,N,theta,phi);
Tau = getCoeff_hsph(H); % coefficient matrix
mult_head = H'*Tau;
%% Forward data model
% G is called gainfield matrix of dimension I x3P. V = GD
% D is dipole moment matrix of dimension 3P x Ns. D = MS, V = GMS
% M is unit orientation moment matrix of dimension 3P x P
% S is moment intensity matrix i.e signal matrix
[G,D,M] = forward(coords,d_loc,sigma,S,orientation);
A = G*M; % A = GM, V=AS
V = A*S;
for i = 1:Iter
%% Adding noise
Rs = (V*V')/t_indx;
np=max(max(Rs))/(10^(SNR/10));
V=A*S+sqrt(np)*randn(size(V));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Eig_Sum,error,J_music,Est_dloc_music] = func_music(r,P,sigma,t_indx,Inter_grid_gap,V,coords,d_loc,z_coord);
Root_error_music = [Root_error_music,error];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Eig_Sum_head,error,J_music_head,Est_dloc_music_head] = func_music_head(r,P,sigma,t_indx,Inter_grid_gap,V,coords,d_loc,z_coord,mult_head);
Root_error_music_head = [Root_error_music_head,error];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
Error_music = mean(Root_error_music);
Error_music_head = mean(Root_error_music_head);
%% final plots of the algorithm
fu = -r;
[X,Y] = meshgrid(fu:Inter_grid_gap:r,fu:Inter_grid_gap:r);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J_music(J_music == 0) = NaN;
figure
surf(X,Y,shiftdim(J_music))
shading interp;
colormap HSV
gfigure('X axis','Yaxis','',gca);
zlabel(['Spatial MUSIC at ',num2str(SNR),' dB'],'FontSize',30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J_music_head(J_music_head == 0) = NaN;
figure
surf(X,Y,shiftdim(J_music_head))
shading interp;
colormap HSV
gfigure('X axis','Yaxis','',gca);
zlabel(['Head MUSIC at ',num2str(SNR),' dB'],'FontSize',30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J_music(J_music == 0) = NaN;
figure
surf(X,Y,shiftdim(J_music))
shading interp;
colormap HSV
gfigure('X axis','Yaxis','',gca);
view(0,90)
zlabel(['Spatial MUSIC at ',num2str(SNR),' dB'],'FontSize',30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J_music_head(J_music_head == 0) = NaN;
figure
surf(X,Y,shiftdim(J_music_head))
shading interp;
colormap HSV
gfigure('X axis','Yaxis','',gca);
view(0,90)
zlabel(['Head MUSIC at ',num2str(SNR),' dB'],'FontSize',30)
