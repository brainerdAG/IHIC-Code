function [error,Est_dlocee] = rmse(d_loc,Est_dloc)
P = length(d_loc(1,:));
if P==2
    if abs(d_loc(1,1)-Est_dloc(1,1))<abs(d_loc(1,1)-Est_dloc(1,2))
        if abs(d_loc(1,2)-Est_dloc(1,1))>abs(d_loc(1,2)-Est_dloc(1,2))
            for j = 1:P
                Est_dlocee = Est_dloc;
                xerr = ((d_loc(1,j)-Est_dlocee(1,j))^2);
                yerr = ((d_loc(2,j)-Est_dlocee(2,j))^2);
                dipole_error(j) = sqrt(xerr+yerr);
            end
        else
            for j = 1:P
                Est_dlocee = fliplr(Est_dloc);
                xerr = ((d_loc(1,j)-Est_dlocee(1,j))^2);
                yerr = ((d_loc(2,j)-Est_dlocee(2,j))^2);
                dipole_error(j) = sqrt(xerr+yerr);
            end
        end
    else
        for j = 1:P
            Est_dlocee = fliplr(Est_dloc);
            xerr = ((d_loc(1,j)-Est_dlocee(1,j))^2);
            yerr = ((d_loc(2,j)-Est_dlocee(2,j))^2);
            dipole_error(j) = sqrt(xerr+yerr);
        end
    end
    error = dipole_error(1)+dipole_error(2);
else
    for j = 1:P
        Est_dlocee = Est_dloc;
        xerr = ((d_loc(1,j)-Est_dlocee(1,j))^2);
        yerr = ((d_loc(2,j)-Est_dlocee(2,j))^2);
        dipole_error(j) = sqrt(xerr+yerr);
    end
    error = [dipole_error(1)];
end



