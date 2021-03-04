classdef femObject < handle
    % Finite Element Method Object for Topology Optimizatiton. Stores Mesh,
    % Loads, Boundary Conditions and material properties (Stress-Strain
    % Law)
    properties
        xBNs
        yBNs
        zBNs
        
        xLoad
        yLoad
        zLoad

        rMesh

        material
    end
    
    methods
        function obj = femObject(rMeshObject) 
            % Constructor. Requires rMesh Object
            obj.rMesh = rMeshObject;
            obj.xBNs = zeros(rMeshObject.numNodes, 1, 'logical');
            obj.yBNs = zeros(rMeshObject.numNodes, 1, 'logical');
            obj.zBNs = zeros(rMeshObject.numNodes, 1, 'logical');
            obj.xLoad = zeros(rMeshObject.numNodes, 1);
            obj.yLoad = zeros(rMeshObject.numNodes, 1);
            obj.zLoad = zeros(rMeshObject.numNodes, 1);
        end
        
        
        function addBC(obj, coord, condition)     
            % Add BCs. First Argument is direction: X, Y, Z or 'XYZ'(all)
            % Second argument is logical array of all nodes 
            condition = condition(:);
            switch coord 
                case 'X' 
                    obj.xBNs = obj.xBNs | condition;
                case 'Y' 
                    obj.yBNs = obj.yBNs | condition;
                case 'Z' 
                    obj.zBNs = obj.xBNs | condition;
                case {[], 'XYZ', 'xyz'}
                    obj.addBC('X', condition)
                    obj.addBC('Y', condition)
                    obj.addBC('Z', condition)
            end
        end
        
        
        function addLoad(obj, coord, load)
            % Add Loads. First argument is direction, second argument is
            % array of loads on each node
            if length(load(:)) ~= obj.rMesh.numNodes
            error('Error: Load vector must be of length -number of nodes-')
            end
            load = reshape(load, [], 1);
            switch coord 
                case 'X' 
                    obj.xLoad = obj.xLoad + load;
                case 'Y' 
                    obj.yLoad = obj.yLoad + load;
                case 'Z' 
                    obj.zLoad = obj.zLoad + load;
            end
        end
        
        function addMaterial(obj, C)
            % Set Strain-Stress Law Values
            obj.material = C;
        end 

        function ssLaw = C(obj)
            % Return Strain-Stress Law
            ssLaw = obj.material;
        end
        
        function ldd = loaded(obj, varargin)
        % Return Nodes that have an applied load in one or any direction
            if isempty(varargin) || isempty(varargin{1})
                ldd = loaded(obj,'X') |loaded(obj,'Y') |loaded(obj,'Z');
            else
                switch varargin{1}
                    case 'X' 
                        ldd = (obj.xLoad ~= 0);
                    case 'Y' 
                        ldd = (obj.yLoad ~= 0);
                    case 'Z' 
                        ldd = (obj.zLoad ~= 0);
                end
            end
        end
        
        function bnd = bounded(obj, varargin)
        % Check for boundary condition in one or any direction 
        % Output is a logical array
            if isempty(varargin) || isempty(varargin{1})
           bnd = bounded(obj, 'X') | bounded(obj, 'Y') | bounded(obj, 'Z');
            else
                switch varargin{1}
                    case 'X' 
                        bnd = obj.xBNs;
                    case 'Y' 
                        bnd = obj.yBNs;
                    case 'Z' 
                        bnd = obj.zBNs;
                end
            end
        end
        
        function bDOFs = boundedDOFs(obj)
            % Check for bounded Degrees of Freedom
            % Output is a list of DOFs
            xBDOFs = find(obj.xBNs);
            yBDOFs = find(obj.yBNs) + obj.rMesh.numNodes;
            zBDOFs = find(obj.zBNs) + 2*obj.rMesh.numNodes;
            bDOFs = [xBDOFs; yBDOFs; zBDOFs];
        end
        
        function f = forceVector(obj, varargin)
        % Return vector of nodal Forces
        % (numNodes*3 x 1)-Array
            fV = [obj.xLoad; obj.yLoad; obj.zLoad];
            if isempty(varargin) 
                f = fV;
            else
                f = fV(varargin{1});
            end
        end
        
        function plot(obj, type, varargin)
        % Plot Boundary Conditions 
        % Typical Arguments: ('bound', 'X', 'b')
            coord = [];
            color = [];
            if ~isempty(varargin)
                coord = varargin{1};
                if length(varargin) > 1
                    color = varargin{2};
                end
            end                
            
            switch type
                case {'bound', 'Bound', 'B', 'b', 'bnd', 'BC', 'BCs'}
                    toPlot = obj.bounded(coord);
                    plotType = 1;
                case {'load', 'Load', 'l', 'L', 'ld', 'Ld'}
                    toPlot = obj.loaded(coord);
                    plotType = 2;
                case {'mesh', 'Mesh', 'm', 'M'}
                    plotType = 3;
            end
            
            
            switch plotType 
                case 1
                    plot3(obj.rMesh.X(toPlot), ...
                          obj.rMesh.Y(toPlot), ...
                          obj.rMesh.Z(toPlot), ...
                'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color)
                case 2
                    plot3(obj.rMesh.X(toPlot), ...
                          obj.rMesh.Y(toPlot), ...
                          obj.rMesh.Z(toPlot), ...
                'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color)
                case 3
                    obj.rMesh.plot
            end
            
        end

    end
end
