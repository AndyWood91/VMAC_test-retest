sca;
clear all

commandwindow;

global DATA exptName MainWindow
global bColour white screenWidth screenHeight
global sessionNumber cueBalance
global soundPAhandle winSoundArray loseSoundArray
global datafilename

exptName = 'EIB_rewExp';

bColour = [0 0 0]; % black
white = [255, 255, 255];

KbName('UnifyKeyNames');    % Supposedly important to standardise keyboard input across platforms / OSs.

%% Back to more sensible things

functionFoldername = fullfile(pwd, 'functions');    % Generate file path for "functions" folder in current working directory
addpath(genpath(functionFoldername));       % Then add path to this folder and all subfolders

imageFoldername = fullfile(pwd, 'images');    % Generate file path for "images" folder in current working directory
addpath(genpath(imageFoldername));       % Then add path to this folder and all subfolders


InitializePsychSound;

[winSoundArrayMono, sndFreq] = audioread('winSound.wav');     % read in win sound
[loseSoundArrayMono, sndFreq] = audioread('loseSound.wav');     % read in lose sound

winSoundArray = [winSoundArrayMono, winSoundArrayMono];
loseSoundArray = [loseSoundArrayMono, loseSoundArrayMono];

testVersion = 1;

if testVersion == 1     % Parameters for development / debugging
%    Screen('Preference', 'SkipSyncTests', 2);      % Skips the Psychtoolbox calibrations
    Screen('Preference', 'SkipSyncTests', 1);
    screenNum = 1;
    soundLatency = 0;
else     % Parameters for running the real experiment
    Screen('Preference', 'SkipSyncTests', 0);
    screenNum = 0;
    soundLatency = 1;
end    


soundPAhandle = PsychPortAudio('Open', [], 1, soundLatency, sndFreq);


keyResponse = 'a';
while keyResponse ~= 'y' && keyResponse ~= 'Y' && keyResponse ~= 'n' && keyResponse ~= 'N' 
    PsychPortAudio('FillBuffer', soundPAhandle, winSoundArray');
    PsychPortAudio('Start', soundPAhandle);
    keyResponse = input('Is volume OK? (y / n / blank to hear again) ---> ', 's');
    if isempty(keyResponse); keyResponse = 'a'; end
end

if keyResponse == 'n' || keyResponse == 'N'
    fprintf(1, '\nQuitting script. Change volume and then run the script again.\n\n');
    PsychPortAudio('Close', soundPAhandle);
    clear all;
    return
end


% Check to see if subject data folder exists; if not, create it.
datafoldername = ['SubjData_', exptName];
if exist(datafoldername, 'dir') == 0
    mkdir(datafoldername);
end


if testVersion == 1
    p_number = 1;
    sessionNumber = 1;
    cueBalance = 2;
    orderBalance = 2;
    p_sex = 'm';
    p_age = 123;
    
    % this needs to change
    datafilename = [datafoldername, '\', exptName, '_dataP', num2str(p_number), '.mat'];
    
else
    
    inputError = 1;
    
    while inputError == 1
        inputError = 0;
        
        p_number = input('Participant number  ---> ');
        
        datafilename = [datafoldername, '\', exptName, '_dataP', num2str(p_number), '.mat'];
        
        if exist(datafilename, 'file') == 2
            disp(['Data for participant ', num2str(p_number),' already exist'])
            inputError = 1;
        end
        
    end
    
    cueBalance = mod(p_number, 2) + 1;
%     while cueBalance < 1 || cueBalance > 4
%         cueBalance = input('Cue counterbalance (1-4) ---> ');      % 1 = birds rewarded, 2 = cars rewarded
%         if isempty(cueBalance); cueBalance = 0; end
%     end
    
    
    p_sex = 'a';
    while p_sex ~= 'm' && p_sex ~= 'f' && p_sex ~= 'M' && p_sex ~= 'F'
        p_sex = input('Participant gender (M/F) ---> ', 's');
        if isempty(p_sex); p_sex = 'a'; end
    end
    
    p_age = input('Participant age ---> ');
    
end

DATA.subject = p_number;
DATA.cueBal = cueBalance;
DATA.age = p_age;
DATA.sex = p_sex;
DATA.start_time = datestr(now,0);

DATA.session_Bonus = 0;
DATA.session_Points = 0;
DATA.actualBonusSession = 0;
DATA.totalBonus = 0;

% generate a random seed using the clock, then use it to seed the random
% number generator
rng('shuffle');
randSeed = randi(30000);
DATA.rSeed = randSeed;
rng(randSeed);



%% Set up screens

MainWindow = Screen('OpenWindow', 0);

DATA.frameRate = round(Screen(MainWindow, 'FrameRate'));

Screen('TextFont' , MainWindow ,'Segoe UI' );
Screen('TextSize', MainWindow, 46);
Screen('TextStyle', MainWindow, 0);


[screenWidth, screenHeight] = Screen('WindowSize', MainWindow);

HideCursor;

instrWindow = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextFont', instrWindow, 'Segoe UI');
Screen('TextStyle', instrWindow, 0);
Screen('TextSize', instrWindow, 40);

%% Read in images

global rewardImages numRewardImages
global neutImages numNeutImages
global baselineImages numBaselineImages
global targetImages numTargetImages targetRotation

% session check here
% if sessionNumber == 1
%     
%     if cueBalance == 1
%         [rewardImages, numRewardImages, ~] = readInImages([imageFoldername, '\BIRDPICS'], 0);
%         [neutImages, numNeutImages, ~] = readInImages([imageFoldername, '\BICYCLEPICS'], 0);
%     else
%         [rewardImages, numRewardImages, ~] = readInImages([imageFoldername, '\BICYCLEPICS'], 0);
%         [neutImages, numNeutImages, ~] = readInImages([imageFoldername, '\BIRDPICS'], 0);
%     end
% 
% elseif sessionNumber == 2
%     
%     if cueBalance == 1
%         [rewardImages, numRewardImages, ~] = readInImages([imageFoldername, '\CARPICS'], 0);
%         [neutImages, numNeutImages, ~] = readInImages([imageFoldername, '\CHAIRPICS'], 0);
%     else
%         [rewardImages, numRewardImages, ~] = readInImages([imageFoldername, '\CHAIRPICS'], 0);
%         [neutImages, numNeutImages, ~] = readInImages([imageFoldername, '\CARPICS'], 0);
%     end
% 
% end

if cueBalance == 1
    [rewardImages, numRewardImages, ~] = readInImages([imageFoldername, '\BIRDPICS'], 0);
    [neutImages, numNeutImages, ~] = readInImages([imageFoldername, '\BICYCLEPICS'], 0);
else
    [rewardImages, numRewardImages, ~] = readInImages([imageFoldername, '\BICYCLEPICS'], 0);
    [neutImages, numNeutImages, ~] = readInImages([imageFoldername, '\BIRDPICS'], 0);
end

[baselineImages, numBaselineImages, ~] = readInImages([imageFoldername, '\ColourScenes'], 0);
[targetImages, numTargetImages, targetRotation] = readInImages([imageFoldername, '\EBY_Targets'], 1);

DATA.numRewardImages = numRewardImages;
DATA.numNeutImages = numNeutImages;
DATA.numBaselineImages = numBaselineImages;
DATA.numTargetImages = numTargetImages; 




%% Run experiment

startSecs = GetSecs;

showInstructions1;
 
[~, ~] = runTrials(1);    % Practice with no salient distractors

showInstructions2;
[rewardPropCorrect, runningTotalPoints] = runTrials(2);    % Main expt starts


amountEarned = rewardPropCorrect * 12;  % Amount earned in dollars (0.5 correct gives $6, 1 correct gives $12)

amountEarned = amountEarned * 100;   % change to cents
amountEarned = 10 * ceil(amountEarned/10);        % ... round this value UP to nearest 10 cents
amountEarned = amountEarned / 100;    % ... then convert back to dollars


if amountEarned > 12    % This shouldn't be possible, but you never know
    amountEarned = 12;
elseif amountEarned < 6     % This is here in case there are any very unlucky dolts
    amountEarned = 6;
end

fid1 = fopen([datafoldername,'\_TotalBonus_summary.csv'], 'a');
fprintf(fid1,'%d,%d,%f,%f\n', p_number, runningTotalPoints, rewardPropCorrect, amountEarned);
fclose(fid1);

PsychPortAudio('Close', soundPAhandle);

DATA.end_time = datestr(now,0);
DATA.exptDuration = GetSecs - startSecs;
save(datafilename, 'DATA');

Screen('Flip',MainWindow);
[~, ny, ~] = DrawFormattedText(MainWindow, ['TASK COMPLETE\n\nPoints earned in this task = ', separatethousands(runningTotalPoints, ','), '\n\nCash bonus = $', num2str(amountEarned, '%0.2f'), '\n\nPlease fetch the experimenter'], 'center', 'center' , white, [], [], [], 1.3);
Screen('Flip',MainWindow);

rmpath(genpath(functionFoldername));       % remove path to this folder and all subfolders
rmpath(genpath(imageFoldername));       % remove path to this folder and all subfolders

RestrictKeysForKbCheck(KbName('ESCAPE'));   % Only accept escape key to quit
KbWait([], 2);
RestrictKeysForKbCheck([]); % Re-enable all keys


Screen('Preference', 'SkipSyncTests',0);

ShowCursor;

% Close all windows.
Screen('ClearAll');
Screen('CloseAll');

clear all;