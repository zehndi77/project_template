%function [adjacencym, graphm] = createadjm (matrix)
function [graphm] = creategraph (matrix)
graphm= graph(matrix,'OmitSelfLoops'); % creates type "graph"
% adjacencym= adjacency(graphm); % creates adjacency matrix;
end