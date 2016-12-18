%% INVESTIGATION PARAMETERS
seedrandom = RandStream.getGlobalStream; %set and get the local random parameter
%% Preallocate stats
% delay = 25; % time without pirating
tmax = 100; % maximum timesteps
decayinit = 0.0001; % decay of interest
% p_EG = ln(size)/size; % probability of links between nodes
%% Investigation parameters
% betamin = 0.01; % minimum beta
% betamax = 0.000001; % maximumbeta
beta = 2*10^-4;
% sizemin = 10; % minimum size
% sizemax =  5000;% maximum size absolute max:3.25*10^4;
size = 1000;
%% Investigation resolution
numberruns = 50; % number of averaging
numberofinvestssize = 5; % number of size steps > 1 /otherwhise only the sizemax value will be evaluated
% numberofinvestbeta = 5; % number of betastes  > 1 /otherwhise only the betamax value will be evaluated
%% Intiate progress bar
progressstep = 1/(numberruns*numberofinvestssize*numberofinvestbeta); % setup for progressbar
progress = 0; 

P = waitbar(progress,'Estimated time remaining: unknown','Name','Progress of Simulation');
tic %start timemeasurement 
%% Setup of saving matrix
ratiosave = zeros(numberofinvestssize,numberofinvestbeta,numberruns);
%% ########### Main Loop ###########
for n = 1:numberruns
    sizenr = 1;
    betanr = 1;
    for delay = 0:2:100
        p_EG = log(size)/size; % sets p_EG to a critical value
%         for beta = linspace(10^-3,10^-6,numberofinvestbeta)
            %% Running the programm for different parameters
            [statssave,statssave_no_pirate,graphm,stats,ratio] = masterpirate(size,beta,tmax,delay,decayinit,p_EG);
            %% Saving ratio
            ratiosave(sizenr,betanr,n) = ratio; % save ratio for plot;
            %% Saving Stats
            % set up name
            name = {mat2str(size),mat2str(beta),mat2str(tmax),mat2str(delay),mat2str(decayinit),mat2str(n),'.mat'}; %##
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
%             betanr = betanr+1;
            %% update progessbar
            progress = progress + progressstep;
            timepassed = toc; % get passed time
            timeremain = round(timepassed/progress);
            progessname = strjoin({'Estimated time Remaining: ', mat2str(timeremain), 'sec'});
            waitbar(progress,P,progessname)
%         end
        %% increase saving param for ratio
        sizenr = sizenr+1;
%         betanr = 1; % reset for datasaving
    end
end
%% Close waitbar
close (P) % closes the waitbar
%% Final Calculations
ratiomean = mean(ratiosave,3); % takes the mean along the numberruns direction
ratiostd = std(ratiosave,0,3); % takes the std along the numberruns direction
%% Plot Phase Diagram
% set up axis
size =linspace(sizemin,sizemax,numberofinvestssize);
beta = linspace(10^-3,10^-6,numberofinvestbeta);
% plot results
surfgrid = surf(size,beta,ratiomean,ratiostd); 
xlabel('Size')
ylabel('beta')
zlabel('Ratio')
colorbar()
% plotcolor  = pcolor(size,beta,ratiomean);
%% Save total work
save('finished')



