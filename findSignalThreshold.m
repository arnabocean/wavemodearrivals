function thresh = findSignalThreshold(vctr)


%   findSignalThreshold. Identify threshold value where signal amplitude changes.
%
%   Inputs:
%
%      - vctr: Input vector
%
%   Outputs:
%
%      - thresh: Threshold value of amplitude calculated
%
%   Other m-files required: None.
%   Sub-functions required: None.
%   MAT-files required: None.
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
%   Last Revised:   Thursday, May 18, 2017
%


%%	Parameters

strt = 1; endd = 25; incr = 20;

noisemin = 1E-6;
upcntlim = 2;

%%
thresh = [];
flag1 = 1; flag2 = 0;
upcnt = 0;

%%

while flag1 == 1

	%%	Find mean value of portion of signal

	if ~isempty(thresh)
		tmpthresh = thresh;		%	Save previous value temporarily
	end

	thresh = mean(vctr(strt:endd));
    
    strt = strt + incr;
	endd = endd + incr;

	%%	Decide if current thresh value meets certain criteria

	if thresh > noisemin		%	We want this condition to be true successively, >upcntlim times
		flag2 = 1;
		upcnt = upcnt + 1;
		
        if upcnt > 1
			thresh = tmpthresh;	%	Restore previously saved value, i.e. the first time when thresh > noisemin occurred
        end
	elseif thresh <= noisemin && flag2 == 1		%	If "successive" streak expires, reset counters
        flag2 = 0;
		upcnt = 0;
	end

	%%	End while loop

    if endd > length(vctr) || (thresh > noisemin && upcnt > upcntlim)
        flag1 = 0;
    end

end



