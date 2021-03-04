function [B, Li, VOL] = tetra3DShapeFunction(nc)

% Generate the  linear shape function coefficients for a tetragonal
% 4 noded element
% Vicente Cholvi Gil
%
% Input nc: node Coordinates: 4x3 matrix containing the coordinates of 
% each node in each column of nc
% Explaination: Finite Element Analysis Fundamentals, Galagher page 236

    A = [ones(1,4); nc'];
    Li = inv(A);
    
    % Building B Matrix:
    % Using linear Functions the integral over the element volume becomes
    % the integral of the volume times the(Constant in space) B Matrix
    B = zeros(6,12);
    B(1,1:4) = Li(:,2)'; %dNi/dx
    B(2,5:8) = Li(:,3)'; %dNi/dy
    B(3,9:12)= Li(:,4)'; %dNi/dz
     % gamma_yz : dNi/dy + dNi/dz ( gamma_yz = dw/dy + dv/dz )
     % B(4:6,:) = [Li(5:end); Li(5:end); Li(5:end)] - B(1:3,:);
     % gamma_yz = dw/dy + dv/dz
    B(4,5:8) = Li(:,4)';
    B(4,9:12) = Li(:,3)';
    % gamma_xz = dw/dx + du/dz
    B(5,1:4) = Li(:,4)';
    B(5,9:12) = Li(:,2)';
    % gamma_xy = dw/dx + du/dz
    B(6,1:4) = Li(:,3)';
    B(6,5:8) = Li(:,2)';

    
    VOL = abs(det([ones(4,1),nc])/6);
end