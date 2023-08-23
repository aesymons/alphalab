clear all

to_plot = 'single'; % set to single to plot data from 1 subject (e.g., pilot)

%% Read in data
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s'; % # of strings should correspond to # of columns in your data file or else you will get an error
data = readtable('data/data.csv','Delimiter',',','Format',formatSpec);

%% Initiate variables

stim_index_file{1} = 'stimuli/perturbation_oneblock1.mat';

current_participant = 'dummy';
current_OS = 1;
tap_trials = [];
stim_sequence = [];
trial_temp{1} = [];
trial_index = 1;
dataset(1).id = data{1,13}; % this should correspond to the column that contains the participant ID

%% Read in tapping data

for n = 1:height(data)
    if length(strmatch(current_participant,data{n,13}{1})) < 1
        if length(strmatch(current_participant,'dummy')) == 0
            found_participant = 0;
        	for m = 1:length(dataset)
                if length(strmatch(dataset(m).id,current_participant))>0
                    dataset(m).tap_trials = trial_temp;
                    dataset(m).soundfile = soundfile;
                    dataset(m).OS = current_OS;
                    tap_intervals_temp = diff(dataset(m).tap_trials{1});
                    tap_intervals_center = tap_intervals_temp(tap_intervals_temp>490&tap_intervals_temp<510);
                    dataset(m).quantization = max(diff(sort(tap_intervals_center)));
                    trial_temp = {};
                    trial_temp{1} = [];
                    trial_index = 1;
                    found_participant = 1;
                end
            end
            if found_participant == 0
                dataset(end+1).id = current_participant;
                dataset(end).tap_trials = trial_temp;
                dataset(end).soundfile = soundfile;
                dataset(end).OS = current_OS;
                tap_intervals_temp = diff(dataset(end).tap_trials{1});
                tap_intervals_center = tap_intervals_temp(tap_intervals_temp>490&tap_intervals_temp<510);
                dataset(end).quantization = max(diff(sort(tap_intervals_center)));
                trial_index = 1;
                trial_temp = {};
                trial_temp{1} = [];
            end
        end
        current_participant = data{n,13}{1};
    end
    if length(strmatch('response_keyboard_single',data{n,36}{1})) > 0 & length(strmatch('main task',data{n,50}{1})) > 0
        trial_temp{trial_index}(end+1) = str2num(data{n,37}{1});
    end
    if length(strmatch('content_audio',data{n,36}{1})) > 0 & length(trial_temp) > 0 & length(strmatch('main task',data{n,50}{1})) > 0
        sound_delay = str2num(data{n,37}{1}) - 157500; % The number you subtract should correspond to the length of the sound file. Otherwise your timings will be wrong!
        soundfile{trial_index} = data{n,51}{1};
        trial_temp{trial_index} = trial_temp{trial_index} - sound_delay;
        trial_index = trial_index + 1;
        if trial_index < 2
            trial_temp{trial_index} = [];
        end
    end
end

%% Get taps 

beat_target_vector = [0:500:157500];

for n = 1:length(dataset)
    stim_trials{1} = ones(1,length(beat_target_vector))+9999;
    for p = 1:length(beat_target_vector)
        min_distance = 999999;
        for m = 1:length(dataset(n).tap_trials)
            for q = 1:length(dataset(n).tap_trials{m})
                if abs(dataset(n).tap_trials{m}(q) - beat_target_vector(p)) < abs(min_distance)
                    min_distance = (dataset(n).tap_trials{m}(q) - beat_target_vector(p));
                end
                 if abs(min_distance) < 250
                    stim_trials{m}(p) = min_distance;
                    min_distance = 9999;
                 end
            end
        end
    end
    dataset(n).stim_trials = stim_trials;
end


%% Compute tapping asynchrony 
all_data_index = 1;
for n = 1:length(dataset)
    data1_temp = [];
    data1_index = 1;
    for p = 1:length(dataset(n).stim_trials)
        load(stim_index_file{str2num(dataset(n).soundfile{p}(3))})
        perturbations = perturbations+1; % now perturbations correspond to click just after distractor (+250)
        for m = 1:length(perturbations)
            % temp vec = -750, -250, +250, +750, +1250, +1750
            temp_vector = [(dataset(n).stim_trials{p}(perturbations(m)-2:perturbations(m)-1)) dataset(n).stim_trials{p}(perturbations(m):perturbations(m)+3)];
            if max(abs(temp_vector)) < 250
                data1_temp(data1_index,:) = temp_vector;
                data1_index = data1_index + 1;
            end
        end
    end
    if data1_index > 32 % If you have 35 distractors (change # to correspond to your stimulus and the amount of trials you need)
        all_data1(all_data_index,:) = mean(data1_temp,1); % take mean across trials
        all_data_index = all_data_index + 1;
    end
end

%% Now compute change in tapping asynchrony

[a,b] = size(all_data1);

for n = 1:a
    all_data1(n,2:6) = all_data1(n,2:6) - all_data1(n,1:5);
    all_data1(n,1) = 0;
end

%% Plot data


all_data1 = all_data1(:,2:6);
all_data_mean = squeeze(mean(all_data1,1));
all_data_sterr = std(all_data1,0,1)/sqrt(length(all_data1));

figure
errorbar(1:5,all_data_mean,all_data_sterr,'lineWidth',1.5)
hold on
set(gca,'XTick',[1 2 3 4 5]);
xlim([0.5 5.5])
set(gca,'XTickLabel',{'-250','250','750','1250','1750'});
ylabel('Change in asynchrony (ms)')
xlabel('Time relative to distractor start (ms)')
set(gca,'FontSize',16)
box off

% SE will be 0 because we've just got 1 subject