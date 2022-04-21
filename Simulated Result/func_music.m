function [Eig_Sum,error,J_music,Est_dloc_music] = func_music(r,P,sigma,t_indx,Inter_grid_gap,V,coords,d_loc,z_coord)
%% Input
% r -->> radii of brain
% P -->> number of dipoles
% sigma -->> volume conductor conductiivty
% t_indx -->> time snapshots
% Inter_grid_gap -->> scanning grid gap
% V -->> Potential data
% coords -->> sensor coordinates
% d_loc -->> dipole source location
% z_coord -->> searching axial plane 
%% Output
% Eig_Sum -->>  percentage or weightage of eigen values corresponding to true sources
% error -->>  root mean square error
% J_music -->>  cost function of MUSIC
% Est_dloc_music -->>  estimated dipole source location
%% Covariance matrix
Vnm = V;
h1 = length(Vnm(:,1));
r1 = zeros(h1,h1);
for i =1:t_indx
    r1 = r1 + (Vnm(:,i)*Vnm(:,i)');
end
R = r1/t_indx; % covariance matrix
% Extracting noise subspace
[REvec,REval] = eig(R); %REvec is eigenvector and REval is eigenvalue
[REval,Index] = sort(diag(REval),'descend'); % Sorted in descending order
Eig_Sum = (sum(REval(1:2)))/(sum(REval(1:end)))*100;              
REvec = REvec(:,Index);
rank = P;
E_n = REvec(:,rank+1:end); % noise eigen vectors
P_lrA = E_n*E_n'; % Noise Subspace
%% Scanning
z = z_coord;
x = -r:Inter_grid_gap:r; % search range fro x is defined from -r to +r
y = x;
for iz = 1:length(z)
    for ix = 1:length(x)
        for iy = 1:length(y)
            if (((x(ix)^2)+(y(iy)^2)+(z(iz)^2))<=r^2) % condition to check whether the point is inside the brain or not
                for i=1:length(coords)
                    [Gph(i,:)] = forward1(coords(:,i),[x(ix) y(iy) z(iz)]',sigma);
                end
                [U1,S1,V1] = svd(Gph,'econ');
                rot = U1'*P_lrA*U1;
                [rotvec,rotval] = eig(rot);
                [rotval,rotIndex] = sort(diag(rotval),'ascend'); % Sorted in descending order
                d = rotval(1); % minimum eigen value
                J_music(iz,ix,iy) = 1/d;  % min(d) is the minimum value of vector d i.e minimum eigen value of Fin
                disp([iz ix iy]);
            else
                J_music(iz,ix,iy) = 0;
                disp([iz ix iy]);
            end
        end
    end
end
J_music(J_music == 0) = NaN; % all the points outside the brain is alloted Nan
%% Peaks Finding
[ix,iy,star] = findhighestpeaks1(J_music,P,r);
loc1 = [ix;iy];
[error,Est_dloc_music] = rmse(d_loc,loc1);