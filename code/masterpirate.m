function [ statssave,statssave_no_pirate,graphm,stats,ratio] = ...
    masterpirate(size,beta,tmax,delay,decayinit,pc,p_pc)
%masterpirate This function calls all other functions and is running the main
%loop of the spreading mechanism.
%  size determines the size of the matrix, so it's correlated to the number
%  of nodes you get
% beta gives the number how good the movie spreads
% tmax is determining how long the loop runs
% delay sets, how late the pirating gets in
% decayinit gives the number how fast the interest in the movie decays
% best if smaller than decayinitmax = log(2)/tmax;, at this time the
% p(spreading) = 0, before tmax is reached

%% Saturation, Delay, Decay, Income with/without pirating
%% Inputchecks and defaults
if nargin < 7
    if nargin < 6
        delay = 0;
        if nargin < 5
            tmax = 10;
            if nargin < 4
                beta = 0.01;
                if nargin < 3
                     size = 10000;
                     if nargin < 2
                        pc=0.5; %probability of cinema (compared to pirating: p_pirating = 1-pc)
                        if nargin < 1  
                            p_pc = 0;%probability of going to cinema instead of pirating if piracy becomes unavailable
                        end
                     end
                end
            end
        end
    end
    decayinit = 0.001;
end
p_EG = 0.01;
%% Notes
% Referencepages to look at:
% neighbors, degree, graph, Modify Nodes and Edges of Existing Graph, Directed and Undirected Graphs
%% Set up of matrix
[matrix] = generate_EG (size,p_EG);
%% generate graph (and adjacency matrix)
[graphm] = creategraph (matrix);
% [adjacencym, graphm] = createadjm (matrix);
%% generate stats to "adjacencym"
nrnodes = numnodes(graphm); % number of nodes
stats = zeros(nrnodes,1); % generate stats
stats_no_pirate = zeros(nrnodes,1); % generate stats for pirateless
statssave = zeros(nrnodes,tmax); % generates saving for stats
statssave_no_pirate = zeros(nrnodes,tmax); % generates saving for stats_no_pirates
% typesave(:,1) = type; % is zero already
%% preallocation
decay = decayinit;
rainparam_cinema = 0.995;% hardcoded number; generates rain only if rand is bigger than ~
randmatrix = rand(nrnodes*tmax,1); % generates random matrix, so it doesn't have always to calculate it
%% loop
loopnr = 1;
while loopnr < (nrnodes)*tmax %
    %% pick random node
    nodeii = randi(nrnodes); % generates random node
    %% rain infection
    if randmatrix(loopnr)*decay > rainparam_cinema % gets called only if rand is bigger then set parameter, decays over time as well, not to make everyone a seeder
        if  stats(nodeii) == 0 % only runs if the node hasn't watched the movie
            stats = raining(stats,nodeii); %generates some noise in the graph, and also starts spreading
        end
        if stats_no_pirate(nodeii) == 0
            stats_no_pirate = raining(stats_no_pirate,nodeii);% for without pirate
        end
    end
    
    %% spread infection
    if loopnr<=(nrnodes)*delay
        [stats] = spreading_no_piracy(graphm,stats,nodeii,beta,decay,pc,p_pc); %spreads the infections
        [stats_no_pirate] = spreading_no_piracy(graphm,stats_no_pirate,nodeii,beta,decay,pc,p_pc); %spreads the infections without piracy
    elseif loopnr>(nrnodes)*delay
        [stats] = spreading(graphm,stats,nodeii,beta,decay,pc); %spreads the infections
        [stats_no_pirate] = spreading_no_piracy(graphm,stats_no_pirate,nodeii,beta,decay,pc,p_pc); %spreads the infections without piracy
    end
    %% save stats
    if ~mod(loopnr,size) % save stats after calculations for "every entry"
        statssave(:,loopnr/nrnodes) = stats; %saves the stats
        statssave_no_pirate(:,loopnr/nrnodes) = stats_no_pirate; % for without pirate
        %% Decay of interest
        % decaying beta factor by decay factor, to decrease increase in
        % spreading, inside the if statement, so every nodenr iteration
        % the decay gets updated
        decay = lowerinterest(decayinit,loopnr/nrnodes); % function which lets the interest decrease
        
        %% Debugging
        % some sort of code has to be written, to debug the programm for
        % parameter optimization and visualization
%         p = plot(graphm); % plots the graph
%         t = text(-8.5,-8.5,num2str(loopnr/nrnodes)); % plots the number of current state
%         graphm.Nodes.NodeColors = stats; % assigns the stats to the nodes
%         p.NodeCData = graphm.Nodes.NodeColors; % pinns the stats to the colordata
%         caxis([0 3]) % fixes the coloraxis at 0 and 3;
%         colormap ('jet') % uses a colormap for best visibiliy of what is going on
%         set(p,'MarkerSize',10)
%         pause (0.005)
%         set(t,'Visible','off')
%         p.NodeColor(find(stats(:,end)==2)) = 'red';
        %% break if the spreading is over for all the nodes
        if stats % every node has been assigned a status
            statssave = statssave(:,1:loopnr/nrnodes);
            break;
        end
    end
loopnr = loopnr + 1;
end
nrcinema = sum(stats(:) == 1);
nrpirates = sum(stats(:) == 2);
nrseeders = sum(stats(:) == 3);
nrcinema_no_pirates = sum(stats_no_pirate(:) == 1);% for without pirate
ratio = nrcinema/nrcinema_no_pirates;
end

