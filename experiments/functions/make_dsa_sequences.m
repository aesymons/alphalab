function [info fnames] = make_dsa_sequences(tone_rate,duration,nlevels,ntrials,f0_changes,dur_changes,f0_rep,dur_rep,inputPath,outputPath,format)

 % If no output path specified, get stimuli in current folder
 if ~exist('inputPath','var')
      inputPath = '';
 end
 
 % If no output path specified, save file in current folder
 if ~exist('outputPath','var')
      outputPath = '';
 end
 
  % If no format path specified, look for flac
 if ~exist('format','var')
      format = 'flac';
 end

stimlength = tone_rate*duration;
tone_length = 1/tone_rate;


f0_len = stimlength/f0_changes;
dur_len = stimlength/dur_changes;

f0_order = randsample(repelem([1:nlevels],ntrials/nlevels),ntrials);
dur_order = randsample(repelem([1:nlevels],ntrials/nlevels),ntrials);

% Read in audio files
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

info = [];
fnames = {};


for n = 1:ntrials

    % F0 dimension
    f0_seq = randsample(nlevels,nlevels);
    for i = 1:f0_len-nlevels
        last_num = f0_seq(end);
        if nlevels > 2
            next_num = randsample(setdiff([1:nlevels],last_num),1);
        else
            next_num = setdiff([1:nlevels],last_num);
        end
        f0_seq(length(f0_seq)+1) = next_num;
    end

    if f0_rep == true
        f0_rep_level = f0_order(n);
        f0_pos = randsample(find(f0_seq(1:end-1)==f0_rep_level),1);
        f0_seq = add_repetitions(f0_seq,f0_pos,f0_changes,1);
        f0_seq = f0_seq(1:end-f0_changes);
    else
        f0_seq =repelem(f0_seq,f0_changes);
        f0_pos = 0;
        f0_rep_level = 0;
    end

    % Duration dimension
    dur_seq = randsample(nlevels,nlevels);
    for i = 1:dur_len-nlevels
        last_num = dur_seq(end);
        if nlevels > 2
            next_num = randsample(setdiff([1:nlevels],last_num),1);
        else
            next_num = setdiff([1:nlevels],last_num);
        end
        dur_seq(length(dur_seq)+1) = next_num;
    end


    if dur_rep == true
        dur_rep_level = dur_order(n);
        dur_pos = randsample(find(dur_seq(1:end-1)==dur_rep_level),1);
        dur_seq = add_repetitions(dur_seq,dur_pos,dur_changes,1);
        dur_seq = dur_seq(1:end-dur_changes);
    else
        dur_seq =repelem(dur_seq,dur_changes);
        dur_pos = 0;
        dur_rep_level = 0;
    end


    % Create sequence of tones
    s = [];
    for i = 1:stimlength
        s = [s; stim{dur_seq(i),f0_seq(i)}]; 
    end

    % Create output  
    stimulus = [zeros(fs/4,1);s];

    filename = [outputPath 'tones_pitch' num2str(f0_changes) '_dur' num2str(dur_changes) '_' num2str(f0_rep) '_' num2str(dur_rep) '_' num2str(n) '.flac'];
    audiowrite(filename, stimulus, fs);

    dims = size(info);
    info(dims(1)+1,:) = [f0_changes dur_changes f0_pos dur_pos f0_rep_level dur_rep_level];
    fnames{length(fnames)+1,1} = filename(length(outputPath)+1:end);
end

