function [elemConn, nodeCoord] = importData2(filename)

% Import data from .fem file
% Creates text file coordinates.txt and connectivity.txt using python
% and imports the data from these files
% Vicente Cholvi Gil

system(sprintf('python TopologyOptimizationToolbox/transformData.py %s',...
    filename));

nodeCoord = importdata('coordinates.txt');

elemConn = importdata('conectivity.txt');

checkInvalid = sum(isnan([nodeCoord(:);elemConn(:)])) ;
if (checkInvalid > 0) 
    error('__Invalid Data in Imported Arrays')
end

end
