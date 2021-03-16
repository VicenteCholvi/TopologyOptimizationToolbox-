classdef optimizationObject < handle 
    % Structural Topology Optimization class. Constructor requires
    % femObject and optimization setting struct. Default optimization
    % settings are found in 'defaultOptimSettings()'
    properties 
        fem         % FEM Object
        ss          % BESO Optimization Settings 
        x           % Partial or Logical(1/0) Densities
        Ki          % Element Stiffness Matrices
        VOL         % Element Volumes
        K           % Global Stiffness Matrix 
        ALPHA       % Element Elastic Def. Energy / Compliance Gradient
        p           % SIMP Penalization Exponent
        displacements % Displacements, Solution to the Linear System F=Kx
        logConn     % Element Connectivity in Logical Sparse Matrix Form
        logConnNum  % Number of Elements Connected to Each Node
        folderName  % Name of folder to save results 
        iteration   % Optimization Iteration Number
        Vi          % Objective Volume in Each Generation (BESO)
        endTime     % Total Optimization Time
        stress      % Stress Tensor in Voigt Notation
        VM          % Von-Misses Stress
        iterFigNum  % Figure Number for plotting each iteration
        finalFigNum % Figure Number for plotting end result 
    end

    methods 
        function obj = optimizationObject(femObject, settings) 
            % Constructor Method, arguments are FEM-Object and Optimization
            % settings struct

            obj.fem = femObject;
            obj.ss = settings;

            switch settings.method
                case {'SIMP', 'simp', 'Simp', 's', 'S'}
                    obj.p = settings.p;
                    obj.ss.method = 'SIMP';
                    obj.x = obj.ss.Vstar*ones(obj.fem.rMesh.numElem, 1);
                    obj.ss.extraIter = 0;
                case {'BESO', 'beso', 'Beso', 'b', 'B'}
                    obj.p = 1;
                    obj.ss.method = 'BESO';
                    obj.x = ones(obj.fem.rMesh.numElem, 1);    
            end

            obj.ALPHA = zeros(femObject.rMesh.numElem, 1); 
            obj.displacements = zeros(femObject.rMesh.numNodes*3, 1);
            obj.stress = zeros(femObject.rMesh.numElem, 6);
            obj.VM = zeros(femObject.rMesh.numElem, 1);
            obj.iterFigNum = 2;
            obj.finalFigNum = 3;
            
            disp('Generating Element Stiffness Matrices       '); tic
            obj.generateElementStiffnessMatrices; toc; disp('')

            disp('Generating Logical Connectivity Matrix       '); tic
            obj.generateLogicalConnectivity; toc; disp('')
           
            if obj.ss.method == 'BESO'
                [DEs, ~] = obj.designElements; 
                Vtot = sum(obj.VOL(DEs));
                objectiveV = [linspace(Vtot, Vtot*obj.ss.Vstar, ...
                                                    obj.ss.numIter + 1)';
                              obj.ss.Vstar*Vtot*ones(obj.ss.extraIter,1)];
                obj.Vi = objectiveV(2:end);
            end
        end
        
        function generateElementStiffnessMatrices(obj)
            % Generate Element Stiffness Matrices, uses material deifned in
            % the FEM-Object 
            fprintf(repmat(' ', 1, 8))
            obj.Ki = zeros(obj.numElem, 12, 12);
            obj.VOL = zeros(obj.numElem, 1);

            for i = 1:obj.numElem
            	nodes =  obj.fem.rMesh.elemConn(i,:); 
                nc = obj.fem.rMesh.nodeCoord(nodes,:);
    
                [B, ~, obj.VOL(i)] = tetra3DShapeFunction(nc);
                obj.Ki(i,:,:) = B'*obj.fem.C*B;
                 if mod(i, 1000) == 0 || i == obj.numElem
                      clc;
                    fprintf('Calculating Element Stiffness Matrices     ')
                    fprintf('%5.2f %% \n', 100*i/obj.numElem)
                end
            end

            if obj.ss.method == 'BESO'
                [DEs, ~] = obj.designElements; 
                Vtot = sum(obj.VOL(DEs));
                objectiveV = [linspace(Vtot, Vtot*obj.ss.Vstar, ...
                                                    obj.ss.numIter + 1)';
                              obj.ss.Vstar*Vtot*ones(obj.ss.extraIter,1)];
                obj.Vi = objectiveV(2:end);
            end
        end

        function generateLogicalConnectivity(obj)
            % Generate Logical Connectivity Matrix, required for
            % Sensitivity Smoothing.
            elemNums = (1:obj.fem.rMesh.numElem)' + zeros(1, 4);
            obj.logConn = sparse(elemNums(:), ...
                obj.fem.rMesh.elemConn(:), true);
            obj.logConnNum = sum(obj.logConn)';
        end

        function d = densities(obj, varargin)
            % x-Getter Function 
            if isempty(varargin) || isempty(varargin{1})
                d = obj.x;
            else 
                d = obj.x(varargin{1});
            end
        end

        function nN = numNodes(obj)
            % Returns Number of Mesh Nodes
            nN = obj.fem.rMesh.numNodes;
        end
        
        function nE = numElem(obj)
            % Returns Number of Mesh Elements
            nE = obj.fem.rMesh.numElem;
        end
        
        function generateStiffness(obj)
            % Generate Global Stiffness Matrix
            I = (zeros(12*obj.numElem,1));
            J = I;
            V = (zeros(12*obj.numElem,1));

            for i = 1:obj.numElem
                 elementNodes = obj.fem.rMesh.elemConn(i,:);
                 dofs = [elementNodes, ...
                         elementNodes + obj.numNodes, ...
                         elementNodes + obj.numNodes*2];

                 mat = ((obj.densities(i).^obj.p)*...
                     squeeze(obj.Ki(i,:,:))*obj.VOL(i));

                 [jj, ii] = meshgrid(dofs);

                 i1 = 1+(i-1)*144;
                 i2 = i*144;

                 I(i1:i2)= ii;
                 J(i1:i2) = jj;

                 V(i1:i2) = mat(:);
            end
            obj.K = sparse(I, J, V);
        end

        function [DEs, FEs] = designElements(obj)
            % Obtaining List of elements that can be changed (DEs) and
            % elements that have a force applied on one of their nodes,
            % (FNs)
            FNs = [];

            if obj.ss.keepForced == 1
                FNs = find(obj.fem.loaded);
            end

            if obj.ss.keepBounded == 1
                FNs = unique([FNs; find(obj.fem.bounded)]);
            end

            % Elements that cannot be changed
            FE = zeros(obj.numElem, 1);     
            for i = 1:size(FNs,1)
                FE = FE + sum((obj.fem.rMesh.elemConn == FNs(i))')';
            end

            FEs = [find(FE >0); obj.fem.rMesh.nonDesign];
            %Design Elements, Elements with no FNs
            DEs = setdiff((1:obj.numElem)',...
              [FEs; obj.fem.rMesh.zeroElements]);
        end

        function calculateDisplacements(obj)
            % Solve linear System: calculate displacements
            livingElems = find(obj.x > 0);
            livingConn = obj.fem.rMesh.elemConn(livingElems, :);
            livingNodes = sort(unique(livingConn));
            livingDOFs = [livingNodes; 
                          livingNodes + obj.numNodes; 
                          livingNodes + obj.numNodes*2];

            activeDOFs = setdiff(livingDOFs, obj.fem.boundedDOFs)';

            A = obj.K(activeDOFs, activeDOFs);
            b = obj.fem.forceVector(activeDOFs);
            switch obj.ss.solveMethod 
                case 'mldivide'
                u_active = A\b;
                case 'minres'
                u_active = minres(A, b, obj.ss.solveTol, obj.ss.solveIter);
                case 'symmlq'
                u_active = symmlq(A, b, obj.ss.solveTol, obj.ss.solveIter);
            end
            
            obj.displacements(activeDOFs) = u_active;
        end

        function calculateALPHA(obj)
            % Calculate Compliance Gradient (Element Sensitivity)
            for i = 1:size(obj.fem.rMesh.elemConn,1)
                DOFs = [obj.fem.rMesh.elemConn(i,:), ...
                        obj.fem.rMesh.elemConn(i,:) + obj.numNodes,...
                        obj.fem.rMesh.elemConn(i,:) + obj.numNodes * 2];

                ui = obj.displacements(DOFs);
                obj.ALPHA(i) = 0.5*ui'*squeeze(obj.Ki(i,:,:))*ui;
            end

            % SIMP Method (if p == 1 (BESO Method): this has no Effect)
            obj.ALPHA = obj.p.*(obj.x).^(obj.p-1).*obj.ALPHA;  
        end

        function sensitivitySmoothing(obj)
            % Average Element Sensitivities
            nodalSensAv = obj.logConn'*(obj.ALPHA.*obj.x)./obj.logConnNum;
            obj.ALPHA = (1-obj.ss.smoothingW) * obj.ALPHA  + ...
                          obj.ss.smoothingW * obj.logConn * nodalSensAv./4;
        end
 
        function updateALPHA(obj)
            % Update the Value of ALPHA
            disp('Calculating Stiffness Matrix'); tic;
            fprintf(repmat(' ', 1,30));
            obj.generateStiffness; toc

            disp('Solving for Displacements'); tic;
            fprintf(repmat(' ', 1,30));
            obj.calculateDisplacements; toc

            disp('Calculating Alpha');tic; 
            fprintf(repmat(' ', 1,30));
            obj.calculateALPHA; toc

            disp('Sensitivity Smoothing');tic; 
            fprintf(repmat(' ', 1,30));
            for i = 1:obj.ss.smoothingNum
                obj.sensitivitySmoothing 
            end; toc
        end

        function updateDensities(obj)
            % Update Value of element Densities from values of ALPHA
            % depending on the optimization method used
            fprintf('Updating Partial Densities \n'); tic
            switch obj.ss.method
                case {'SIMP', 'simp', 'Simp', 's', 'S'}
                    obj.updateDensitiesSIMP
                case {'BESO', 'beso', 'Beso', 'b', 'B'}
                    obj.updateDensitiesBESO
            end
            fprintf(repmat(' ', 1,30));toc
        end
        
        function updateDensitiesBESO(obj)
            % BESO Method Sensitivities Update
            [DEs, FEs] = obj.designElements;   

            % Remove the lowest performing elements        
            for j = 1:obj.ss.maxRemovedElems
                lowest = (obj.ALPHA == min(obj.ALPHA(DEs) + ...
                                                     (1-obj.x(DEs))*1e12));
                obj.x(lowest) = obj.ss.xmin;
                if obj.x'*obj.VOL < obj.Vi(obj.iteration)/...
                                                    (1+obj.ss.revivalRate)
                    break
                end
            end

            % Revive the highest performing removed elements
            for j = 1:obj.ss.maxRevivedElems
                highest = (obj.ALPHA.*(1-obj.x) == max(obj.ALPHA(DEs).*...
                                                         (1-obj.x(DEs))));
                obj.x(highest) = 1;
                if obj.x'*obj.VOL > obj.Vi(obj.iteration)
                    break
                end
            end
            obj.x(FEs) = 1;
        end

        function updateDensitiesSIMP(obj)
        % SIMP Method Sensitivities Update
        l1 = 0;                                     % Lower Limit
        l2 = sum(obj.ALPHA./obj.VOL)*5000000;       % Upper Limit
        Vav = sum(obj.VOL)/obj.numElem;             % Average El. Volume
        [DEs, FEs] = obj.designElements; 
        Vtot = sum(obj.VOL(DEs));                        % Total Volume    

        for i = 1:obj.ss.maxIterToConvergence
            lambda = (l1 + l2)/2;
            Be = obj.ALPHA ./ (lambda.*Vav);
            Be = Be .^(obj.ss.eta);
        
            x_ud = (Be >1).*min(obj.x.*Be, min(1, obj.x + obj.ss.m)) +...
                   (Be ==1).*obj.x.*Be + ...
                   (Be <1).*max(obj.x.*Be,max(obj.ss.xmin,obj.x-obj.ss.m));
                if abs(x_ud'*obj.VOL/Vtot - obj.ss.Vstar) < 0.005
             disp('----------------CONVERGED-----------------------')
                	obj.x(DEs) = x_ud(DEs);
                	break
                end
         
                if (x_ud)'*obj.VOL < Vtot*obj.ss.Vstar
                	l2 = lambda;
                else
                    l1 = lambda;
                end
        end
        end

        

        function plot(obj, varargin)
            % Plot Elements that have density above cutoff threshold
            % First Arg.(optional): Color Values ('', 'S', 'D')
            % Second Arg.(necesary if first arg is 'S' or 'D'): 
            %   S: 1-Sx, 2-Sy, 3-Sz, 4-Tau-yz, 5-Tau-xz, 6-Tau-xy
            %   D: 1-X-Displacements, 2-Y-Displ., 3-Z-Displ.
            living = obj.x > obj.ss.cutoff;
            [DEs, ~] = obj.designElements; 
            types1 = {'Sigma-x', 'Sigma-y', 'Sigma-z', ...
                'Tau-yz', 'Tau-xz', 'Tau-xy'};
            types2 = {'X-Displacements', 'Y-Displacements', ...
                'Z-Displacements'};
            if isempty(varargin) || isempty(varargin{1})
                plotType = 'iter';
            else
                plotType = varargin{1};
            end
            switch plotType
                case {'VM', 'vm', 'Von-Misses', 'von-misses'}
                	val = obj.VM;
                    ttl = 'Von-Misses Stress';
                case {'S', 'Sigma', 'sigma', 'stress', 'Stress'}
                	val = obj.stress(:,varargin{2});
                    ttl = types1{varargin{2}};
                case {'D', 'Displacement', 'displacement', 'd'}
                	val = sum(obj.displacements(obj.fem.rMesh.elemConn +...
                        (varargin{2} -1)*obj.fem.rMesh.numNodes), 2)./4;
                    ttl = types2{varargin{2}};
                otherwise 
                    if all(obj.ss.method == 'BESO')
                    	val = log(obj.ALPHA);
                    	ttl = sprintf("BESO\n Volume Fraction %f", ...
                        obj.x'*obj.VOL/sum(obj.VOL(DEs)));
                    else 
                        val = obj.x;
                        ttl = sprintf("SIMP\n Volume Fraction %f", ...
                        obj.x'*obj.VOL/sum(obj.VOL(DEs)));
                    end
            end
                        
           obj.fem.rMesh.plot(val, living)
           title(ttl)                 
           view([20 20])
           daspect([1 1 1])
           colorbar
           drawnow

           if obj.ss.outputAllIterations == 1 && (plotType(1) == 'i')
                savefig(sprintf('ITERATIONS/%s/iteration%i', ...
                                  obj.folderName, obj.iteration))
                saveas(gcf, sprintf('ITERATIONS/%s/iteration%i',...
                                   obj.folderName, obj.iteration), 'epsc')
           end
        end
        
        function startOptimization(obj, varargin)
            % Start Topology Optimization 
            
            obj.folderName = datestr(now, 'yyyy_mm_dd_HH_MM_SS');
            if ~isempty(varargin) 
                if ~isempty(varargin{1})
                    obj.iterFigNum = varargin{1};
                end
                if ~isempty(varargin{2})
                    obj.finalFigNum = varargin{2};
                end
                if ~isempty(varargin{3})
                    obj.folderName = varargin{3};
                end
            end
            mkdir(sprintf('ITERATIONS/%s', obj.folderName))
            mkdir(sprintf('RESULTS/%s', obj.folderName))
            tic
            % Obtaining Nodes that have an external force applied, FNs 
            [~, FEs] = obj.designElements;
            obj.x(obj.fem.rMesh.zeroElements) = obj.ss.xmin;
            obj.x(FEs) = 1;

            for i = 1:obj.ss.numIter + obj.ss.extraIter
                obj.iteration = i; 
                if obj.ss.clearConsIter == true; clc; end
                disp('___________________________________________________')
                fprintf('Iteration %i / %i \n', ...
                                            obj.iteration, obj.ss.numIter)
                obj.updateALPHA
                obj.updateDensities    
                figure(obj.iterFigNum)
                hold off
                obj.plot
            end
            obj.endTime = toc;
            fprintf('Total Optimization Time: %i Seconds\n', obj.endTime)
            figure(obj.finalFigNum)
            [~, conn, X0, Y0, Z0] = obj.boundary1(obj.ss.cutoff);
            TR = triangulation(conn, X0, Y0, Z0);
            stlwrite(TR, sprintf('RESULTS/%s/result.stl', ...
                obj.folderName), 'text')
            obj.saveResults
        end

        function saveResults(obj)
            % Save Workspace and Figures, and Requires Project Folder 
            % Created in 'createFolders()'
            for i = 1:20
                if ishandle(i)
                figure(i)
                savefig(sprintf('RESULTS/%s/figure%i', obj.folderName, i))
                saveas(gcf, sprintf('RESULTS/%s/figure%i',...
                                            obj.folderName, i), 'epsc')
                end
            end

            save(sprintf('RESULTS/%s/ENDWORKSPACE',obj.folderName)) 
        end

        function varargout = boundary1(obj, varargin)
            % Plot the outside Surface and return the volume using nodes
            % that are part of elements with densities above a threshold 
            shrinkFactor = 0.85;
            cutoff = obj.ss.cutoff;
            type = 'N';
            if ~isempty(varargin) && ~isempty(varargin{1})
                cutoff = varargin{1};
            end
            if length(varargin) > 1 && ~isempty(varargin{2})
                shrinkFactor = varargin{1};
            end
            if length(varargin) > 2 && ~isempty(varargin{3})
                type = varargin{3};
            end
            
            % Find Nodes in non removed elements
            ncliv = obj.fem.rMesh.elemConn((obj.x > cutoff),:); 
            nodesInLiving = unique(ncliv(:));

            X0 = obj.fem.rMesh.X(nodesInLiving);
            Y0 = obj.fem.rMesh.Y(nodesInLiving);
            Z0 = obj.fem.rMesh.Z(nodesInLiving);

            [sConn, V] = boundary([X0, Y0, Z0], shrinkFactor);
            if type(1) == 'N' || type(1) == 'n'
                trisurf(sConn, X0, Y0, Z0, X0, 'Facecolor','green')
            else
                switch type
                    case {'X', 'x', 1}
                        val = sum(X0(sConn), 2)/3;
                    case {'Y', 'y', 2}
                        val = sum(Y0(sConn), 2)/3;
                    case {'Z', 'z', 3}
                        val = sum(Z0(sConn), 2)/3;
                end
                trisurf(sConn, X0, Y0, Z0, val)
            end
            daspect([1 1 1])
            view([20 30])
            varargout = {V, sConn, X0, Y0, Z0};
        end

        function vol = volume(obj, option, varargin)
            % Obtain the volume of the current solution. Uses partial
            % densities(argument 'Partial') or density equal to one
            % (argument 'Total'). Second argument(optional) selects certain
            % elements.
            if isempty(varargin) || isempty(varargin{1})
                elems = obj.x > obj.ss.xmin;
            else
                elems = varargin{1};
            end
            
            switch option
                case {'Partial', 'partial', 'p', 'P'}
                    vol = obj.VOL(elems)'*obj.x(elems);
                case {'Total', 'total', 't', 'T'}
                    vol = sum(obj.VOL(elems), 'all');
            end
        end
        
        function c = compliance(obj)
            % Returns Compliance calculated as the dot product of nodal
            % forces and nodal displacemnents
            c = obj.fem.forceVector'*obj.displacements;
        end
        
        function calculateStresses(obj)
            % Calculate stress tensor in Voigt Form for all elements. Also
            % calculates Von-Misses stress.
            disp('Calculating Stresses       '); fprintf(repmat(' ', 1, 8))
            for i = 1:obj.fem.rMesh.numElem
                nodes = obj.fem.rMesh.elemConn(i,:); %Element Nodes
                nc = obj.fem.rMesh.nodeCoord(nodes,:);% Elem. Node Coords.
    
                [B, ~, ~] = tetra3DShapeFunction(nc);

                ui = obj.displacements([obj.fem.rMesh.elemConn(i,:), ...
                  obj.fem.rMesh.elemConn(i,:) + obj.fem.rMesh.numNodes,...
                  obj.fem.rMesh.elemConn(i,:) + obj.fem.rMesh.numNodes*2]);

                s = obj.fem.C*B*ui;
                obj.VM(i) = sqrt( ...
                  0.5*((s(1)-s(2))^2 + (s(2)-s(3))^2 + (s(3)-s(1))^2) + ...
                    3*(s(4)^2 + s(5)^2 + s(6)^2));
                
                obj.stress(i,:) = s;
                
                 if mod(i, 1000) == 0 || i == obj.numElem
                    fprintf(repmat('\b', 1, 9))
                    fprintf('%5.2f %% \n', 100*i/obj.numElem)
                end
            end
        end
        
        function s = sigma(obj)
            % Return Stress Tensor for each Element(Voigt Notation)
            s = obj.stress;
        end
        
        function vm = vonMisses(obj)
            % Return Von Misses Stress for Each Element
            vm = obj.VM;
        end
        
        function xDisp = U(obj)
            % Return Values of Displacements in the X direction 
            xDisp = obj.displacements(1:obj.numNodes);
        end
        
        function yDisp = V(obj)
            % Return Values of Displacements in the X direction 
            yDisp = obj.displacements(obj.numNodes + 1:obj.numNodes*2);
        end
        
        function zDisp = W(obj)
            % Return Values of Displacements in the X direction 
            zDisp = obj.displacements(obj.numNodes*2 + 1:obj.numNodes*3);
        end
        
    end


end
