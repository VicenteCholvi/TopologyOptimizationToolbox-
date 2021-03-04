%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                  %%%
%%%                 Structural Topology Optimization                 %%%
%%%                                                                  %%%
%%%        Solid Isotropic Material with Penalization (SIMP)         %%%
%%%     Bidirectional Evolutionary Structual Optimization (BESO)     %%%
%%%                                                                  %%%
%%%                        Vicente Cholvi Gil                        %%%
%%%                        February 10th 2021                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all

addpath('TopologyOptimizationToolbox')

%% Mesh Generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mS = defaultMeshSettings(); 
mS.Lx = 2;   mS.Ly = 1.5;   mS.Lz = 1;
mS.d = 0.05;
m = rMesh(mS);

m.removeElements((m.X - 1.5).^2 + (m.Z -0.5).^2  < 0.3.^2)

%% Plotting 
figure(1); hold off
m.plot; 
hold on
daspect([1 1 1])
xlim([0, 2])
ylim([0 1.5])
zlim([0 1])
title('Loads and Boundary Conditions')

%% FEM Object 
f = femObject(m); 

%% Boundary Conditions 
f.addBC('XYZ', m.Z == 0 & m.X < 0.7 & abs(m.Y - 0.75) > 0.25)
f.plot('bound', [], 'b')

%% Loads 
p = -1;                                         % Load Magnitude
q = abs((m.X - 1.5).^2 + (m.Z -0.5).^2 -0.3.^2) < 0.1.^2 & ...
    abs(m.Y - 0.75) < 0.2;                      % Load Distribution
f.addLoad('Z', p*q)
f.plot('load', 'Z', 'r')

%% Strain Stress Law
E = 200e9;  
nu = 0.3;
C = strainStressLaw(E, nu);
f.addMaterial(C)

%% Optimization Settings BESO
osBESO = defaultOptimSettings();
osBESO.Vstar = 0.4;
osBESO.numIter = 14;
osBESO.extraIter = 6;
osBESO.method = 'BESO';

%% Optimization Settings SIMP 
osSIMP = defaultOptimSettings();
osSIMP.Vstar = 0.4;
osSIMP.numIter = 20;
osSIMP.method = 'SIMP';

%% Optimization Object 
BESOoptimObj = optimizationObject(f, osBESO);
SIMPoptimObj = optimizationObject(f, osSIMP);



%% Solid Isotropic Material with Penalization (SIMP) Optimization

BESOoptimObj.startOptimization(2, 3, 'comparisonBESO')

figure(5)
SIMPoptimObj.startOptimization(4, 5, 'comparisonSIMP')


%% Compliance Obtained with Each method

SIMPcompliance = SIMPoptimObj.compliance;

BESOcompliance = BESOoptimObj.compliance;

%% Volume Obtained with Each Method 
SIMPvol = SIMPoptimObj.volume('Partial');
BESOvol = BESOoptimObj.volume('Partial');

%% Stress Calculation and Plotting

figure(8)
SIMPoptimObj.calculateStresses
SIMPoptimObj.plot('VM')
set(gca, 'ColorScale', 'log')

figure(9)
BESOoptimObj.calculateStresses
BESOoptimObj.plot('VM')
set(gca, 'ColorScale', 'log')


figure(10)
histogram(SIMPoptimObj.vonMisses, 80)
title('Von-Misses Stress Distribution')
ylabel('Number of Elements')
xlabel('Von-Misses Stress')

figure(11)
histogram(BESOoptimObj.vonMisses, 80)
title('Von-Misses Stress Distribution')
ylabel('Number of Elements')
xlabel('Von-Misses Stress')

