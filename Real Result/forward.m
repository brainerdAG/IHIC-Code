function [G,D,M] = forward(coords,d_loc,sigma,S,orient)
%% Input
% coords are sensor location
% d_loc is source location
% sigma is head conductivity
% S is source signal intensity matrix
% orient is source orientation
%% Output
% G is called gainfield matrix of dimension I x3P. V = GD
% D is dipole moment matrix of dimension 3P x Ns. D = MS, V = GMS
% M is unit orientation moment matrix of dimension 3P x P
P = length(d_loc(1,:));
I = size(coords,2);
G = [];
for i = 1:P
    g_p = [];
    for j = 1:I
        b(1,:) = (coords(:,j)-d_loc(:,i))/(4*pi*sigma*((norm(coords(:,j)-d_loc(:,i)))^3));
        g_p = [g_p; b];
    end
    G = [G,g_p];
end
for i = 1:P
    if orient == 'R'
        orientatio(:,i) = d_loc(:,i)/norm(d_loc(:,i)); % the radial orientation assumes that the orientation moment matrix will be in direction of the source
    end
end
M = [];
for i = 1:P
    M = blkdiag(M,orientatio(:,i)); % Arranging each dipole orientation in block diagonal matrix
end
D = M*S;