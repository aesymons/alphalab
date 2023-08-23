%% Create dimension-selective attention stimuli

clear all
clc

%% Set univeral parameters
fs = 44100;
nlevels = 2;

%% Create base tones
outputPath = 'stimuli/base stimuli/';
f0_levels = [100 100*2^(1/12)];
dur_levels = [0.075 0.15];
num_harmonics = 4;

make_base_tones(f0_levels, dur_levels, num_harmonics, fs, outputPath)

%% Create example sequences
inputPath = 'stimuli/base stimuli/';
outputPath = 'stimuli/examples/';

make_example_sequences(inputPath,outputPath,nlevels,fs)

%% Create training stimuli 
inputPath = 'stimuli/base stimuli/';
outputPath = 'stimuli/training/';

tone_rate = 2; 
duration = 6; 
nlevels = 2;
ntrials = 4;

f0_changes = [2 3];
dur_changes = [3 2];

rep = [true false];

training_info = [];
row_names = {};

for m = 1:2
    for n = 1:2
        [info filenames] = make_training_sequences(tone_rate,duration,nlevels,ntrials,f0_changes(m),0,rep(n),0,inputPath,outputPath);
        training_info(size(training_info,1)+1:size(training_info,1)+ntrials,:) = info;
        row_names(length(row_names)+1:length(row_names)+ntrials) = filenames;
        
        [info filenames] = make_training_sequences(tone_rate,duration,nlevels,ntrials,0,dur_changes(m),0,rep(n),inputPath,outputPath);
        training_info(size(training_info,1)+1:size(training_info,1)+ntrials,:) = info;
        row_names(length(row_names)+1:length(row_names)+ntrials) = filenames;
    end
end

training_info = array2table(training_info, 'VariableNames',{'F0_Rate','Dur_Rate','F0_Rep_Position','Dur_Rep_Position','F0_Rep_Val','Dur_Rep_Val'},'RowNames',row_names);
writetable(training_info,'stimuli/csv_files/training_stimulus_info.csv','WriteRowNames',true)

%% Create main task stimuli 
inputPath = 'stimuli/base stimuli/';
outputPath = 'stimuli/main task/';

tone_rate = 2; 
duration = 6; 
nlevels = 2;
ntrials = 8;

f0_changes = [2 3];
dur_changes = [3 2];

f0_rep = [true true false false];
dur_rep = [true false true false];

task_info = [];
row_names = {};

for m = 1:2
    for n = 1:4
        [info filenames] = make_dsa_sequences(tone_rate,duration,nlevels,ntrials,f0_changes(m),dur_changes(m),f0_rep(n),dur_rep(n),inputPath,outputPath);
        task_info(size(task_info,1)+1:size(task_info,1)+ntrials,:) = info;
        row_names(length(row_names)+1:length(row_names)+ntrials) = filenames;
    end
end

task_info = array2table(task_info, 'VariableNames',{'F0_Rate','Dur_Rate','F0_Rep_Position','Dur_Rep_Position','F0_Rep_Val','Dur_Rep_Val'},'RowNames',row_names);
writetable(task_info,'stimuli/csv_files/main_stimulus_info.csv','WriteRowNames',true)

