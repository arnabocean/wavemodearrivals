function flexIDX = getFlexureArrival(sgnl)


%   getFlexureArrival. Detect the index of signal when flexural wave mode arrives.
%
%   Inputs:
%
%      - sgnl: Input vector of ultrasonic acoustic wave.
%
%   Outputs:
%
%      - extIDX: Index value of sgnl where flexural wave mode is estimated
%                to have arrived.
%   
%   Other m-files required: findPeaksTroughs.m, findSignalThreshold.m.
%
%   See also: getExtensionArrival.m.


%   Author:         Arnab Gupta
%                   Ph.D. Candidate, Virginia Tech.
%                   Blacksburg, VA.
%   Website:        http://arnabocean.com
%   Repository:     http://bitbucket.org/arnabocean
%   Email:          arnab@arnabocean.com
%
%   Version:        1.0
%   Last Revised:   Wednesday, May 31, 2017


%%	Find Peaks and Troughs in signal

[pks,locs,~,prominence] = findPeaksTroughs(sgnl);

%%	Calculate paramater that scales peak values with a prominence value weight. Also normalize the parameter.

param = abs(pks.*prominence);
nrm = sort(param,'descend');
if nrm(1)/nrm(2) > 5
	param = param/nrm(2);	%   If there is one single very large peak, then use 2nd highest peak to normalize.
else
	param = param/nrm(1);	%   Else use the largest peak to normalize
end

%%  Evaluate appropriate threshold value

thresh = findSignalThreshold(param);

%%	Use threshold to identify significant peaks

idx = find(param>thresh,1);
if isempty(idx)
    flexIDX = 0;
    return;
end

%%	Arrival time corresponds to first significant peak

flexIDX = locs(idx);

%%

clear pks locs prominence param thresh idx absdat tstvctr

