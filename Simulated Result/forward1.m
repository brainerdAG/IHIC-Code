function [y] = forward1(r,rp,sigma)
g(1,:) = (r-rp)/(4*pi*sigma*((norm(r-rp))^3));
y=g;