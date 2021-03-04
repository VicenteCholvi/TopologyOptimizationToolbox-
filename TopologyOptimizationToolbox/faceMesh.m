function [conn, X, Y] = faceMesh(xlin, ylin, mS, xlin0, ylin0) 

Xb = [xlin;
     xlin(end)*ones(size(ylin, 1)-2,1);
     flip(xlin);
     zeros(size(ylin, 1)-2,1)];

Yb = [zeros(size(xlin, 1),1);
     ylin(2:end-1);
     ylin(end)*ones(size(xlin, 1),1);
     flip(ylin(2:end-1))];
 
[Y0, X0] = meshgrid(ylin0, xlin0); Y0 = Y0(:); X0 = X0(:);


[conn, X, Y] = faceRelaxation(Xb, Yb, X0, Y0, mS);

end