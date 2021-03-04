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
mS.fileName = 'Examples/hinge100.fem';
m = rMesh(mS);
m.nodeCoord = m.nodeCoord./1000;
m.nodeCoord(:,1) = -m.nodeCoord(:,1);
%% Selecting Elements Outside the Design Domain 
m.nonDesignElements((m.X - 0.1).^2 + (m.Y - 0.2125).^2 < 0.1.^2)
m.nonDesignElements((m.X - 0.4).^2 + (m.Y - 0.2125).^2 < 0.1.^2)
m.nonDesignElements((m.X - 0.7).^2 + (m.Y - 0.2125).^2 < 0.1.^2)

m.nonDesignElements((m.X - 1.4).^2 + (m.Z - 0.4).^2 < 0.25.^2)
%% Plotting 
figure(1); hold off
m.plot; 
m.plotNonDesign
hold on
title('Loads and Boundary Conditions')

%% FEM Object 
f = femObject(m); 

%% Boundary Conditions 
f.addBC('XYZ', (m.X - 0.1).^2 + (m.Y - 0.2125).^2 < 0.06001.^2)
f.addBC('XYZ', (m.X - 0.4).^2 + (m.Y - 0.2125).^2 < 0.06001.^2)
f.addBC('XYZ', (m.X - 0.7).^2 + (m.Y - 0.2125).^2 < 0.06001.^2)

f.addBC('Y', (m.Y == 0))

f.plot('bound', 'Y', 'y')
f.plot('bound', 'X', 'b')


%% Loads                                      
q = (m.X - 1.4).^2 + (m.Z - 0.4).^2 < 0.20001.^2;     % Load Distribution
p = -1000./max(1e-40, sum(q)); % Load Magnitude
f.addLoad('Z', p*q)
f.plot('load', 'Z', 'r')

%% Strain Stress Law
E = 200e9;  
nu = 0.3;
C = strainStressLaw(E, nu);
f.addMaterial(C)



%% Optimization Settings SIMP 
os = defaultOptimSettings();
os.Vstar = 0.55;
os.numIter = 20;
os.method = 'SIMP';

%% Optimization Object 
optimObj = optimizationObject(f, os);


%% Solid Isotropic Material with Penalization (SIMP) Optimization

optimObj.startOptimization(2, 3, 'hinge')

%% 

optimObj.calculateStresses 

figure(7)
optimObj.plot('D', 3)


optimObj.saveResults
