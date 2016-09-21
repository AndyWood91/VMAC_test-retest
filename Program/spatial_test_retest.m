addpath('spatialfunctions');  % search the spatialfunctions directory for scripts and functions

% variable declarations
global MainWindow scr_centre DATA
global keyCounterbal starting_total exptSession
global distract_col colourName
global white black gray yellow
global bigMultiplier smallMultiplier
global zeroPayRT oneMSvalue nf
global datafilename
global testing experiment  % Andy


nf = java.text.DecimalFormat;  % this displays the thousands separator and decimals according the the computers' Locale settings 
screenNum = 0;  % use the primary screen


% set trial values
zeroPayRT = 1000;       % 1000
fullPayRT = 500;        % 500, I think this is unused
oneMSvalue = 0.1;
bigMultiplier = 10;    % Points multiplier for trials with high-value distractor
smallMultiplier = 1;   % Points multiplier for trials with low-value distractor

% starting_total = 0;
keyCounterbal = 1;

% set from get_details
p_number = experiment('number');
exptSession = experiment('session');

% data folder
datafoldername = 'spatial_data';
if exist(datafoldername, 'dir') ~= 7  % check for 'spatial_data' directory
    mkdir(datafoldername);  % make it if it doesn't exist
end

datafilename = [datafoldername '/CirclesMultiDataP', p_number, 'S'];  % no session number, easier to check for previous data
test = testing;  % set from main program
colBalance = experiment('counterbalance');

% starting totals
if strcmp(experiment('session'), '1')  % first session
    starting_total = 0;
    points_starting = 0;
elseif strcmp(experiment('session'), '2')  % second session
    load([datafilename, '1.mat'])  % load previous session's data
    starting_total = DATA.bonusSoFar;  % $$$
    points_starting = DATA.points_total;  % points
    clear DATA;
else
    error('variable "experiment(''session'')" isn''t set properly')
end


% generate a random seed using the clock, then use it to seed the random
% number generator
rng('shuffle');
randSeed = randi(30000);
DATA.rSeed = randSeed;
rng(randSeed);

datafilename = [datafilename, exptSession,'.mat'];  % include session now


% Get screen resolution, and find location of centre of screen
[scrWidth, scrHeight] = Screen('WindowSize',screenNum);
res = [scrWidth scrHeight];
scr_centre = res / 2;


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
    exptInstructionsSpatial;
    bonus_payment = runTrialsSpatial(1);
    awareInstructionsSpatial;
    awareTestSpatial;
    
elseif test == 1  % test version
    
    initialInstructionsSpatial;
    [~] = runTrialsSpatial(0);
    exptInstructionsSpatial;
%     bonus_payment = runTrialsSpatial(1);
    bonus_payment = 63000;
%     awareInstructionsSpatial;
%     awareTestSpatial;
    
end

% points
points_session = bonus_payment;
points_total = points_starting + points_session;

% bonus

% maximum possible points:


bonus_payment = bonus_payment / 100;  % convert to cents
bonus_payment = ceil(bonus_payment /20) * 20;  % round up to nearest 5c
bonus_payment = bonus_payment / 100;  % convert to dollars

% set floor and ceiling
if bonus_payment > 6.25
    bonus_payment = 6.25;
elseif bonus_payment < 3     % This is here in case there are any very unlucky dolts
    bonus_payment = 3;
end

bonusSoFar = starting_total + bonus_payment;

% Daniel's data
DATA.points_total = points_total;
DATA.bonusSessionSpatial = bonus_payment;
DATA.bonusSoFar = bonusSoFar;
save(datafilename, 'DATA');

% store bonus in .csv file
fid1 = fopen([datafoldername,'/_TotalBonus_summary.csv'], 'a');
fprintf(fid1,'%c,%d,%f\n', p_number, points_total, bonusSoFar);
fclose(fid1);

% Andy's data
experiment('spatial') = DATA;
update_details(experiment, bonus_payment);  % DATA is saved here
clear DATA; % clear data for RSVP task

% final screen
if strcmp(exptSession, '1')  % first session
    [~, ny, ~] = DrawFormattedText(MainWindow, ['TASK COMPLETE\n\nPoints earned = ', separatethousands(points_session, ','), '\n\nBonus = $', num2str(bonus_payment, '%0.2f'), '\n\nPlease fetch the experimenter.'], 'center', 'center' , white, [], [], [], 1.3);
elseif strcmp(exptSession, '2')  % second session, include total
    [~, ny, ~] = DrawFormattedText(MainWindow, ['TASK COMPLETE\n\nPoints earned = ', separatethousands(points_session, ','), '\n\nBonus = $', num2str(bonus_payment, '%0.2f'), '\n\nTotal bonus for this task = $', num2str(bonusSoFar, '%0.2f'), '\n\nPlease fetch the experimenter.'], 'center', 'center' , white, [], [], [], 1.3);
else
    error('variable "session" isn''t set properly')
end
% DrawFormattedText(MainWindow, ['Experiment complete - Please fetch the experimenter\n\n\nTotal bonus (on this task) so far = $', num2str(bonus_payment + starting_total , '%0.2f')], 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('q'));   % Only accept Q key to quit
KbWait([], 2);


rmpath('spatialfunctions');
Snd('Close');

%Screen('Preference', 'SkipSyncTests',0);

Screen('CloseAll');
