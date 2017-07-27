function [pks,locs,wds,prms] = findPeaksTroughs(vctr)

%   findPeaksTroughs. Find local maxima and minima. 
%                     This is a custom version of findpeaks().
%
%   Inputs:
%
%      - vctr: Input signal vector.
%
%   Outputs:
%
%      - pks:	Values of peaks or troughs identified. Currently does
%               *not* check for Inf values or plateaus. Signal end-points
%               are excluded.
%      - locs:	Indices where the peaks occur.
%      - wds:	'Width' of each peak, defined as distance from previous
%               peak to next peak. This is DIFFERENT from MATLAB function.
%      - prms:	'Prominence' of each peak, defined by the min() of the
%               height difference between current peak, and previous 
%               and next peaks.
%

%   Other m-files required: None.
%   Sub-functions required: None.
%   MAT-files required: None.
%
%   See also: getExtensionArrival.m, getFlexureArrival.m.

%   Author:         Arnab Gupta
%                   Ph.D. Candidate, Virginia Tech.
%                   Blacksburg, VA.
%   Website:        http://arnabocean.com
%   Repository:     http://bitbucket.org/arnabocean
%   Email:          arnab@arnabocean.com
%
%   Version:        2.0
%   Last Revised:   Thursday, May 18, 2017


%%	Find diff of vector elements; create second diff vector offset by 1

dff = diff(vctr);

dff1 = 0;				%	to match length
dff1(2:length(dff)+1) = dff;
dff(end+1) = 0;			%	to match length

%%	Find product of successive elements of diff vector; 
%%	implemented here by element-wise multiplication of dff and dff1

mlt = [];
mlt = dff.*dff1;

mlt(1) = [];			%	Extra
mlt(end) = [];			%	Extra

%%	Find indices of interest

idx = find(mlt <= 0);	%	multiplication results in <=0 only for peaks or troughs

locs = idx+1;			%	Needs offset because 'diff' operation decreases length by 1
pks = vctr(locs);		

%%	Prepare to calculate prominence and widths

locs(2:end+1) = locs;	%	Pad ends with start and end values of vctr
locs(1) = 1;
locs(end+1) = length(vctr);

pks(2:end+1) = pks;		%	Pad ends with start and end values of vctr
pks(1) = vctr(1);
pks(end+1) = vctr(end);

%%	Calculate prominence and width values by cycling through vctor
for jj = 2: length(locs)-1

	%%	Calculate width values

	wds(jj) = locs(jj+1) - locs(jj-1);

	%%	Calculate left and right heights; find min() value

	lfp = abs(pks(jj)-pks(jj-1));
	rtp = abs(pks(jj+1)-pks(jj));

	prms(jj) = min(lfp,rtp);
end

%%	Remove excess elements introduced earlier

wds(1) = [];
prms(1) = [];
locs(1) = []; locs(end) = [];
pks(1) = []; pks(end) = [];

%%	Clear variables

clear dff dff1 mlt idx jj lfp rtp


