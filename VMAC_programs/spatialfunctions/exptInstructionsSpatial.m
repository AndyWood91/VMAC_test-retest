function exptInstructions

global MainWindow white
global oneMSvalue zeroPayRT
global bigMultiplier smallMultiplier
global centOrCents
global instrCondition
global softTimeoutDurationLate

global experiment starting_total  % Andy
global scrWidth scrHeight scrCentre  % Andy


instructStr1 = 'The rest of this experiment is similar to the trials you have just completed. On each trial, you should respond to the line that is contained inside the DIAMOND shape.\n\nIf the line is HORIZONTAL, you should press the C key. If the line is VERTICAL, you should press the M key.';

% Andy
% session check
if strcmp(experiment('session'), '1')
    instructStr2 = ['From now on, you will be able to earn money for correct responses, depending on how fast you respond. \n\nFor every 100ms that your response time (RT) is faster than ', num2str(zeroPayRT), 'ms, you will earn ', num2str(100*oneMSvalue), ' points. \n\nThese points will eventually be converted into a cash reward, so the faster you make correct responses, the more you will earn. \n\nHowever, if you make an error you will LOSE the corresponding amount.'];
elseif strcmp(experiment('session'), '2')
    instructStr2 = ['You will again be able to earn money for correct responses, depending on how fast you respond. \n\nFor every 100ms that your response time (RT) is faster than ', num2str(zeroPayRT), 'ms, you will earn ', num2str(100*oneMSvalue), ' points. \n\nHowever, if you make an error you will LOSE the corresponding amount.'];
else
    error('variable "session" isn''t set properly')
end

instructStr3 = ['IMPORTANT: Some of the trials will be BONUS trials! On these trials the amount that you win or lose will be multiplied by ', num2str(bigMultiplier),'.\n\n']; 
    
instructStr4 = 'After each response you will be told how many points you won or lost, and your total points earned so far in this experiment.';
if strcmp(experiment('session'), '1')  % first session
    instructStr5 = 'At the end of the session the number of points that you have earned will be used to calculate your total reward payment.\n\nMost participants are able to earn between $6 and $13 across both sessions on this task.';
elseif strcmp(experiment('session'), '2')  % second session
    instructStr5 = ['At the end of the session the number of points that you have earned will be used to calculate your total reward payment.\n\nIn the first session, you earned $', num2str(starting_total), ' on this task.\n\nMost participants are able to earn between $6 and $13 across both sessions on this task.'];
else
    error('variable "session" isn''t set properly')
end

show_Instructions(1, instructStr1, .1);
show_Instructions(2, instructStr2, .1);
show_Instructions(3, instructStr3, .1);
show_Instructions(4, instructStr4, .1);
show_Instructions(5, instructStr5, .1);


DrawFormattedText(MainWindow, 'Please tell the experimenter when you are ready to begin.', 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('t'));   % Only accept t key
KbWait([], 2);
Screen(MainWindow, 'Flip');
RestrictKeysForKbCheck([]); % Re-enable all keys

end


function show_Instructions(instrTrial, insStr, instrPause)

global MainWindow scrCentre black white yellow
global exptSession distract_col bigMultiplier
global starting_total colourName

x = 649;
y = 547;

exImageRect = [scrCentre(1) - x/2    scrCentre(2)-50    scrCentre(1) + x/2   scrCentre(2) + y - 50];


instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instrWin, 34);
Screen('TextStyle', instrWin, 1);
Screen('TextFont', instrWin, 'Courier New');

textColour = white;
if instrTrial == 3
    textColour = yellow;
end

[~, ny, instrBox] = DrawFormattedText(instrWin, insStr, 'left', 100 , textColour, 60, [], [], 1.5);
instrBox_width = instrBox(3) - instrBox(1);
instrBox_height = instrBox(4) - instrBox(2);
textTop = 150;
destInstrBox = [scrCentre(1) - instrBox_width / 2   textTop   scrCentre(1) + instrBox_width / 2   textTop + instrBox_height];

Screen('DrawTexture', MainWindow, instrWin, instrBox, destInstrBox);

if instrTrial == 3
    textColour = white;
     extraStr = ['So you will earn much more for correct responses on \n"',num2str(bigMultiplier), ' x bonus" trials than on standard trials.'];
    [~, ny, ~] = DrawFormattedText(MainWindow, extraStr, scrCentre(1) - instrBox_width / 2, destInstrBox(4), textColour, 60, [], [], 1.5);
    
    
    
    circSize = 150;
    lineLength = 60;
    obliqueDisp = round(sqrt(lineLength * lineLength / 2));
    circleRect(1,:) = [scrCentre(1) - instrBox_width/2    scrCentre(2)    scrCentre(1) - instrBox_width/2 + circSize    scrCentre(2) + circSize];
    circleRect(2,:) = [scrCentre(1) + instrBox_width/2 - circSize scrCentre(2) scrCentre(1) + instrBox_width/2 scrCentre(2) + circSize];
    for i = 1:2
        lineRect(i,:) = [circleRect(i,1) + (circSize-obliqueDisp)/2 circleRect(i,2) + circSize/2 + obliqueDisp/2 circleRect(i,1) + circSize/2 + obliqueDisp/2 circleRect(i,2) + (circSize-obliqueDisp)/2];
    end
    highCentre = (circleRect(1,1)+circleRect(1,3))/2;
    lowCentre = (circleRect(2,1)+circleRect(2,3))/2;  
    
    highString = ['If ' aOrAn(colourName(1,:)) ' ' strtrim(colourName(1,:)) ' circle is in the display, the trial WILL be a ' num2str(bigMultiplier) 'x BONUS TRIAL.'];
    lowString = ['If ' aOrAn(colourName(2,:)) ' ' strtrim(colourName(2,:)) ' circle is in the display, the trial WILL NOT be a ' num2str(bigMultiplier) 'x BONUS TRIAL.'];
    
    Screen('FrameOval', MainWindow, distract_col(1,1:3), circleRect(1,:), 10, 10);
    Screen('FrameOval', MainWindow, distract_col(2,1:3), circleRect(2,:), 10, 10);
    for i = 1:2
%         throws Screen error on Mac
%         Screen('DrawLine', MainWindow, [255 255 255], lineRect(i,1), lineRect(i,2), lineRect(i,3), lineRect(i,4), 8)
    end
        [~, ny, highBox] = DrawFormattedText(instrWin, highString, 'left', ny+100, textColour, 35, [], [], 1.5);
    highBox_width = highBox(3) - highBox(1);
    highBox_height = highBox(4) - highBox(2);
    [~,~,lowBox] = DrawFormattedText(instrWin, lowString, 'left', ny+100, textColour, 35, [], [], 1.5);
    lowBox_width = lowBox(3) - lowBox(1);
    lowBox_height = lowBox(4) - lowBox(2);
    highTextTop = circleRect(1,4) + 75;
    
    destHighBox = [highCentre - highBox_width / 2   highTextTop   highCentre + highBox_width / 2   highTextTop + highBox_height];
    destLowBox = [lowCentre - lowBox_width / 2   highTextTop   lowCentre + lowBox_width / 2   highTextTop + lowBox_height];
    
    Screen('DrawTexture', MainWindow, instrWin, highBox, destHighBox);
    Screen('DrawTexture', MainWindow, instrWin, lowBox, destLowBox);
end
    
    % if instrTrial == 6 && exptSession > 1
%      totalStr = ['In the previous session, you earned $', num2str(starting_total, '%0.2f'), '.\n\nThis will be added to whatever you earn in this session.'];
%      DrawFormattedText(MainWindow, totalStr, scrCentre(1) - instrBox_width / 2, textTop + instrBox_height + 100, yellow, [], [], [], 1.5);
% end

Screen('Flip', MainWindow, []);

% WaitSecs(instrPause);
% 
% Screen('TextSize', MainWindow, 26);
% DrawFormattedText(MainWindow, 'PRESS SPACEBAR WHEN YOU HAVE READ\nAND UNDERSTOOD THESE INSTRUCTIONS', 'center', (scrCentre(2) * 2 - 200), cyan, [], [], [], 1.5);
% Screen('Flip', MainWindow);

Screen('TextSize', MainWindow, 34);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Close', instrWin);

end

function out = aOrAn(colour)
    if strcmp(colour,'ORANGE')
        out = 'an';
    else
        out = 'a';
    end
end
