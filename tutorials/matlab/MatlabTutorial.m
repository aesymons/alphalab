%% Matlab Tutorial: Session 1
% Friday, July 14

%% Understanding the Matlab interface

% Always make sure that you add the relevant folders to your path
% Remember no spaces are allowed in the path name! 
addpath /Users/ashley/Documents/work/lab_management/tutorials/scripts


%% Using Matlab as a calculator
% You can use Matlab just like a calculator by typing the problem you want
% to solve into the command window. Try the following: 

% Addition
2+2

% Subtraction
5 - 3

% Multiplication
10*2

% Division
256/32

% Matlab also has a number of inbuilt functions that perform common
% mathematical operations. For example, if we wanted to find the square
% root of a number, we could type:

sqrt(4)

% We can also do more complex maths. Just like with basic maths, we want to
% make sure to put parentheses around the operations we want to conduct
% first. Otherwise, Matlab will follow PEMDAS or whatever the UK equivalent
% is. For example, the two equations below will yield very different results: 

4+3*9

(4+3)*9

% But most of the time, we don't want to use Matlab as a calculator. We
% have phones for that these days, so let's move on.

%% Creating variables in Matlab
% In Matlab (and all programming languages), one useful thing we can do is
% create variables. For example, we can create a variable x and assign it a
% numeric value and another variable y and assign it a different numeric value: 

x = 4

y = 2

% We can now do basic algebra with these two variables:
x+y
x-y
x*y-(x+y)

% But variables don't just need to be numbers! They can be letters (or
% strings) as well. To take a classic example: 

x = 'Hello World!'

% You can combine variables containing strings, but you need to do it a
% little bit differently than numbers. For example: 

y = 'My name is Ashley'

z = [x y]

% Want a space between the two phrases?
z = [x ' ' y]

% When naming variables, x and y aren't very useful. When you have a script
% that is 100 lines long, will you really remember what x is? It's best
% practice to give our variables clear and transparent names. There are
% some rules for naming variables (e.g., can't contain spaces or start with
% a number). But aside from the hard and fast rules, there are certain
% conventions. different researchers use different conventions. Some use
% all lowercase variable names and separate them with an underscore
% (snakecase). Others use camelcase (words delimited by a capital letter
% except the first word). Either works! Choose what you like best. 

%% Matrices in Matlab
% So far, we've been assigning single numbers to a variable. But in most
% research contexts, we'll be working with vectors, or matrices. Say for
% example we have a questionnaire and are interested in looking at the mean
% age of the 9 participants in our sample. Here's how we create a vector
% in Matlab. Note the use of square brackets to combine these numbers

subject_age = [20 39 42 22 22 35 18 21 50 32]

% Importantly, we can do maths with matrices! To determine the mean of a
% matrix, we can use the mean function in Matlab

mean(subject_age)

% This will give you the same answer as:
(20 + 39 + 42 + 22 + 22 + 35 + 18 + 21 + 50 + 32)/10

% subject_age is a vector, or a 1 x 10 matrix (1 row and 10 columns). But
% what if we have multiple measurements that we want to compare? Let's say
% that we have our participants complete a speech perception task in quiet and
% noisy conditions. We can put the data in 2 separate vectors like this:

quiet_score = [75 91 38 100 99 95 87 79 95 91]

noise_score = [69 90 44 88 91 95 82 78 96 74]

% Or combine them into a single vector like this: 

data = [75 91 38 100 99 95 87 79 95 91;69 90 44 88 91 95 82 78 96 74]

% Now we have a 2 x 10 matrix, with the first row corresponding to scores
% in quiet and second row corresponding to scores in noise. Usually, we
% have subject as the row though, so let's change the shape of this
% dataframe. We can do this by using the ' symbol: 

data = data'

% Now what can we do with our new matrix? So many things! We can still get
% the mean score for each condition. For example: 

mean(data)

% To just get the mean score for the quiet condition (column 1), we can: 
mean(data(:,1))

% Let's say we want to add a row. For some reason there's a particiapnt
% missing from our dataset. We can add there scores a few different ways.
% One option is to do the following: 

data(end+1,:) = [75 68]

% But maybe we want to delete someone. For example, maybe we want to get
% rid of people who got < 50% in quiet because the task really isn't that hard. The
% first step is to find any scores that are < 50% in quiet. We can do this
% using the find function

find(data(:,1)<50)

% So now we know that it's the 3rd subject we want to delete. We can now
% delete their data using square brackets: 

data(3,:) = [];

% We can even run some basic stats, like conduct a ttest

[H,P,CI,STATS] = ttest(data(:,1),data(:,2))

%% Conditional statements
% Sometimes we might only want to perform certain operations if a certain
% thing is true or false. With Matlab, we can create boolean variables (one
% that has either true (1) or false (2) as its value. For example: 

x = true
y = false

z = 12>3

% Using boolean variables, we can create conditional statements. Why would
% we want to do this? Let's say that we have participants complete a
% questionnaire like the Autism Quotient. In many of these questionnaires,
% some questions are reverse coded (e.g., a 1 will correspond to a low AQ
% score while a 4 will correspond to a high AQ score). Therefore, we'll
% only want to reverse the score on some questions but not others. % Let's
% say we want to reverse score question 5 only (not realistic but will work
% for now). 

question = 5;
score = 1;

if question==5
    score = 5-score;
else
    score = score;
end

% We can also use multiple if statements. Say we don't like question 7 and
% just want to ignore it

question = 7;
score = 1;

if question==5
    score = 5-score;
elseif question == 7
    score = []
else
    score = score;
end

%% Looping in Matlab
% One of the great things about programming is that we can automate
% repetetive processes. Let's say we have 100 participants in our task.
% It'd be really tiring to go through the data one by one and remove
% participants who got < 50% correct. Instead, we can use a for loop

scores = randi(100,1,100);
my_data = [];

for n = 1:length(scores)
    
    if scores(n) > 50
        my_data = [my_data; scores(n)]
    end
    
end
        
% Did this work? Let's check using the min function 
min(my_data)
min(scores)

% We can also do while loops. These are useful if you need to redo a
% process over and over again until a certain condition is met. I most
% often use while loops while creating stimuli. Let's say I'm putting my
% stimuli in a pseudorandom order but want to make sure that there are no
% repeats. 

keepLooping = true;

order = [];
this_stimulus = randi(4,1); % randomly choose a stimulus to be first
order(1) = this_stimulus;

while keepLooping
    next_stimulus = randi(4,1);
    if next_stimulus ~= this_stimulus
        order = [order; next_stimulus];
        keepLooping = false;
    end
end

order

% We can nest for and while loops (say for example we want 4 different
% stimuli presented in a random order but with no repeats. Here's how we'd
% do that in Matlab: 

order = [];
this_stimulus = randi(4,1); % randomly choose a stimulus to be first
order(1) = this_stimulus;

for n = 1:99
    
  keepLooping = true;
   while keepLooping
        next_stimulus = randi(4,1);
        if next_stimulus ~= this_stimulus
            order = [order; next_stimulus];
            keepLooping = false;
            this_stimulus = next_stimulus;
        end
    end
    
end



order
    

%% Basic plotting 

% Histograms
random_numbers = randi(100,1,100);
figure;
hist(random_numbers)

% Line plots
time = 0:1/44100:0.1;
sound = sin(2 * pi * 200  * time);
figure;
plot(time,sound)
xlabel("Time")
ylabel("Amplitude")
title("Sine wave")

% Scatter plots
figure;
scatter(data(:,1), data(:,2),'r','lineWidth',2)
xlabel("Scores in quiet")
ylabel("Scores in noise")

