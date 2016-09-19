addpath('spatialfunctions');  % search the spatialfunctions directory for scripts and functions


% global variables
global MainWindow scr_centre DATA
global keyCounterbal starting_total exptSession
global distract_col colourName
global white black gray yellow
global bigMultiplier smallMultiplier
global zeroPayRT oneMSvalue nf
global datafilename

global testing experiment  % Andy
global scrRes scrCentre  % Andy - debugging instructions


% participant information set from get_details
p_number = experiment('number');
exptSession = experiment('session');
colBalance = experiment('counterbalance');


% data storage
if exist('spatial_data', 'dir') ~= 7  % check for 'spatial_data' directory
    mkdir('spatial_data');  % make it if it doesn't exist
end
datafilename = ['spatial_data/CirclesMultiDataP', p_number, 'S'];  % doesn't include session number yet to make it easier to load previous data


% variable declarations
nf = java.text.DecimalFormat;  % this displays the thousands separator and decimals according the the computers' Locale settings 
screenNum = 0;  % use the primary screen
test = testing;


% set trial values
zeroPayRT = 1000;       % 1000
% fullPayRT = 500;        % 500
oneMSvalue = 0.1;
bigMultiplier = 10;    % Points multiplier for trials with high-value distractor
smallMultiplier = 1;   % Points multiplier for trials with low-value distractor
keyCounterbal = 1;


% starting total
if strcmp(experiment('session'), '1')  % first session
    starting_total = 0;
elseif strcmp(experiment('session'), '2')
    load([datafilename, '1.mat'])  % load first session's data
    starting_total = DATA.bonusSoFar;
    clear DATA;
else
    error('variable "experiment(''session'')" isn''t set properly')
end

datafilename = [datafilename, exptSession,'.mat'];  % include session now


% generate a random seed using the clock, then use it to seed the random number generator
rng('shuffle');
randSeed = randi(30000);
DATA.rSeed = randSeed;
rng(randSeed);


% Get screen resolution, and find location of centre of screen
[scrWidth, scrHeight] = Screen('WindowSize',screenNum);
scrRes = [scrWidth scrHeight];
scrCentre = scrRes / 2;



MainWindow = Screen(screenNum, 'OpenWindow', [], [], 32);

DATA.frameRate = round(Screen(MainWindow, 'FrameRate'));

HideCursor;

Screen('TextFont', MainWindow, 'Courier New');
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
Screen('FillRect',MainWindow, black);  % fill black screen

distract_col = zeros(5,3);

distract_col(5,:) = yellow;       % Practice colour
if str2double(exptSession) == 1
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
elseif str2double(exptSession) == 2
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

commandwindow;  % move cursor to command window

% task
if test == 0  % experimental version

%     initialInstructionsSpatial;
    showInstructions1;

    [~] = runTrialsSpatial(0);  % Practice phase

%     DrawFormattedText(MainWindow, 'Please fetch the experimenter', 'center', 'center' , white);
%     Screen(MainWindow, 'Flip');
%     RestrictKeysForKbCheck(KbName('t'));   % Only accept T key to continue
%     KbWait([], 2);

    exptInstructionsSpatial;

    bonus_payment = runTrialsSpatial(1);

    awareInstructionsSpatial;
    awareTestSpatial;
    
elseif test == 1  % test version
    
%     initialInstructionsSpatial;
    showInstructions1;

    [~] = runTrialsSpatial(0);
    
%     DrawFormattedText(MainWindow, 'Please fetch the experimenter', 'center', 'center' , white);
%     Screen(MainWindow, 'Flip');
%     RestrictKeysForKbCheck(KbName('t'));   % Only accept T key to continue
%     KbWait([], 2);
    
    exptInstructionsSpatial;
    
    bonus_payment = 62500;

    
%     bonus_payment = runTrialsSpatial(1);
% 
%     awareInstructionsSpatial;
%     awareTestSpatial;
    
end

total_points = bonus_payment;

% bonus
bonus_payment = bonus_payment / 100;  % convert to cents
bonus_payment = ceil(bonus_payment * 20) / 20;  % round up to nearest 5c
bonus_payment = bonus_payment / 100;  % convert to dollars

% set floor and ceiling
if bonus_payment > 6.25  % maximum
    bonus_payment = 6.25;
elseif bonus_payment < 3  % minimum
    bonus_payment = 3;
end


% Daniel's data
DATA.bonusSessionSpatial = bonus_payment;
DATA.bonusSoFar = bonus_payment + starting_total;
save(datafilename, 'DATA');

% Andy's data
experiment('spatial') = DATA;
update_details(experiment, bonus_payment);  % data is saved in this
clear DATA; % clear data for RSVP task


% final screen
% session check
if strcmp(exptSession, '1')  % first session
    DrawFormattedText(MainWindow, ['Experiment complete - Please fetch the experimenter\n\nPoints earned = ', separatethousands(total_points, ','), '\n\nBonus = $', num2str(bonus_payment), '\n\nPlease fetch the experimenter.'], 'center', 'center' , white);
elseif strcmp(exptSession, '2')  % second session, include task total
    DrawFormattedText(MainWindow, ['Experiment complete - Please fetch the experimenter\n\nPoints earned = ', separatethousands(total_points, ','), '\n\nBonus = $', num2str(bonus_payment), '\n\nTotal bonus for this task = $', num2str(bonus_payment + starting_total , '%0.2f'), '\n\nPlease fetch the experimenter.'], 'center', 'center' , white);
else
    error('variable "exptSession" isn''t set properly')
end
Screen(MainWindow, 'Flip');
RestrictKeysForKbCheck(KbName('q'));   % Only accept Q key to quit
KbWait([], 2);


% cleanup
rmpath('spatialfunctions');
Snd('Close');
Screen('CloseAll');
