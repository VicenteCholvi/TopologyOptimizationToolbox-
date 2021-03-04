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
mS.import = true;
mS.fileName = 'Examples/example2.fem';
m = rMesh(mS);

%% Plotting 
figure(1); hold off
m.plot; 
hold on
title('Loads and Boundary Conditions')

%% FEM Object 
f = femObject(m); 

%% Boundary Conditions 
f.addBC('XYZ', (m.X == 0) .* (m.Z == 0))
f.addBC('Y', (m.X == 5) .* (m.Z == 0))
f.addBC('Z', (m.X == 5) .* (m.Z == 0))
f.plot('bound', 'Y', 'cyan')
f.plot('bound', 'X', 'b')


%% Loads 
p = -1;                                         % Load Magnitude
q = (m.X - 5/2).^2 + (m.Z).^2 < 0.1^2;          % Load Distribution
f.addLoad('Z', p*q)
f.plot('load', 'Z', 'r')

%% Strain Stress Law
E = 200e9;  
nu = 0.3;
C = strainStressLaw(E, nu);
f.addMaterial(C)



%% Optimization Settings SIMP 
os = defaultOptimSettings();
os.Vstar = 0.4;
os.numIter = 35;
os.method = 'SIMP';

%% Optimization Object 
optimObj = optimizationObject(f, os);


%% Solid Isotropic Material with Penalization (SIMP) Optimization


figure(5)
optimObj.startOptimization


figure(6)
optimObj.boundary1(0.99)


optimObj.saveResults
