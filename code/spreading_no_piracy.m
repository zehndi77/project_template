function [stats] = spreading_no_piracy(graphm,stats,nodeii,beta,decay,pc,p_pc)
N = neighbors(graphm,nodeii); % returns neighbours
statsii = stats(N); %gets stats of all neighbors
%% get if somebody has watched the movie already
if sum(statsii)&&~stats(nodeii)% only enter loop if someone is susceptible and has infected neighbors
    neighs = sum(statsii(:) ~= 0); % all the nonzero neighs
    if spreadinghappend(neighs, beta, decay)
%         if rand > additional parameter
        if rand < pc + (1-pc)*p_pc
            stats(nodeii) = 1; % cinema happens
        end
    end
end
end

