function make_example_sequences(inputPath,outputPath,nlevels,fs,format)

% % Input parameters
%  inputPath = 'stimuli/speech/english speech/';
%  outputPath = 'stimuli/speech/examples/';
%  nlevels = 3;
%  fs = 44100;
%  format = 'flac';
 
% Assumes 2 Hz presentation rate for 6 second sequences

tone_rate = 2; 
duration = 6; 
stimlength = tone_rate*duration; 
tone_length = 1/tone_rate; 

% If no format path specified, look for flac
if ~exist('format','var')
  format = 'flac';
end

% Read in stimuli
temp = dir([inputPath '*.' format]);
stimlist = {};
stim = [];
for i = 1:length(temp)
    stimlist{i,1} = temp(i).name;
    [y fs] = audioread(strcat(inputPath,temp(i).name));    
    y = [y;zeros((tone_length*fs)-length(y),1)];
    stim{i} = y;
end

stimlist = reshape(stimlist,nlevels,nlevels);
stim = reshape(stim,nlevels,nlevels);


% Pitch and duration differences
for i = 1:nlevels
    pitch_files(:,i) = stim(2,i);
    dur_files(:,i) = stim(i,2);
end

pitch_diff = [];
dur_diff = [];
for i = 1:nlevels
    pitch_diff = [zeros(fs/10,1);pitch_diff;pitch_files{i};zeros(fs/10,1)];
    dur_diff = [zeros(fs/10,1);dur_diff;dur_files{i};zeros(fs/10,1)];
end
    
    
audiowrite([outputPath 'tones_pitch_difference.flac'],pitch_diff,fs)
audiowrite([outputPath 'tones_duration_difference.flac'],dur_diff,fs)

% Duration change 2, no change in pitch
pitch = ones(1,stimlength)+1;
dur = [1 1 2 2 1 1 2 2 1 1 2 2];
dur_rep = [1 1 2 2 1 1 2 2 2 2 1 1];

no_rep = [zeros(fs/4,1)];
with_rep = [zeros(fs/4,1)];
for i = 1:stimlength
    no_rep = [no_rep; stim{dur(i),pitch(i)}]; 
    with_rep = [with_rep; stim{dur_rep(i),pitch(i)}];
end

audiowrite([outputPath 'tones_example_pitch0_dur2_norep.flac'],no_rep,fs)
audiowrite([outputPath 'tones_example_pitch0_dur2_rep.flac'],with_rep,fs)

% Duration change 3, no change in pitch
pitch = ones(1,stimlength);
dur = [1 1 1 2 2 2 1 1 1 2 2 2];
dur_rep = [1 1 1 2 2 2 2 2 2 1 1 1];

no_rep = [zeros(fs/4,1)];
with_rep = [zeros(fs/4,1)];
for i = 1:stimlength
    no_rep = [no_rep; stim{dur(i),pitch(i)}]; 
    with_rep = [with_rep; stim{dur_rep(i),pitch(i)}];
end

audiowrite([outputPath 'tones_example_pitch0_dur3_norep.flac'],no_rep,fs)
audiowrite([outputPath 'tones_example_pitch0_dur3_rep.flac'],with_rep,fs)

% Pitch change 2, no change in duration
pitch = [1 1 2 2 1 1 2 2 1 1 2 2];
pitch_rep = [1 1 2 2 1 1 2 2 2 2 1 1];
dur = ones(1,stimlength);

no_rep = [zeros(fs/4,1)];
with_rep = [zeros(fs/4,1)];
for i = 1:stimlength
    no_rep = [no_rep; stim{dur(i),pitch(i)}]; 
    with_rep = [with_rep; stim{dur(i),pitch_rep(i)}];
end

audiowrite([outputPath 'tones_example_pitch2_dur0_norep.flac'],no_rep,fs)
audiowrite([outputPath 'tones_example_pitch2_dur0_rep.flac'],with_rep,fs)

% Pitch change 3, no change in duration
pitch = [1 1 1 2 2 2 1 1 1 2 2 2];
pitch_rep = [1 1 1 2 2 2 2 2 2 1 1 1];
dur = ones(1,stimlength)+1;

no_rep = [zeros(fs/4,1)];
with_rep = [zeros(fs/4,1)];
for i = 1:stimlength
    no_rep = [no_rep; stim{dur(i),pitch(i)}]; 
    with_rep = [with_rep; stim{dur(i),pitch_rep(i)}];
end

audiowrite([outputPath 'tones_example_pitch3_dur0_norep.flac'],no_rep,fs)
audiowrite([outputPath 'tones_example_pitch3_dur0_rep.flac'],with_rep,fs)

% Dimension-selective attention examples

f0_changes = 3;
dur_changes = 2; 

% Pitch change 3, Duration change 2
pitch = [1 1 1 2 2 2 1 1 1 2 2 2];
pitch_rep = [1 1 1 2 2 2 2 2 2 1 1 1];
dur = [1 1 2 2 1 1 2 2 1 1 2 2];
dur_rep = [1 1 2 2 1 1 2 2 2 2 1 1];

no_rep = [zeros(fs/4,1)];
with_pitch_rep = [zeros(fs/4,1)];
with_dur_rep = [zeros(fs/4,1)];
for i = 1:stimlength
    no_rep = [no_rep; stim{dur(i),pitch(i)}]; 
    with_pitch_rep = [with_pitch_rep; stim{dur(i),pitch_rep(i)}];
    with_dur_rep = [with_dur_rep; stim{dur_rep(i),pitch(i)}];
end
  
audiowrite([outputPath 'tones_example_pitch3_dur2_norep.flac'],no_rep,fs)
audiowrite([outputPath 'tones_example_pitch3_dur2_pitchrep.flac'],with_pitch_rep,fs)
audiowrite([outputPath 'tones_example_pitch3_dur2_durrep.flac'],with_dur_rep,fs)

% Pitch change 2, Duration change 3
dur = [1 1 1 2 2 2 1 1 1 2 2 2];
dur_rep = [1 1 1 2 2 2 2 2 2 1 1 1];
pitch = [1 1 2 2 1 1 2 2 1 1 2 2];
pitch_rep = [1 1 2 2 1 1 2 2 2 2 1 1];

no_rep = [zeros(fs/4,1)];
with_pitch_rep = [zeros(fs/4,1)];
with_dur_rep = [zeros(fs/4,1)];
for i = 1:stimlength
    no_rep = [no_rep; stim{dur(i),pitch(i)}]; 
    with_pitch_rep = [with_pitch_rep; stim{dur(i),pitch_rep(i)}];
    with_dur_rep = [with_dur_rep; stim{dur_rep(i),pitch(i)}];
end
  
audiowrite([outputPath 'tones_example_pitch2_dur3_norep.flac'],no_rep,fs)
audiowrite([outputPath 'tones_example_pitch2_dur3_pitchrep.flac'],with_pitch_rep,fs)
audiowrite([outputPath 'tones_example_pitch2_dur3_durrep.flac'],with_dur_rep,fs)

end
