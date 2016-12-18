function decay = lowerinterest(decayinit,time)
% takes the time passed, and the initial decay, to calculate the spreading-
% velocity
decay = exp(-decayinit*time); % returns a decaying factor
end

%% trial for parameters: 
% over the timestep 1:1000 t this function stays the in range from decayinit = 0 to
% decayinit = 6.93147 * 10^-4; 
% decayinitmax = log(2)/tmax;

% % Eval
% decayinit = linspace(10^-3,10^-5,20)
% figure
% for time = 1:1000
% decay(time,:) = exp(-decayinit*time);
% end
% for ii=1:20
% loglog(decay(:,ii))
% hold all
% end