function [a] = generate_EG(s,p)
%% creating symmetric random matrix
a  = rand(s,s) <  p; % Erdos-Renye 
a = triu(a,1);
a = a+a';
end
