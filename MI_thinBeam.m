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
mS.fileName = 'Examples/example1.fem';
m = rMesh(mS);
m.nodeCoord = [m.nodeCoord(:,3) m.nodeCoord(:,2) m.nodeCoord(:,1)];

%% Plotting 
figure(1); hold off
m.plot; 
hold on
title('Loads and Boundary Conditions')

%% FEM Object 
f = femObject(m); 

%% Boundary Conditions 
f.addBC('XYZ', (m.X == 0) )
f.plot('bound', [], 'b')

%% Loads 
p = -1;                                         % Load Magnitude
q = m.X == 2 & m.Z ==0;                      % Load Distribution
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
os.numIter = 20;
os.method = 'SIMP';

%% Optimization Object 
optimObj = optimizationObject(f, os);

%% Solid Isotropic Material with Penalization (SIMP) Optimization

optimObj.startOptimization(2,3, 'thinBeam')

optimObj.boundary1(0.99)

