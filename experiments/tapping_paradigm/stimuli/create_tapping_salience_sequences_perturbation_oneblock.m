clear all


%% Create clicks (c) and silent intervals (si)

fs = 44100; % sample rate
c = zeros(1,fs/4);
c(1:10) = 0.9;
si = zeros(1,fs/4);

%% Read in stimulus

stimulus_file = 'A16_short.wav';
[stim,fs] = audioread(stimulus_file);

%% Apply cosine on/off ramp to stimulus 

rampsize = round(0.01*fs);
ramp = cos(pi:pi/rampsize:2*pi);
ramp = (ramp+1)/2;
stim(1:length(ramp)) = stim(1:length(ramp)).*ramp';
stim(end-length(ramp)+1:end) = stim(end-length(ramp)+1:end).*fliplr(ramp)';

%% Add 50 ms to the end of the stimulus (to make it last 250 ms)
stimulus = [stim' zeros(1,(fs/4)-length(stim))];

%% Adjust amplitude
stimulus = stimulus/max(abs(stimulus));
stimulus = stimulus.*0.9

%% Create click interval containing our stimulus
insert_sound = zeros(1,fs/2);
insert_sound(1:10) = 0.9;
insert_sound((fs*1)/4+1:(fs*1)/4+length(stimulus)) = stimulus;

%% Create sequence with starting with 10 clicks (no distractor)
sequence = [];
for n = 1:10
    sequence = [sequence c si];
end

%% Determine location of distractors
perturbations = Ranint(300);
for n = 1:34 % Note that right now there are 35 distractors in this sequence! You might want more or less depending on your design
    stop_now = 0;
    while stop_now == 0
        new_perturbation = Ranint(300);
        if min(abs(new_perturbation - perturbations)) >= 6 % at least 6 clicks (3 s) between distractors
            perturbations = [perturbations new_perturbation];
            length(perturbations)
            stop_now = 1;
        end
    end
end
perturbations = sort(perturbations);

%% Create stimulus sequence
stim_sequence = zeros(1,300);
stim_sequence(perturbations) = 1;

for n = 1:length(stim_sequence)
    if stim_sequence(n)==0
        sequence = [sequence c si];
    else
        sequence = [sequence insert_sound];
    end
end


%% Add 5 clicks to the end of the sequence
sequence = [sequence c si c si c si c si c si];

%% Add 10 to perturbations to account for 10 clicks before any distractor can occur
perturbations = perturbations + 10;

%% Create extra click sequence for practice trial
practice = [];
for n = 1:15
    practice = [practice c si];
end

audiowrite('click_sequence.flac',practice,fs);

%% Save out audio file and .mat file containing locations (intervals) with distractors
audiowrite('P01.flac',sequence,fs);
save('perturbation_oneblock1.mat','perturbations');
