function [J] = cost_music_head(x,y,z,P_lrA,coords,sigma,temp,mult)
%% Scanning
count = 0;
for r=temp
    count = count+1;
    x = r*x; y = r*y; z = r*z;
    for i=1:length(coords)
        [Gph(i,:)] = forward1(coords(:,i),[x y z]',sigma);
    end
    Gph = mult*Gph;
    [U1,S1,V1] = svd(Gph,'econ');
    rot = U1'*P_lrA*U1;
    [rotvec,rotval] = eig(rot);
    [rotval,rotIndex] = sort(diag(rotval),'ascend'); % Sorted in descending order
    d = rotval(1);
    J(count) = 1/d;  % min(d) is the minimum value of vector d i.e minimum eigen value of Fin
end
end