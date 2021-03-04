function C = strainStressLaw(E, v)

% Generate stress-Strain law matrix from Hooke's law in 3d
% Vicente Cholvi Gil

ci = E/((1+v)*(1-2*v));

C1313 = [1-v,  v,  v;
           v,1-v,  v;
           v,  v,1-v];
       
C4646 = eye(3)*(1-2*v)/2;

C = zeros(6,6);

C(1:3,1:3) = C1313 * ci;
C(4:6,4:6) = C4646 * ci;

