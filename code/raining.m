function [stats] = raining(stats,nodeii)
stat = stats(nodeii);
if stat ==0% initiate viewer
    stats(nodeii) = 1; % cinema goer
elseif stat == 1 % initiate seeder
    stats(nodeii) = 3; %pirate seeder
end %elsewise do nothing
end
