clear all;
close all;
clc;
%% Parameters defined
theta_head = 2*pi/3;
N = 6;
r = 85; % radius in 'mm'
sigma = 0.33; % conductivity of medium Seimen/m
Inter_grid_gap = 1; % step size in mm
orient = 'R';
%% Sensor placement
coords = sensor_coords;
aray = [1 10 13 33 38 46 54 62]; % these channels were removed from the data. bad channels
coords(:,aray)=[];
I = length(coords);
load('erp_Kalyan_faceobject_S1.mat')
V = erp_Kalyan_faceobject_S1(:,:);
t_indx = length(V);
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
Coeff_head = getCoeff_hsph(H);
mult = H'*Coeff_head;
Vnm = mult*V;
%% Covariance matrix
%Vnm = V;
h1 = length(Vnm(:,1));
r1 = zeros(h1,h1);
for i =1:t_indx
    r1 = r1 + (Vnm(:,i)*Vnm(:,i)');
end
R = r1/t_indx;
%Extracting noise subspace
[REvec,REval] = eig(R); %REvec is eigenvector and REval is eigenvalue
[REval,Index] = sort(diag(REval),'descend'); % Sorted in descending order
REvec = REvec(:,Index);
Total = sum(abs(REval));
Perc=97.5; % 97% threshold is taken for determining the rank or number of sources which is unknown for real data
for i=1:length(REval)
    if(100*(sum(REval(1:i))/Total) > Perc)
        rank=i; % Rank is the number of significant eigen values
        break;
    end
end
E_n = REvec(:,rank+1:end); % noise eigen vectors
P_lrA = E_n*E_n'; % Noise Subspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot cost function plot
stps=150;
[xt,yt,zt]=sphere(stps); % creating a sphere with 150 steps
%xt = r*xt; yt = r*yt; zt = r*zt;
% But array length goes to stps+1 because it counts the start point twice
% whereas 'z' is sampled into 'stps+1'
in=zt(:,1); % a column of 'z'
indx=0;
for i=1:length(in)
    if(in(i)>=cos(theta_head)) % cos(2*pi/3) = - 0.5
        indx=i-1;
        break;
    end
end
% 'z' has first negative, then positive part
zt(1:indx,:)=[];
yt(1:indx,:)=[];
xt(1:indx,:)=[];
siz = size(zt);
count = 0;
c = cell([1,16]);
for R_temp = 10:5:85 % r and temp should be same
    count = count+1;
    for i=1:siz(1)
        for j=1:siz(2)
            x=xt(i,j); y=yt(i,j); z=zt(i,j);
            [J] = cost_music_head(x,y,z,P_lrA,coords,sigma,R_temp,mult);
            c{1,count}(i,j)=J(1);
        end
    end
end
az = zeros(100,151);
for i = 1:length(c)
    az = az+c{i}; % az represents summation of all J cost function at different radii
end
%% Plot of visual stimuli
figure;
h=surf(R_temp*xt,R_temp*yt,R_temp*zt,az);
set(h, 'FaceAlpha', 1);
gfigure('X axis','Yaxis','',gca);
zlabel(['Head MUSIC at ',num2str(R_temp)],'FontSize',30)
shading interp;
view([360 90 ]);
colorbar;
colormap jet