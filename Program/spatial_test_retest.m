addpath('spatialfunctions');  % search the spatialfunctions directory for scripts and functions

% variable declarations
global MainWindow scr_centre DATA
global keyCounterbal starting_total exptSession
global distract_col colourName
global white black gray yellow
global bigMultiplier smallMultiplier
global zeroPayRT oneMSvalue nf
global datafilename

% Andy
% spatial = containers.Map('UniformValues', false);  % storing spatial data here
global testing


nf = java.text.DecimalFormat;  % this displays the thousands separator and decimals according the the computers' Locale settings 


screenNum = 0;  % use the primary screen


% set trial values
zeroPayRT = 1000;       % 1000
fullPayRT = 500;        % 500, I think this is unused
oneMSvalue = 0.1;

bigMultiplier = 10;    % Points multiplier for trials with high-value distractor
smallMultiplier = 1;   % Points multiplier for trials with low-value distractor

starting_total = 0;
keyCounterbal = 1;


% set from get_details
p_number = experiment('number');
exptSession = experiment('session');


% data 
% check for 'spatial_data' directory
if exist('spatial_data', 'dir') ~= 7
    mkdir('spatial_data');  % make it if it doesn't exist
end

datafilename = ['spatial_data/CirclesMultiDataP', p_number, 'S'];

   
test = testing;

if test == 1  % test version
    
    colBalance = 1;
    
elseif test == 0  % experimental version
    
    colBalance = experiment('counterbalance');
    
    % set some values
    if strcmp(exptSession, '1')  % first session
        
        starting_total = 0;
        
    elseif strcmp(exptSession, '2')  % second session
        
        % TODO: restructure this along with the data set
        
        load([datafilename, '1.mat'])  % load previous session's data
%         starting_total = ;
        
        %TODO: chance this to wherever I store it
        if isfield(DATA, 'bonusSoFar')
            starting_total = DATA.bonusSoFar;
        else
            starting_total = 0;
        end
        
    else
        
        error('variable "exptSession" isn''t set properly')
        
    end
    
else
    
    error('variable "test" isn''t set properly')
    
end

%% Daniel's participant details
% if test == 0
%     % First Session
%     if str2num(exptSession) == 1
%                 
%         colBalance = DATA.raw_data('counterbalance');
%         p_age = details('age');
%         p_sex = details('gender');
%         p_hand = details('hand');
%       
%     % Second Session
%     else
% 
%         load([datafilename, '1.mat'])
%         colBalance = DATA.counterbal;
%         p_age = DATA.age;
%         p_sex = DATA.gender;
%         p_hand = DATA.hand;
%         
%         if isfield(DATA, 'bonusSoFar')
%             starting_total = DATA.bonusSoFar;
%         else
%             starting_total = 0;
%         end
% 
%         disp (['Age:  ', p_age])
%         disp (['Sex:  ', p_sex])
%         disp (['Hand:  ', p_hand])
% 
%     end
% else
% end
%%

% generate a random seed using the clock, then use it to seed the random
% number generator
rng('shuffle');
randSeed = randi(30000);
DATA.rSeed = randSeed;
rng(randSeed);

datafilename = [datafilename, exptSession,'.mat'];


% Andy's additions
% spatial('random') = randSeed;
% spatial('datafilename') = datafilename;
% spatial('framerate') = round(Screen(MainWindow, 'FrameRate'));



% Get screen resolution, and find location of centre of screen
[scrWidth, scrHeight] = Screen('WindowSize',screenNum);
res = [scrWidth scrHeight];
scr_centre = res / 2;


MainWindow = Screen(screenNum, 'OpenWindow', [], [], 32);

DATA.frameRate = round(Screen(MainWindow, 'FrameRate'));

HideCursor;

Screen('Preference', 'DefaultFontName', 'Courier New');

Screen('TextSize', MainWindow, 34);

% now set colors
white = WhiteIndex(MainWindow);
black = BlackIndex(MainWindow);
gray = [70 70 70];
orange = [193 95 30];
green = [54 145 65];
blue = [37 141 165];
pink = [193 87 135];
yellow = [255 255 0];
Screen('FillRect',MainWindow, black);

distract_col = zeros(5,3);

distract_col(5,:) = yellow;       % Practice colour
if str2num(exptSession) == 1
    if colBalance == 1
        distract_col(1,:) = orange;      % High-value distractor colour
        distract_col(2,:) = blue;      % Low-value distractor colour
    elseif colBalance == 2
        distract_col(1,:) = blue;
        distract_col(2,:) = orange;
    elseif colBalance == 3
        distract_col(1,:) = green;
        distract_col(2,:) = pink;
    elseif colBalance == 4
        distract_col(1,:) = pink;
        distract_col(2,:) = green;
    end
elseif str2num(exptSession) == 2
    if colBalance == 1
        distract_col(1,:) = green;      % High-value distractor colour
        distract_col(2,:) = pink;      % Low-value distractor colour
    elseif colBalance == 2
        distract_col(1,:) = pink;
        distract_col(2,:) = green;
    elseif colBalance == 3
        distract_col(1,:) = orange;
        distract_col(2,:) = blue;
    elseif colBalance == 4
        distract_col(1,:) = blue;
        distract_col(2,:) = orange;
    end
end
        
distract_col(3,:) = gray;
distract_col(4,:) = gray;

for i = 1 : 2
    if distract_col(i,:) == orange
        colName = 'ORANGE    ';           % All entries need to have the same length. We'll strip the blanks off later.
    elseif distract_col(i,:) == green
        colName = 'GREEN     ';
    elseif distract_col(i,:) == blue
        colName = 'BLUE      ';
    elseif distract_col(i,:) == pink
        colName = 'PINK      ';
    elseif distract_col(i,:) == yellow
        colName = 'YELLOW    ';
    end
    
    if i == 1
        colourName = char(colName);
    else
        colourName = char(colourName, colName);
    end
end

commandwindow;

if test == 0  % experimental version

    initialInstructionsSpatial;

    [~] = runTrialsSpatial(0);     % Practice phase

    save(datafilename, 'DATA');

    if exptSession == 1
        DrawFormattedText(MainWindow, 'Please fetch the experimenter', 'center', 'center' , white);
        Screen(MainWindow, 'Flip');

        RestrictKeysForKbCheck(KbName('t'));   % Only accept T key to continue
        KbWait([], 2);
    end

    exptInstructionsSpatial;

    bonus_payment = runTrialsSpatial(1);

    awareInstructionsSpatial;
    awareTestSpatial;
    
elseif test == 1  % test version
    
    initialInstructionsSpatial;

    [~] = runTrialsSpatial(0);
    
end

%% THIS NEEDS TO CHANGE

% bonus

% maximum possible points:

% 24 trials per block * 12 blocks = 288 trials
% max points per trial = 
% trialPay = (1000 - roundRT) * 0.1 * winMultiplier(distractType);
% 4 raredistractors per block of 24


if test == 1  % test version
    bonus_payment = 75000;  % theoretical maximum session points
elseif test == 0  % experimental version
    % bonus_payment set above
else
    error('variable "test" isn''t set properly')
end

bonus_payment = bonus_payment / 100;  % convert to cents
bonus_payment = 10 * ceil(bonus_payment / 10);  % round up to nearest 10c
bonus_payment = bonus_payment / 100;  % convert to dollars


% Daniel's data
DATA.bonusSessionSpatial = bonus_payment;
DATA.bonusSoFar = bonus_payment + starting_total;

save(['spatial_data/CirclesMultiDataP', p_number, 'S', exptSession], 'DATA');


% Andy's data
experiment('spatial') = DATA;
update_details(experiment, bonus_payment);
clear DATA; % clear data for RSVP task


DrawFormattedText(MainWindow, ['Experiment complete - Please fetch the experimenter\n\n\nTotal bonus so far = $', num2str(bonus_payment + starting_total , '%0.2f')], 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('q'));   % Only accept Q key to quit
KbWait([], 2);


rmpath('spatialfunctions');
Snd('Close');

%Screen('Preference', 'SkipSyncTests',0);

Screen('CloseAll');
