% Default Mesh Settings Values
function meshSettings = defaultMeshSettings()


% 2D Face Meshing
meshSettings.nI2D = 12;  % Number of Iterations for the 2D relaxation Mesh
meshSettings.rS2D = 0.1; % Relative to d, size of random displacements
meshSettings.rIt2D = 8;  % Number of Iterations with random displacements

% 3D Solid Meshing
meshSettings.nI3D = 12;  % Number of Iterations for the 3D relaxation Mesh
meshSettings.rS3D = 0.1; % Relative to d, size of random displacements 
meshSettings.rIt3D = 8;  % Number of Iterations with random displacements

end
