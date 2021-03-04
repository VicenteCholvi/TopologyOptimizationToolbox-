function [elemConn, nodeCoord] = tet4RelaxationMesh(mS)
% Generate Rectangular Mesh of Edges Lx, Ly, Lz and average element edge
% length d
% Vicente Cholvi Gil

%1.1- Edges
disp('Creating Edge Nodes')
xlin = linspace(0, mS.Lx, ceil(mS.Lx/mS.d))';
ylin = linspace(0, mS.Ly, ceil(mS.Ly/mS.d))';
zlin = linspace(0, mS.Lz, ceil(mS.Lz/mS.d))';

%1.2 Edges with correction Factor 1.13 

xlin0 = linspace(mS.d, mS.Lx - mS.d, ceil(mS.Lx/mS.d)*1.13);
ylin0 = linspace(mS.d, mS.Ly - mS.d, ceil(mS.Ly/mS.d)*1.13);
zlin0 = linspace(mS.d, mS.Lz - mS.d, ceil(mS.Lz/mS.d)*1.13);

%2.- Faces
disp('Creating XY Mesh')
[~, X1, Y1] = faceMesh(xlin, ylin, mS, xlin0, ylin0) ; 
disp('Creating XZ Mesh')
[~, X2, Z2] = faceMesh(xlin, zlin, mS, xlin0, zlin0) ;  
disp('Creating YZ Mesh')
[~, Y3, Z3] = faceMesh(ylin, zlin, mS, ylin0, zlin0) ;   

%plotOutsideMesh(Lx, Ly, Lz, X1, Y1, X2, Z2, Y3, Z3, conn1, conn2, conn3)

%3.- Inside
disp('Creating 3D Solid Mesh')
coords = unique([X1, Y1, zeros(size(X1)); 
                 X2, zeros(size(X2)), Z2;
                 zeros(size(Y3)), Y3, Z3;
                 X1, Y1, mS.Lz*ones(size(X1)); 
                 X2, mS.Ly*ones(size(X2)), Z2;
                 mS.Lx*ones(size(Y3)), Y3, Z3], 'rows', 'stable');
             
Xb = coords(:,1); Yb = coords(:,2); Zb = coords(:,3);

[elemConn, nodeCoord] = solidMesh(Xb, Yb, Zb, xlin, ylin, zlin, mS);


end