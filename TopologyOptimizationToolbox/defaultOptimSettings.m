function settings = defaultOptimSettings()
% Default Settings for Topology Optimization
% Vicente Cholvi Gil
settings.method = 'SIMP';       % Default Optimization Method
% Common Settings 
settings.Vstar = 0.35;          % Objective Volume Fraction
settings.numIter = 10;          % Number of Iterations
settings.keepBounded = 0;       % Keep Elements that Have Nodes with BCs
settings.keepForced = 1;        % Keep Elements that have nodes with Loads
settings.outputAllIterations = 1;   % Save plot of each iteration
settings.smoothingW = 1;        % Sensitivity Smoothing 
settings.smoothingNum = 1;      % Number of times to apply smoothing filter
settings.xmin = 0.001 ;         % Minimum Value of x (/=0 for stability
settings.solveMethod = 'mldivide'; % Linear System solution method
settings.solveTol = 1e-6;       % Lin Sys Sol tolerance(if iterative)
settings.solveIter = 5000;      % Max num Iter lin sys sol(if iterative)
settings.cutoff = 0.3;          % Min. Element Partial Density to Display
settings.clearConsIter = true;  % Clear Console Each iteration 

% SIMP Settings
settings.eta = 0.5;                      % Numerical Damping 
settings.maxIterToConvergence = 100000;  % Max. Number of Convergence Iter
settings.p = 1;                          % Penalization Exponent
settings.m = 0.4;               % Maximum Change in Element Density

% BESO Settings 
settings.maxRemovedElems = 10000;   % Max number of removed elems per Iter
settings.maxRevivedElems = 10000;   % Max number of revived elems per Iter
settings.revivalRate = 0.25;        % Fraction of elems to be revived 
settings.extraIter = 4;             % Num. Iter with constant volume
end

