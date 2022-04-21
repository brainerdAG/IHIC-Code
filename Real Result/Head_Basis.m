function [ Y ] = Head_Basis(I,N,theta,phi)
% Summary of this function goes here
% INPUTS:
% N order, I sensors
% theta, phi self explainable, are of length 'I'
% type -> 'c' complex, 'r' real
% OUTPUT: (I x (N+1)^2) matrix of harmonics basis function
Y=zeros(I,(N+1)^2);
for i=1:I
    k=1;
    for n=0:N
       P=legendre(n,(cos(theta(i))*1.33)-0.33); % (2*x-1) for transformation
        for m=-n:n   % degree
            if m>=0
                Y(i,k)=(-1)^abs(m)*sqrt((2*n+1)*factorial(n-abs(m))/((3*pi)*factorial(n+abs(m))))*P(abs(m)+1)*sqrt(2)*cos(m*phi(i));
                if m == 0
                    Y(i,k) = Y(i,k)/sqrt(2);
                end
            else
                Y(i,k)=(-1)^abs(m)*sqrt((2*n+1)*factorial(n-abs(m))/((3*pi)*factorial(n+abs(m))))*P(abs(m)+1)*sqrt(2)*sin(abs(m)*phi(i));
            end
            k=k+1;
        end
    end
end