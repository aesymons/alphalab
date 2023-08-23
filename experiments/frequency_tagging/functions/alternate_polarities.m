function alt_pol = alternate_polarities(dimx,stimlength,randomise)
% alternate polarities
%tone_length = 0.25; % tones are 250 ms in length
%fs = 44100; % sampling rate
%alt_pol = zeros(stimlength,1);

if randomise==true
    dimx_ones = find(dimx==1);
    dimx_twos = find(dimx==2);
    dimx_threes = find(dimx==3);
    dimx_fours = find(dimx==4);

    pos_ones = randsample(dimx_ones,length(dimx_ones)/2);
    pos_twos = randsample(dimx_twos,length(dimx_twos)/2);
    pos_threes = randsample(dimx_threes,length(dimx_threes)/2);
    pos_fours= randsample(dimx_fours,length(dimx_fours)/2);
    pos_ind = sort([pos_ones,pos_twos,pos_threes,pos_fours]);

    neg_ones = setdiff(dimx_ones,pos_ones);
    neg_twos = setdiff(dimx_twos,pos_twos);
    neg_threes = setdiff(dimx_threes,pos_threes);
    neg_fours = setdiff(dimx_fours,pos_fours);
    neg_ind = sort([neg_ones,neg_twos,neg_threes,neg_fours]);
elseif randomise==false
    pos_ind = [1:2:stimlength];
    neg_ind = [2:2:stimlength];
end

for i = pos_ind
    alt_pol(i)=1;
end
for i = neg_ind
    alt_pol(i)=-1;
end

end