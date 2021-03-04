function [conn, X, Y] = faceRelaxation(Xb, Yb, X0, Y0, mS)


coords = unique([Xb, Yb; X0, Y0], 'rows', 'stable'); 
X = coords(:,1); Y = coords(:,2);
Nb = size(Xb, 1); %Number of Boundary Nodes

% Relaxation

% Node to Node Connectivity
[conn, nnConn] = connections(X, Y);

% Element Pseudo-Stiffness Matrix
numNodes = size(X, 1);
k = [-1 1 0 0;
     1 -1 0 0;
     0 0 -1 1;
     0 0 1 -1];
 active = [Nb + 1:numNodes]';
 
 % Relaxation
for iteration = 1:mS.nI2D
	K = sparse(numNodes*2, numNodes*2);
    L = zeros(size(nnConn, 1));
 for i = 1:size(nnConn, 1)
    nodes = nnConn(i,:)';
    dofs = [nodes;nodes + numNodes];
     L(i) = sqrt( (X(nodes(1)) - X(nodes(2))).^2 + ...
               (Y(nodes(1)) - Y(nodes(2))).^2   );
     
    K(dofs, dofs) = K(dofs, dofs) + k*(L(i)^0.4/mS.d);
end

F = K*[X;Y];
F = F/max(abs(F));

if iteration <= mS.rIt2D
    xrand = mS.rS2D * mS.d * (1-2*rand(size(X(active))));
    yrand = mS.rS2D * mS.d * (1-2*rand(size(Y(active))));
else
    xrand = 0; yrand = 0;
end

X(active) = X(active) + 0.5*mS.d*F(intersect(1:numNodes, active)) + xrand;
Y(active) = Y(active) + ...
    0.5*mS.d*F(intersect(numNodes+1:numNodes*2, active + numNodes)) + yrand;

[conn, nnConn] = connections(X, Y);
end
end
