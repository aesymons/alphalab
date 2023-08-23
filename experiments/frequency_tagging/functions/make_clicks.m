function [click_train, click_timings] = make_clicks(frq, duration, width, fs)
% function shamelessly stolen from someone else but modified by me
% (1) frq: stimulus frequency (unit: Hz)
% (2) dura: stimulus duration (unit: sec)
% (3) width: pulse width - NOW IN INDEXES 
% (4) fs: sampling frequency (unit: Hz)
%  ORIGINALLY written by Hio-Been Han, Jeelab, KIST, hiobeen@yonsei.ac.kr, 20170415

% EXAMPLE
% frq = 0.8; % click every 6 tones (tones 250 ms in length)
% duration = 120; 
% width = 10;
% fs = 44100;

total_duration = duration * fs;
click_train = zeros([total_duration,1]);

lencycle = fs*(1/frq);
click_indx = 1:lencycle:total_duration;
temp_outL = click_train;

for ind = click_indx
    temp_outL(ind:ind+(width-1)) = 1;
end

click_train = temp_outL(1:total_duration);
click_train(end)=0;

t = [1:length(click_train)]/fs;
click_timings = t(click_indx);
end

