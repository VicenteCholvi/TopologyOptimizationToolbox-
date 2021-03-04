classdef rMesh < handle
    % Generate or Import TET4 Mesh and store as node coordinates array and
    % element connectivity array. Can set elements to be removed (unless a
    % load is applied on them) and elements that cannot be removed in the
    % optimization. 
    properties
        elemConn % Element Connectivity Array: Lists Nodes in Each Element 
        nodeCoord % Node Coordinates: Lists X, Y, Z coords. for each node
        zeroElements    % Elements that have to be removed 
        mS          % Mesh Settings
        nonDesign   % List of elements that cannot be removed 
    end
    
    methods 
        function obj = rMesh(mS)
            obj.mS = mS;
            if isfield(mS, 'import') && mS.import
                [obj.elemConn, obj.nodeCoord] = importData2(mS.fileName);
            else
            [obj.elemConn, obj.nodeCoord] = tet4RelaxationMesh(mS);
            end
            obj.zeroElements = [];
            obj.nonDesign = [];
        end
        
        function nE = numElem(obj)
            % Returns Number of Elements
            nE = size(obj.elemConn, 1);
        end
        
        function nN = numNodes(obj)                 
            % Returns Number of Nodes
            nN = size(obj.nodeCoord, 1);
        end
        
        function xCoord = X(obj, varargin)                    
            % Returns Nodal X-Coordinates
            x = obj.nodeCoord(:,1);
            if isempty(varargin) || isempty(varargin{1})
                xCoord = x;
            else 
                xCoord = x(varargin{1});
            end
        end
        
        function yCoord = Y(obj, varargin)                    
            % Returns Nodal Y-Coordinates
            y = obj.nodeCoord(:, 2);
            if isempty(varargin) || isempty(varargin{1})
                yCoord = y;
            else 
                yCoord = y(varargin{1});
            end
        end
        
        function zCoord = Z(obj, varargin)                    
            % Returns Nodal Z-Coordinates
            z = obj.nodeCoord(:,3);
            if isempty(varargin) || isempty(varargin{1})
                zCoord = z;
            else 
                zCoord = z(varargin{1});
            end
        end
        
        function plot(obj, varargin)                
            % Mesh Plotting. First Argument(optional) is array of values
            % to color differently for each element. Second
            % Argument(optional) is logical indexing of elements to be 
            % plotted
            if length(varargin) > 1
            elemsToPlot = setdiff(find(varargin{2}), obj.zeroElements);
            else
            elemsToPlot = setdiff(1:obj.numElem, obj.zeroElements);                
            end
            
            if ~isempty(varargin) > 0 && (~isempty(varargin{1}))
            colorValue = varargin{1};
            obj.tetrasurf(elemsToPlot, colorValue)
            else
                obj.tetrasurf(elemsToPlot, [0.0638   0.7446   0.7292])
            end
            daspect([1 1 1])
        end

        % Remove elements that contain these nodes
        function removeElements(obj, condition) 
            affectedNodes = find(condition);

            elems = sum(obj.elemConn(:,1) == affectedNodes', 2) | ...
                    sum(obj.elemConn(:,2) == affectedNodes', 2) | ...
                    sum(obj.elemConn(:,3) == affectedNodes', 2) | ...
                    sum(obj.elemConn(:,4) == affectedNodes', 2);

%             remainingElems = setdiff(1:obj.numElem, find(elems));
% 
%             obj.elemConn = obj.elemConn(remainingElems,:);
            obj.zeroElements = unique([obj.zeroElements; find(elems)]);
        end
        
        function nonDesignElements(obj, condition)
            % Elements that cannot beremoved in the optimization
            affectedNodes = find(condition);

            elems = sum(obj.elemConn(:,1) == affectedNodes', 2) | ...
                    sum(obj.elemConn(:,2) == affectedNodes', 2) | ...
                    sum(obj.elemConn(:,3) == affectedNodes', 2) | ...
                    sum(obj.elemConn(:,4) == affectedNodes', 2);
                
            obj.nonDesign = unique([obj.nonDesign; find(elems)]);
        end
        
        function tetrasurf(obj, etp, C)
            % Use Matlab Trisurf triangle plotting to plot tetrahedra
            % obj.tetrasurf(etp, C) etp: elements to plot, C: color/value
            if length(C) <= 6 && ~ (all(C == 1) && length(C) ==1)
                trisurf(obj.elemConn(etp,1:3),obj.X,obj.Y,obj.Z, ...
                    'Facecolor',C)
                hold on
                trisurf(obj.elemConn(etp,2:end), obj.X, obj.Y, obj.Z, ...
                    'Facecolor',C)
                trisurf(obj.elemConn(etp,[1 3 4]), obj.X, obj.Y, obj.Z, ...
                    'Facecolor',C)
                trisurf(obj.elemConn(etp,[1 2 4]), obj.X, obj.Y, obj.Z, ...
                    'Facecolor',C)
            else 
                
                trisurf(obj.elemConn(etp,1:3),obj.X,obj.Y,obj.Z,C(etp))
                hold on
                trisurf(obj.elemConn(etp,2:end),obj.X,obj.Y,obj.Z,C(etp))
                trisurf(obj.elemConn(etp,[1 3 4]),obj.X,obj.Y,obj.Z,C(etp))
                trisurf(obj.elemConn(etp,[1 2 4]),obj.X,obj.Y,obj.Z,C(etp))
            end

        end
        
        function plotNonDesign(obj)
           obj.tetrasurf(obj.nonDesign, 'cyan')
        end
    end
end


