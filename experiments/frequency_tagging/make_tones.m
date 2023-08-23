num_harmonics = 4;
ramp_dur = 0.01;
Fs = 44100;

% Define parameters
f0_levels = [100 100*2^(1/12)];
dur_levels = [0.075 0.15];

rampsize = round(ramp_dur*Fs);
ramp = cos(pi:pi/rampsize:2*pi);
ramp = (ramp+1)/2;

for n = 1:length(f0_levels)
    for m = 1:length(dur_levels)
        dur = dur_levels(m);
        F0 = f0_levels(n);
        
        time_points = floor(Fs * dur);
        note1 = sin(2 * pi * F0  * (1:time_points)/Fs);
        
        for p = 2:num_harmonics
           note1 = note1 + sin(2 * pi * F0 * p * (1:time_points)/Fs);
        end
        
        x = note1;

        
        note1 = x./max(abs(x));
        note1 = note1.*0.9;
        
        note1(1:ceil(ramp_dur*Fs)+1) = note1(1:ceil(ramp_dur*Fs)+1).*ramp;
        note1(end-ceil(ramp_dur*Fs):end) = note1(end-ceil(ramp_dur*Fs):end).*(fliplr(ramp));
        
        audiowrite(['base tones/FreqTag_F0' num2str(n) '_DUR' num2str(m) '.wav'],note1,Fs);
    end
end


