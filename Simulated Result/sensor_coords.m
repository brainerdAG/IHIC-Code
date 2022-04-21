function [coords] = sensor_coords
load('EEG_loc.mat', 'EEG_loc') % downaloaded from publicly available repository with x direction towards nose and y direction towards ear and z is upward
for i = 1:3
for j = 1:63
    if i == 1
    coords(i,j) = EEG_loc(j).Y; % coords i,j is x coordinate = y coordinate of EEG_loc
    end
    if i==2
    coords(i,j) = EEG_loc(j).X; % coords i,j is y coordinate = x coordinate of EEG_loc
    end  
     if i==3
    coords(i,j) = EEG_loc(j).Z; % coords i,j is z coordinate = z coordinate of EEG_loc
     end
end
end
coords(1,:) = - coords(1,:); % the repository assumes +x towards inion (opposite to nose). 
coords(2,:) = - coords(2,:);