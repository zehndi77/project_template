function [yesno] = spreadinghappend(neighs, beta, decay)
% this function decides on, if the spreading is taking place or not
% based on a random number generator
% returns true/false statement, for use in a if-statement

%% somewhere the decay factor has to be implemented...

%% Desicion maker
if rand < (1-(1-beta)^neighs)*decay % possibility of getting infected, parameter ...
    % decay is decreasing, so that the likelihood gets smaller in time.
    yesno = true; % person gets infected
else
    yesno = false; % person gets not infected
end
    
end