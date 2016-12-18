%% INVESTIGATION PARAMETERS
seedrandom = RandStream.getGlobalStream; 

%## set and get the local random parameter
investparam = 1;
investdeviation = 0;
%% Preallocate stats
delay = 0;
tmax = 100;
betamin = 0.001;
betamax = 0.000001;
sizemin = 100;
sizemax = 3.25*10^4;
decayinit = 0.0001;
p_EG = 0.0092103;

%
if investparam
    
    numberruns = 500;
    ratiosave = zeros(numberruns,1);
for n = 1:numberruns
    sizenr = 1;
    betanr = 1;
    numberofinvests = 5;
    ratiosave = zeros(numberofinvests);
    for size =linspace(sizemin,sizemax,numberofinvests)
        for beta = linspace(10^-3,10^-6,numberofinvests)
            %% Running the programm for different parameters
            [statssave,statssave_no_pirate,graphm,stats,ratio] = masterpirate(size,beta,tmax,delay,decayinit,p_EG);
            
            %% Saving ratio
            ratiosave(sizenr,betanr) = ratio; % save ratio for plot;
            
            %% Saving Stats
            % set up name
            name = {mat2str(size),mat2str(beta),mat2str(tmax),mat2str(delay),mat2str(decayinit),mat2str(n)}; %##
            savename = strjoin(name, '_'); % join strings
            % set up structure array
            savestruct.statssave = statssave; % struct save
            savestruct.statssave_no_pirate = statssave_no_pirate; % struct save #ok<STRNU>
            savestruct.graphm = graphm; % struct save
            savestruct.stats = stats; % struct save
            savestruct.ratio = ratio; % struct save
            % save the structure
            save(char(savename), '-struct', 'savestruct')
            %% increase saving param for ratio
            betanr = betanr+1;
        end
        %% increase saving param for ratio
        sizenr = sizenr+1;
    end
        end
    ratiomean = mean(ratiosave);
    ratiostd = std(ratiosave)/numberruns^2;
    
    %% Plot Phase Diagram
    % surfgrid = surf(size,beta,ratio);
    plotcolor  = pcolor(size,beta,ratio);
end
if investdeviation
    numberruns = 500;
    ratiosave = zeros(numberruns,1);
    for n = 1:numberruns
        %% Running the programm for different parameters
        [statssave,statssave_no_pirate,graphm,stats,ratio] = masterpirate(size,beta,tmax,delay,decayinit,p_EG);
        
        %% Saving ratio
        ratiosave(n) = ratio; % save ratio for plot;
        
        %% Saving Stats
        % set up name
        name = {mat2str(size),mat2str(beta),mat2str(tmax),mat2str(delay),mat2str(decayinit),mat2str(n)}; %##
        savename = strjoin(name, '_'); % join strings
        savename = strjoin({savename,'.mat'});
        % set up structure array
        savestruct.statssave = statssave; % struct save
        savestruct.statssave_no_pirate = statssave_no_pirate; % struct save #ok<STRNU>
        savestruct.graphm = graphm; % struct save
        savestruct.stats = stats; % struct save
        savestruct.ratio = ratio; % struct save
        % save the structure
        save(char(savename), '-struct', 'savestruct')
        %% increase saving param for ratio
    end
    ratiomean = mean(ratiosave);
    ratiostd = std(ratiosave)/numberruns^2;
end



