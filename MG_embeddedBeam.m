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
mS.Lx = 2;   mS.Ly = 1;   mS.Lz = 1;
mS.d = 0.05; 
m = rMesh(mS);
%% Plotting 
figure(1); hold off
m.plot; 
hold on
title('Loads and Boundary Conditions')

%% FEM Object 
f = femObject(m); 

%% Boundary Conditions 
f.addBC('XYZ', (m.X == 0))
f.plot('bound', [], 'b')

%% Loads 
q =( m.X == 2) & (abs(m.Z - 0.5) < 0.1) & (abs(m.Y - 0.5) < 0.1);  % Nodes
p = -1000./max(1e-40, sum(q));                                 % Magnitude
f.addLoad('Z', p*q)
f.plot('load', 'Z', 'r')

%% Strain Stress Law
E = 200e9;  
nu = 0.3;
C = strainStressLaw(E, nu);
f.addMaterial(C)



%% Optimization Settings SIMP 
os = defaultOptimSettings();
os.Vstar = 0.3;
os.numIter = 25;
os.method = 'SIMP';

%% Optimization Object 
optimObj = optimizationObject(f, os);


%% Solid Isotropic Material with Penalization (SIMP) Optimization

optimObj.startOptimization(2,3,'embeddedBeam2')

optimObj.calculateStresses

figure(4)
optimObj.plot('D', 3)




