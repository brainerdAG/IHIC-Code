function [coords] = sensor_coords
load('EEG_loc.mat', 'EEG_loc')
for i = 1:3
for j = 1:63
    if i == 1
    coords(i,j) = EEG_loc(j).Y;
    end
    if i==2
    coords(i,j) = EEG_loc(j).X;
    end  
     if i==3
    coords(i,j) = EEG_loc(j).Z;
     end
end
end
coords(1,:) = - coords(1,:);
%coords(2,:) = - coords(2,:);