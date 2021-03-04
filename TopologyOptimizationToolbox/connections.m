function [conn, nnConn] = connections(varargin)

if nargin == 2
    X = varargin{1};
    Y = varargin{2};
    conn  = delaunay(X, Y);
    nnConn = [conn(:, [1 2]); conn(:, [1 3]); conn(:, [2 3])];

elseif nargin == 3
    X = varargin{1};
    Y = varargin{2};
    Z = varargin{3};
    conn = delaunay(X, Y, Z);
    nnConn = [conn(:, [1 2]); conn(:, [1 3]); conn(:, [1 4]); 
              conn(:, [2 3]); conn(:, [2 4]); conn(:, [3 4])];
    
else
    error('Error: connections(), wrong number of input arguments (2 or 3)')
end
end
    
