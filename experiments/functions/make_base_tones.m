function make_base_tones(f0_levels,dur_levels,num_harmonics,Fs,outputPath)

 if ~exist('outputPath','var')
      outputPath = '';
 end


ramp_dur = 0.01;
ramp = 0:1/ceil(ramp_dur*Fs):1;

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
        
        audiowrite([outputPath 'FreqTag_F0' num2str(n) '_DUR' num2str(m) '.flac'],note1,Fs);
    end
end


