function [conn, nodeCoord] = solidMesh(Xb, Yb, Zb, xlin, ylin, zlin, mS)

Nb = size(Xb, 1);                              % Boundary Nodes Number 


[Y0, X0, Z0] = meshgrid(ylin, xlin, zlin);  % Generating Initial Mesh
           
% X = [Xb; X0(:)]; Y = [Yb; Y0(:)]; Z = [Zb; Z0(:)];

notSurf = find(X0 ~= 0 & X0 ~= mS.Lx &...
               Y0 ~= 0 & Y0 ~= mS.Ly &...
               Z0 ~= 0 & Z0 ~= mS.Lz);
           
X = [Xb; X0(notSurf)]; Y = [Yb; Y0(notSurf)]; Z = [Zb; Z0(notSurf)];

[conn, nnConn] = connections(X, Y, Z);      % nnConn: Node-to-node conn.

% Relaxation

nN = size(X, 1);                            % number of Nodes

k = [-1 1 0 0 0 0;
     1 -1 0 0 0 0;
     0 0 -1 1 0 0;
     0 0 1 -1 0 0;
     0 0 0 0 -1 1;
     0 0 0 0 1 -1];                     % Single Connection Stiffness mat.
 
active = [Nb + 1:nN]';            % Non-Boundary nodes 
activeDOFs = [active; active + nN; active + nN*2];
L = zeros(size(nnConn, 1),1);           % Connection Length 

for iteration = 1:mS.nI3D
    K = sparse(nN*3, nN*3); % Global Stiffness Matrix
    numElem = size(nnConn, 1);
    
    I = (zeros(6*numElem,1));           % I, J: Stiffness mat. Indices
    J = I;                              % V: Stiffness Matrix Values to -
    V = (zeros(6*numElem,1));           % accumulate
    
	for i = 1:size(nnConn, 1)
        nodes = nnConn(i,:)';
        dofs = [nodes;nodes + nN; nodes + nN*2];
        L(i) = sqrt( (X(nodes(1)) - X(nodes(2))).^2 + ...
                     (Y(nodes(1)) - Y(nodes(2))).^2 + ...
                     (Z(nodes(1)) - Z(nodes(2))).^2);
        
        [jj, ii] = meshgrid(dofs);
        
        i1 = 1 + (i-1)*36;
        i2 = i*36; 
        mat = k*(L(i)/mS.d);        % Values are obtained from stiffness 
                                    % mat. * length/d 
     I(i1:i2)= ii;
     J(i1:i2) = jj;
     if mod(i,10000) == 0
         clc
         disp('Relaxation Mesh: Generating Solid Tet4 Mesh')
         fprintf('Iteration %i /%i, %5.1f %% \n', iteration, mS.nI3D, ...
             100*i/numElem)
     end
     V(i1:i2) = mat(:);
    end
    clc
    disp('Relaxation Mesh: Generating Solid Tet4 Mesh')
    fprintf('Iteration %i /12, Assembling Relaxation Matrix', iteration)
    K = sparse(I, J, V);            % Stiffness Matrix
    
    F = K*[X;Y;Z];                  % Forces on Nodes
    F = F/max(abs(F));              % Normalizing
    
    if iteration <= mS.rIt3D   % Adding a small random value
        xrand = mS.rS3D * mS.d * (1-2*rand(size(X(active))));
        yrand = mS.rS3D * mS.d * (1-2*rand(size(Y(active))));
        zrand = mS.rS3D * mS.d * (1-2*rand(size(Z(active))));
    else
        xrand = 0; yrand = 0; zrand = 0;
    end
    
% Updating Positions 
    X(active) = X(active) + 0.5*mS.d*F(intersect(1:nN, active)) + xrand;
    
    Y(active) = Y(active) + ...
        0.5*mS.d*F(intersect(nN+1:nN*2, active + nN)) + yrand;
    
    Z(active) = Z(active) + ...
        0.5*mS.d*F(intersect(2*nN+1:nN*3, active+ nN*2)) +zrand;
    
    [conn, nnConn] = connections(X, Y, Z);

end
nodeCoord = [X Y Z];
% figure(10)
% plot(L)       % Plotting length of each node-to-node Connection 
end