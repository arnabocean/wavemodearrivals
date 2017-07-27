function extIDX = getExtensionArrival(sgnl,noisemult,noisemin)


%   getExtensionArrival. Detect the index of signal when extensional wave mode arrives.
%
%   Inputs:
%
%      - sgnl: Input vector of ultrasonic acoustic wave.
%      - noisemult: (Optional) Threshold multiplier, used to multiply 
%                   the initial noise portion to signal to determine 
%                   working threshold. Default value: 10.
%      - noisemin: (Optional) Absolute minimum noise value, to be used
%                  if actual noise content of signal is negligible.
%                  Default value: 1E-6
%
%   Outputs:
%
%      - extIDX: Index value of sgnl where extensional wave mode is estimated
%                to have arrived.
%
%   Other m-files required: findPeaksTroughs.m.
%   
%   See also: getFlexureArrival.m.


%   Author:         Arnab Gupta
%                   Ph.D. Candidate, Virginia Tech.
%                   Blacksburg, VA.
%   Website:        http://arnabocean.com
%   Repository:     http://bitbucket.org/arnabocean
%   Email:          arnab@arnabocean.com
%
%   Version:        1.0
%   Last Revised:   Wednesday, May 31, 2017



%%  Initialize optional variables

if ~exist('noisemin','var')
    noisemin = 1E-6;
end

if ~exist('noisemult','var')
    noisemult = 10;
end

%%  Find Peaks and Troughs in signal
[pks,locs,~,prominence] = findPeaksTroughs(sgnl);

%%  Calculate paramater that scales peak values with a prominence value weight. Also normalize the parameter.
param = abs(pks.*prominence);
nrm = sort(param,'descend');
if nrm(1)/nrm(2) > 5        
	param = param/nrm(2);      %   If there is one single very large peak, then use 2nd highest peak to normalize.
else
	param = param/nrm(1);      %   Else use the largest peak to normalize
end

%%  Calculate reference values of noise and amplitude threshold to test signal amplitude against
tmpidx = find(param==1,1);
nnlim = max(floor(locs(tmpidx)/4),floor(length(sgnl)/40));
nnlocs = find(locs<=nnlim,1,'last');    
clear tmpidx nnlim

refnoisemean = max(mean(param(1:nnlocs)),noisemin);
refmaxthresh = max(noisemult*refnoisemean,max(param(1:nnlocs)));

%%  Find mean signal value until certain conditions are met (if conditions are met before signal ends, loop can be ended quicker)
tstmean = []; cnt = 1; strt = 1;endd = strt+floor(nnlocs/2);
flag = 1;
while flag == 1
    
    %%
    tstmean(cnt,1) = strt;
    tstmean(cnt,2) = mean(param(strt:endd));
    
    strt = endd+1;
    endd = strt+floor(nnlocs/2);
    %%
    if endd > length(param) || tstmean(cnt,2) > refmaxthresh
        flag = 0;
    end
    cnt = cnt + 1;
end

clear cnt flag strt endd

%%  Make best guess for extIDX when the mean signal value NEVER meets the condition in loop above (i.e. loop ends when signal ends)

if tstmean(end,2) <= refmaxthresh
    %%
    idx = find(tstmean(:,2)<refnoisemean,1,'last');
    if isempty(idx)
        idx = 1;
    end

    param(1:tstmean(idx)) = [];
    locs(1:tstmean(idx)) = [];

    idx = find(param>refnoisemean,1);
    if isempty(idx)
        extIDX = 0;
        return;
    end

    extIDX = locs(idx);
    return;
end

%%  The 'else' case for the 'if' statement above (if terminates with 'return' command)
%%  Zoom into portion of signal where extensional mode definitely arrives

idx = find(tstmean(:,2)<refnoisemean,1,'last');
idx = tstmean(idx,1)-1;
param(1:idx) = [];
locs(1:idx) = [];

%%  ...continued.
idx = find(param>refmaxthresh,1);
param(idx+1:end) = [];
locs(idx+1:end) = [];

%%  Find best guess for extIDX from this small portion of the signal.
idx = find(param<=refnoisemean,1,'last');
extIDX = locs(idx+1);

if isempty(extIDX)
    try
        extIDX = locs(end-1);
    catch
        extIDX = locs(end);
    end
end

