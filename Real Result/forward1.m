function [y] = forward1(r,rp,sigma)
g(1,:) = (r-rp)/(4*pi*sigma*((norm(r-rp))^3));
y=g;
% function [U1] = forward1(coords,d_loc,sigma,S,orient)
% [G,D,M] = forward(coords,d_loc,sigma,S,orient);
% Mat = G;
% [U,S]=eig(Mat*Mat');
% [ssing,indx]=sort(abs(diag(S)),'descend');
% tol = max(ssing)*0.001;
% % Other eig, would be abolutely zero, for they have emerged from '3'
% % dimension
% rank = sum(ssing > tol);  % selecting non-zero singular values one...
% U1=U(:,indx(1:rank));
