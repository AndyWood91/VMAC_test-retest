function exptInstructionsSpatial()

global MainWindow white
global oneMSvalue zeroPayRT
global bigMultiplier


global starting_total scrCentre testing % Andy

testing = 1;
if testing == 1
    
    % this would usually be set by the invoking script but they're declared
    % here so that I can debug it.

    % PTB Preferences
    Screen('Preference','TextRenderer', 1);  % use new text renderer
    Screen('Preference', 'VisualDebuglevel', 3); % hide PTB startup screen

    % set up main window
    screenNum = 0;
    MainWindow = Screen(screenNum, 'OpenWindow');
    Screen('TextFont', MainWindow, 'Courier New');
    Screen('TextSize', MainWindow, 34);

    % colours
    black = BlackIndex(MainWindow);
    white = WhiteIndex(MainWindow);

    % get screen dimensions
    [scrWidth, scrHeight] = Screen('WindowSize', screenNum);
    scrRes = [scrWidth, scrHeight];
    scrCentre = scrRes / 2;
    
    starting_total = 6.25;
    exptSession = '1';
    colBalance = 1;

end

commandwindow;

instructStr1 = 'The rest of this experiment is similar to the trials you have just completed. On each trial, you should respond to the line that is contained inside the DIAMOND shape.\n\nIf the line is HORIZONTAL, you should press the C key. If the line is VERTICAL, you should press the M key.';
if strcmp(exptSession, '1')  % first session
    instructStr2 = ['From now on, you will be able to earn money for correct responses, depending on how fast you respond.\n\nFor every 100ms that your response time (RT) is faster than ', num2str(zeroPayRT), 'ms, you will earn ', num2str(100*oneMSvalue), ' points. \n\nThese points will eventually be converted into a cash reward, so the faster you make correct responses, the more you will earn. \n\nHowever, if you make an error you will LOSE the corresponding amount.'];
elseif strcmp(exptSession, '2')  % second session
    instructStr2 = ['You will again be able to earn money for correct responses, depending on how fast you respond.\n\nFor every 100ms that your response time (RT) is faster than ', num2str(zeroPayRT), 'ms, you will earn ', num2str(100*oneMSvalue), ' points. \n\nHowever, if you make an error you will LOSE the corresponding amount. \n\nIn the first session, you earned $', num2str(starting_total), ' on this task.'];
else
    error('variable "session" isn''t set properly')
end
instructStr3 = ['IMPORTANT: Some of the trials will be BONUS trials! On these trials the amount that you win or lose will be multiplied by ', num2str(bigMultiplier),'.\n\n']; 
instructStr4 = 'After each response you will be told how many points you won or lost, and your total points earned so far in this experiment.';
instructStr5 = 'At the end of the session the number of points that you have earned will be used to calculate your total reward payment.\n\nMost participants are able to earn between $7 and $15 in this task across both sessions of the experiment.';

show_Instructions(1, instructStr1, .1);
show_Instructions(2, instructStr2, .1);
show_Instructions(3, instructStr3, .1);
show_Instructions(4, instructStr4, .1);
show_Instructions(5, instructStr5, .1);


DrawFormattedText(MainWindow, 'Please tell the experimenter when you are ready to begin', 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck([]); % Re-enable all keys

end


function show_Instructions(instrTrial, insStr, ~)

global MainWindow scrCentre black white yellow
global distract_col bigMultiplier
global colourName

global testing

% hide cursor and create black screen, wait for spacebar
HideCursor;
Screen('FillRect', MainWindow, black);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

% set up instructions window
instructions_window = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instructions_window, 34);
Screen('TextStyle', instructions_window, 1);
Screen('TextFont', instructions_window, 'Courier New');

textColour = white;
if instrTrial == 3
    textColour = yellow;
end

[~, ~, instrBox] = DrawFormattedText(instructions_window, insStr, 'left', 100 , textColour, 60, [], [], 1.5);
instrBox_width = instrBox(3) - instrBox(1);
instrBox_height = instrBox(4) - instrBox(2);
textTop = 150;
destInstrBox = [(scrCentre(1) - instrBox_width / 2), textTop, (scrCentre(1) + instrBox_width / 2), (textTop + instrBox_height)];

Screen('DrawTexture', MainWindow, instructions_window, instrBox, destInstrBox);

% % from Initial, testing
% [~, ~, instrBox] = DrawFormattedText(instructions_window, insStr, 10, 'center', textColour, 60, [], [], 1.5);
% instrBox_width = instrBox(3) - instrBox(1);
% instrBox_height = instrBox(4) - instrBox(2);
% textTop = 100;
% destInstrBox = [scrCentre(1) - instrBox_width / 2   textTop   scrCentre(1) + instrBox_width / 2   textTop +  instrBox_height];
% Screen('DrawTexture', MainWindow, instructions_window, instrBox, destInstrBox);

if instrTrial == 3
    textColour = white;
    extraStr = ['So you will earn much more for correct responses on \n"',num2str(bigMultiplier), ' x bonus" trials than on standard trials.'];
    [~, ny, ~] = DrawFormattedText(MainWindow, extraStr, scrCentre(1) - instrBox_width / 2, destInstrBox(4), textColour, 60, [], [], 1.5);
    
    circSize = 150;
    lineLength = 60;
    obliqueDisp = round(sqrt(lineLength * lineLength / 2));
    circleRect(1,:) = [scrCentre(1) - instrBox_width/2    scrCentre(2)    scrCentre(1) - instrBox_width/2 + circSize    scrCentre(2) + circSize];
    circleRect(2,:) = [scrCentre(1) + instrBox_width/2 - circSize scrCentre(2) scrCentre(1) + instrBox_width/2 scrCentre(2) + circSize];
    
    if testing == 1;
        sca;
    end
    
    % I think this throws an error because my Mac screen is smaller than
    % the lab computers
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
        Screen('DrawLine', MainWindow, [255 255 255], lineRect(i,1), lineRect(i,2), lineRect(i,3), lineRect(i,4), 8)
    end
        [~, ny, highBox] = DrawFormattedText(instructions_window, highString, 'left', ny+100, textColour, 35, [], [], 1.5);
    highBox_width = highBox(3) - highBox(1);
    highBox_height = highBox(4) - highBox(2);
    [~,~,lowBox] = DrawFormattedText(instructions_window, lowString, 'left', ny+100, textColour, 35, [], [], 1.5);
    lowBox_width = lowBox(3) - lowBox(1);
    lowBox_height = lowBox(4) - lowBox(2);
    highTextTop = circleRect(1,4) + 75;
    
    destHighBox = [highCentre - highBox_width / 2   highTextTop   highCentre + highBox_width / 2   highTextTop + highBox_height];
    destLowBox = [lowCentre - lowBox_width / 2   highTextTop   lowCentre + lowBox_width / 2   highTextTop + lowBox_height];
    
    Screen('DrawTexture', MainWindow, instructions_window, highBox, destHighBox);
    Screen('DrawTexture', MainWindow, instructions_window, lowBox, destLowBox);
end

Screen('Flip', MainWindow, []);
Screen('TextSize', MainWindow, 34);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Close', instructions_window);

end

function out = aOrAn(colour)
    if strcmp(colour,'ORANGE')
        out = 'an';
    else
        out = 'a';
    end
end
