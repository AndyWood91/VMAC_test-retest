function showInstructions2

global MainWindow
global bColour white screenWidth
global cueBalance

% Andy
global experiment startingTotal

instrWindow = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextFont', instrWindow, 'Segoe UI');
Screen('TextStyle', instrWindow, 0);

yellow = [255, 255, 0];

session = experiment('session');

% set cues
if strcmp(session, '1')
    
    if cueBalance == 1 || cueBalance == 3
        rewardString = 'BIRD';
    elseif cueBalance == 2 || cueBalance ==4
        rewardString = 'BICYCLE';
    else
        error('cueBalance isn''t set properly');
    end
    
elseif strcmp(session, '2')
    
    if cueBalance == 1 || cueBalance == 2
        rewardString = 'CHAIR';
    elseif cueBalance == 3 || cueBalance ==4
        rewardString = 'CAR';
    else
        error('cueBalance isn''t set properly');
    end
    
else
    error('variable "session" isn''t set properly')
    
end

% session check
if strcmp(session, '1')
    instrString = 'Great job!\n\nFrom now on you can win points for correct responses.\n\nThis is important because you will receive money at the end of the experiment, based on how many points you have earned.';
elseif strcmp(session, '2')
    instrString = ['Great job!\n\nYou will again be able to win points for correct responses.\n\nIn the first session, you earned $', num2str(startingTotal), ' on this task.'];
else
    error('variable "session" isn''t set properly')
end

instrString3 = ['If the stream of images includes a picture of a ', rewardString,', you will be able to WIN 50 POINTS on that trial if you respond correctly to the target. However, if you make an incorrect response, you will LOSE 50 POINTS.\n\nHowever, note that the ', rewardString,' will never be the target stimulus, so you will do better at the task if you try to ignore it.\n\nOn all other trials (when the stream doesn''t contain a picture of a ', rewardString,'), you will not receive any points for making a correct response, or lose any points for making an incorrect response.'];
instrString4 = 'Remember, at the end of the experiment, the number of points that you have earned will be used to calculate how much you get paid. So you should try to respond as accurately as you can, in order to earn as many points as possible.\n\n\nMost participants are able to earn between $6 and $13 across both sessions on this task.\n\nPlease let the experimenter know when you are ready to begin the task.';


Screen('TextSize', instrWindow, 40);

DrawFormattedText(instrWindow, instrString, 150, 150, white, 90, [], [], 1.3);
Screen('DrawTexture', MainWindow, instrWindow);

Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('FillRect', instrWindow, bColour);
DrawFormattedText(instrWindow, instrString3, 150, 150, white, 90, [], [], 1.3);
Screen('DrawTexture', MainWindow, instrWindow);
Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('FillRect', instrWindow, bColour);
DrawFormattedText(instrWindow, instrString4, 150, 150, yellow, 90, [], [], 1.3);
Screen('DrawTexture', MainWindow, instrWindow);
Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Flip', MainWindow);

Screen('Close', instrWindow);


end