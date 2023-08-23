clear all

addpath functions/
path2stim = [cd '/base tones/'];
path2sequences= [cd '/sequences/'];

dimensions = {'pitch','duration','passive'};

tone_rate = 5; % 5 Hz presentation rate
attended_dim = 3; 
dim1changes = 2;
dim2changes = 3;

nreps = 20;
nlevels = 2;
num_quiet = 4;
stimlength = 480;
num_blocks = 4;

three = sort(randsample(1:4,3));
five = sort([1:4 setdiff(1:4,three)]);

tone_length = 1/tone_rate;
fs = 44100; % default fs
amp_quiet = 0.25; % default amplitude decrease

dim1length = stimlength/dim1changes;
dim2length = stimlength/dim2changes;

% Create click sequence 
[click_train,click_timings] = make_clicks(1/1.2,96,10,fs); % 5 hz
click_train = [zeros(fs,1);click_train];
click_train = click_train*0.8;


for block = 1:num_blocks
    if block == 1
        oddball_vec = three;
    elseif block == 4
        oddball_vec = five;
    else
        oddball_vec = [1:4];
    end

    % Pseudorandom order and insert repetitions
    if dim1changes == 0
        dim1 = ones(1,stimlength);
    elseif dim1changes > 0
        order = randsample(nlevels,2);
        dim1 = repmat(order,dim1length/nlevels,1);
        dim1 = dim1(1:end-nreps);

        keepLooping = true;
        while keepLooping
            indx1 = find(dim1==1);
            indx1 = indx1(indx1 > 6 & indx1 < length(dim1)-6);
            indx2 = find(dim1==2);
            indx2 = indx2(indx2 > 6 & indx2 < length(dim1)-6);
            indx = sort([randsample(indx1,nreps/nlevels);randsample(indx2, nreps/nlevels)]);
            if (diff(indx)<=2) == zeros(1,length(indx)-1); break; else; end
        end
        dim1 = dim1';
        indx = indx';

        dim1 = add_repetitions(dim1,indx,dim1changes,nreps);
    end

    clear indx1 indx2 indx

    if dim2changes == 0
        dim2 = ones(1,stimlength);
    elseif dim2changes > 0
        order = randsample(nlevels,2);
        dim2 = repmat(order,dim2length/nlevels,1);
        dim2 = dim2(1:end-nreps);

        keepLooping = true;
        while keepLooping
            indx1 = find(dim2==1);
            indx1 = indx1(indx1 > 6 & indx1 < length(dim2)-6);
            indx2 = find(dim2==2);
            indx2 = indx2(indx2 > 6 & indx2 < length(dim2)-6);
            indx = sort([randsample(indx1,nreps/nlevels);randsample(indx2, nreps/nlevels)]);
            if (diff(indx)<=2) == zeros(1,length(indx)-1); break; else; end
        end
        dim2 = dim2';
        indx = indx';

        dim2 = add_repetitions(dim2,indx,dim2changes,nreps);
    end


    % Get # and position of repetitions
    for i = 1:stimlength-dim1changes
        dim1reps_log(i+dim1changes) = dim1(i)==dim1(i+dim1changes);
    end

    for i = 1:stimlength-dim2changes
        dim2reps_log(i+dim2changes) = dim2(i)==dim2(i+dim2changes);
    end

    % Get tone onsets
    t = (0:tone_length:stimlength*tone_length); 
    t = t(1:end-1);

    % Get the time points and indices of the repetitions of dimensions 1 & 2
    if nreps==0
        dim1pos=0;
        t_dim1pos = 0;

        dim2pos=0;
        t_dim2pos = 0;
    elseif nreps>0
        dim1pos = find(dim1reps_log==1);
        dim1pos = dim1pos(1:dim1changes:end); % select only first in repetition sequence
        t_dim1pos = t(dim1pos);

        dim2pos = find(dim2reps_log==1);
        dim2pos = dim2pos(1:dim2changes:end); % select only first in repetition sequence
        t_dim2pos = t(dim2pos);
    end 

    %% Generate vector for alternating polarities
    alt_pol = alternate_polarities(dim1,stimlength,true);
    for i = 1:length(alt_pol)
        alt_pol_new(:,i) = repmat(alt_pol(i),fs*(1/tone_rate),1); % NOTE: MAKES ASSUMPTION ABOUT SAMPLING RATE AND PRESENTATION RATE
    end

    %% Decide which stimuli will be modulated in amplitude

    toneid = [];
    for i = 1:stimlength
        if dim1(i)==1 && dim2(i) == 1
            toneid(i) = 1;
        elseif dim1(i)==1 && dim2(i) == 2
            toneid(i) = 2;
        elseif dim1(i)==2 && dim2(i) == 1
            toneid(i) = 3;
        elseif dim1(i) == 2 && dim2(i) == 2
            toneid(i) = 4;
        end
    end


    if num_quiet ==0
        amp_vec = ones(1,stimlength);
        amp_vec_quiet = repmat(amp_vec,tone_length*fs,1);
    else
        dim1_rep_pos1 = find(dim1reps_log); % indices of repetitions 
        dim1_rep_pos2 = dim1_rep_pos1-dim1changes; % indices of stimuli just before repeition
        dim1_rep_pos3 = dim1_rep_pos2-dim1changes; % quiet tone can't be immediately before the repetition
        dim1_rep_pos4 = dim1_rep_pos1+dim1changes; % quiet tone can't be immediately after repetition

        dim2_rep_pos1 = find(dim2reps_log);
        dim2_rep_pos2 = dim2_rep_pos1-dim2changes;
        dim2_rep_pos3 = dim2_rep_pos2-dim2changes; 
        dim2_rep_pos4 = dim2_rep_pos1+dim2changes; 

        rep_pos_vec = unique(sort([dim1_rep_pos1 dim1_rep_pos2 dim1_rep_pos3 dim1_rep_pos4 dim2_rep_pos1 dim2_rep_pos2 dim2_rep_pos3 dim2_rep_pos4]));

        sub_sample = setdiff(24:stimlength-48,rep_pos_vec);

        keepLooping = true;
        while keepLooping
            ind_quiet = randsample(sub_sample,length(oddball_vec));
            if (diff(ind_quiet)<=24) == zeros(1,length(ind_quiet)-1); break; else; end
        end

        amp_vec = ones(1,stimlength);
        
        ind_quiet = ind_quiet + 24;
        
        for i = ind_quiet
            amp_vec(i) = amp_vec(i).*amp_quiet;
        end

        for i = 1:length(amp_vec)
            amp_vec_quiet(:,i) = repmat(amp_vec(i), 1, tone_length*fs);
        end
    end

    % Create audio files
    temp = dir([path2stim '*.wav']);

    stimlist = {};
    for i = 1:length(temp)
        stimlist{i,1} = temp(i).name;
    end

    clear temp

    % Read in tones and save into cell
    for i = 1:length(stimlist)
        temp = audioread(strcat(path2stim,(stimlist{i})));
        temp = [temp;zeros((tone_length*fs)-length(temp),1)];
        stim{i} = temp;
    end
    stim = stim';

    % Reshape stimlist and stim into 2x2 array
    stimlist = {stimlist{1:2}; stimlist{3:4}};
    stim = {stim{1:2}; stim{3:4}};
    stimind = [1:2;3:4];

    % Create sequence of tones
    for i = 1:stimlength
        s(i) = stim(dim1(i),dim2(i)); % select tone corresponding to dimx (row) and dimy (column)
        snames{i} = stimlist{dim1(i),dim2(i)}; % save tone names
        sind(i) = stimind(dim1(i),dim2(i));
        sdim1(i) = dim1(i); % save the sequence corresponding to dimension x
        sdim2(i) = dim2(i); % save the sequence corresponding to dimension y
    end


    % Re-shape stimulus into single stream  
    s = cell2mat(s); % convert cell to matrix
    s = s.*alt_pol_new; % multiply by alternating polarities vector
    s = s.*amp_vec_quiet;
    s = reshape(s,[length(s)*stimlength,1]); % reshape 

    % Create output  
    stimulus = [zeros(fs,1);s];


    if attended_dim==1 
        timings.targetData = round(t_dim1pos,3) + 1;
        timings.distractorData = round(t_dim2pos,3) + 1;
        timings.quietData = sort(t(ind_quiet)) + 1;
    elseif attended_dim==2
        timings.targetData = round(t_dim2pos,3) + 1;
        timings.distractorData = round(t_dim1pos,3) + 1;
        timings.quietData = sort(round(t(ind_quiet),3)) + 1;
    end
    if attended_dim==3
        timings.targetData = round(sort(t(ind_quiet))+ 1,3);
        timings.pitchData = round(t_dim1pos,3) + 1;
        timings.durData = round(t_dim2pos,3) + 1;
    end

    timings = jsonencode(timings);
        

    info = [num2cell(t+1)',snames',num2cell(toneid)', num2cell(dim1), num2cell(dim2),num2cell(dim1reps_log)',num2cell(dim2reps_log)',num2cell(alt_pol)',num2cell(amp_vec)'];
    info_col = {'tone_onset','stimuli','tone','dim1','dim2','dim1_reps','dim2_reps','polarities','amplitude'};
    info = array2table(info,'VariableNames',info_col);

    stim_name = strcat(path2sequences,[dimensions{attended_dim} '_pitch' num2str(dim1changes) '_' num2str(block)]);  
    timings_text = fopen(strcat(stim_name,'.json'),'w');
    writetable(info,strcat(stim_name,'.csv'));
    fprintf(timings_text,timings);
    stim = [stimulus,click_train];
    audiowrite(strcat(stim_name,'_chan1.wav'), stimulus, 44100); % I can't remember why I saved out just the first channel...?
    audiowrite(strcat(stim_name,'.wav'), stim, 44100);

   clear timings stim stimlist s
end




