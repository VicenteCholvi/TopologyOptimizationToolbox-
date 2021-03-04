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

totaltime = tic;

%% Mesh Generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mS = defaultMeshSettings(); 
mS.Lx = 2;   mS.Ly = 1;   mS.Lz = 1;
mS.d = 0.15; 
m = rMesh(mS);

%% Mesh Modification 
m.removeElements((m.X - 1.5).^2 + (m.Z - 0.5).^2 < 0.2.^2)
m.nonDesignElements( (m.X < 0.3) & (m.Z == 0) )
%% Plotting 
figure(1);
m.plot; hold on
m.plotNonDesign
title('Loads and Boundary Conditions')

%% FEM Object 
f = femObject(m); 

%% Boundary Conditions 
f.addBC('XYZ', (m.X < 0.5) & (m.Z == 0) & (abs(m.Y - 0.5) > 0.2))

q1 = abs((m.X - 1.5).^2 + (m.Z - 0.5).^2 -0.2^2) < 0.1.^2;    % Condition 1
q2 = abs(m.Y - 0.5) < 0.15;                                 % Condition 2
p = -1000./sum(q1.*q2);                                     % Magnitude
f.addLoad('Z', p.*q1.*q2)
hold on
f.plot('load', 'Z', 'r')
f.plot('bound', [], 'b')
title('Design Domain, Loads and Boundary Conditions')
%% Strain Stress Law
E = 200e9;  
nu = 0.3;
C = strainStressLaw(E, nu);
f.addMaterial(C)



%% Optimization Settings SIMP 
os = defaultOptimSettings();
os.Vstar = 0.25;
os.numIter = 20;
os.method = 'SIMP';

%% Optimization Object 
optimObj = optimizationObject(f, os);


%% Solid Isotropic Material with Penalization (SIMP) Optimization


optimObj.startOptimization(2,3,'simpleHinge')

optimObj.calculateStresses

%% Color it in
figure(4)
[V, sConn, X0, Y0, Z0] = optimObj.boundary1([], [], 'Y');
colormap(flipud(jet))

%% Other Plots 
figure(5)
optimObj.plot('VM')
set(gca,'ColorScale','log')

figure(6)
optimObj.plot('S', 1)
colormap(twoColorColormap)
caxis([-14e4 14e4])

figure(7)
optimObj.plot('D', 3)
  
