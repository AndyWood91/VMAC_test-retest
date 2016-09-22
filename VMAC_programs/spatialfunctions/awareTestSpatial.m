function awareTest()

global MainWindow scrCentre DATA datafilename
global distract_col colourName
global white black gray yellow
global bigMultiplier
global stim_size stim_pen


awareTest_iti = 1;

testColours = 2;

valButtonWidth = 300;
valButtonHeight = 130;
valButtonTop = 470;
valButtonDisplacement = 230;


confButtons = 5;
confButtonWidth = 100;
confButtonHeight = 100;
confButtonTop = 820;
confButtonBetween = 150;

% The names of the colours in the colourName array are padded with blanks so that they're all the same length.
% The next two lines create a cell array of strings that automatically strips off these blanks, and then saves the length
% of each of the stripped strings in a new array. This can be used later to work out how many characters to print for each colour name.

celldata = cellstr(colourName);
colourNameLength = zeros(testColours,1);
for i = 1 : testColours
    colourNameLength(i) = length(celldata{i});
end

valButtonWin = zeros(2,1);
for i = 1 : 2
    valButtonWin(i) = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 valButtonWidth valButtonHeight]);
    Screen('FillRect', valButtonWin(i), gray);
    Screen('TextSize', valButtonWin(i), 30);
    Screen('TextFont', valButtonWin(i), 'Calibri');
end


DrawFormattedText(valButtonWin(1), 'No bonus', 'center', 'center', yellow);
DrawFormattedText(valButtonWin(2), [num2str(bigMultiplier), ' x bonus trial!'], 'center', 'center', yellow);

valButtonRect = zeros(2,4);
valButtonRect(1,:) = [scrCentre(1) - valButtonWidth/2 - valButtonDisplacement   valButtonTop   scrCentre(1) + valButtonWidth/2 - valButtonDisplacement  valButtonTop + valButtonHeight];
valButtonRect(2,:) = [scrCentre(1) - valButtonWidth/2 + valButtonDisplacement   valButtonTop   scrCentre(1) + valButtonWidth/2 + valButtonDisplacement  valButtonTop + valButtonHeight];


confButtonWin = zeros(confButtons,1);
confButtonRect = zeros(confButtons, 4);
for i = 1 : confButtons
    confButtonWin(i) = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 confButtonWidth confButtonHeight]);
    Screen('FillRect', confButtonWin(i), gray);
    Screen('TextFont', confButtonWin(i), 'Arial');
    Screen('TextSize', confButtonWin(i), 34);
    DrawFormattedText(confButtonWin(i), num2str(i), 'center', 'center', white);
    
    confButtonRect(i,:) = [scrCentre(1) + confButtonWidth * (i - 1 - confButtons/2) + confButtonBetween * (i-1 - (confButtons - 1)/2)    confButtonTop    scrCentre(1) + confButtonWidth * (i - 1 - confButtons/2) + confButtonBetween * (i-1 - (confButtons - 1)/2) + confButtonWidth    confButtonTop + confButtonHeight];
    
end


instructStr2 = 'Use the mouse to select the appropriate amount';
instructStr3 = 'How confident are you of this choice?';

instructStr4 = 'Not at all\nconfident';
instructStr5 = 'Very\nconfident';

instructStr4Win = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instructStr4Win, 24);
Screen('TextFont', instructStr4Win, 'Arial');
[~,~,instr4boundsRect] = DrawFormattedText(instructStr4Win, instructStr4, 'center', 'center', white, [], [], [], 1.5);
instr4width = instr4boundsRect(3) -  instr4boundsRect(1);
instr4height = instr4boundsRect(4) -  instr4boundsRect(2);

instructStr5Win = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instructStr5Win, 24);
Screen('TextFont', instructStr5Win, 'Arial');
[~,~,instr5boundsRect] = DrawFormattedText(instructStr5Win, instructStr5, 'center', 'center', white, [], [], [], 1.5);
instr5width = instr5boundsRect(3) -  instr5boundsRect(1);
instr5height = instr5boundsRect(4) -  instr5boundsRect(2);



DATA.awareTestInfo = zeros(testColours, 4);



% Create and shuffle the test trial types

trialOrder = 1:testColours;
trialOrder = trialOrder(randperm(length(trialOrder)));


ShowCursor('Arrow');


for trial = 1 : testColours
    
    instructStr1 = ['What type of trial was it when one of the circles was ', colourName(trialOrder(trial), 1:colourNameLength(trialOrder(trial))),'?'];
    
    DrawFormattedText(MainWindow, instructStr1, 'center', 75, white, 50, [], [], 1.5);
    oldTextSize = Screen('TextSize', MainWindow, 32);
    [~,~,instr2boundsRect] = DrawFormattedText(MainWindow, instructStr2, 'center', 390, white, 50, [], [], 1.5);
    Screen('TextSize', MainWindow, oldTextSize);
    
    circle_top = 200;	% Position of top of sample circle
    Screen('FrameOval', MainWindow, distract_col(trialOrder(trial),:), [scrCentre(1) - stim_size / 2    circle_top   scrCentre(1) + stim_size / 2    circle_top + stim_size], stim_pen, stim_pen);      % Draw circle
    
    for i = 1 : 2
        Screen('DrawTexture', MainWindow, valButtonWin(i), [], valButtonRect(i,:));
    end
    
    Screen('Flip', MainWindow, [], 1);
    
    
    for i = 1 : confButtons
        Screen('DrawTexture', MainWindow, confButtonWin(i), [], confButtonRect(i,:));
    end
    
    rate_instr_below = 30;
    Screen('DrawTexture', MainWindow, instructStr4Win, instr4boundsRect, [confButtonRect(1,1) + confButtonWidth/2 - instr4width/2     confButtonTop + confButtonHeight + rate_instr_below   confButtonRect(1,1) + confButtonWidth/2 + instr4width/2    confButtonTop + confButtonHeight + rate_instr_below + instr4height]);
    Screen('DrawTexture', MainWindow, instructStr5Win, instr5boundsRect, [confButtonRect(5,1) + confButtonWidth/2 - instr5width/2     confButtonTop + confButtonHeight + rate_instr_below   confButtonRect(5,1) + confButtonWidth/2 + instr5width/2    confButtonTop + confButtonHeight + rate_instr_below + instr5height]);
    
    
    Screen('FillRect', MainWindow, black, instr2boundsRect + [-10 -10 10 10]);    % Cover up instr2
    
    
    clickedValButton = 0;
    while clickedValButton == 0
        [~, x, y, ~] = GetClicks(MainWindow, 0);
        for i = 1 : 2
            if x > valButtonRect(i,1) && x < valButtonRect(i,3) && y > valButtonRect(i,2) && y < valButtonRect(i,4)
                clickedValButton = i;
            end
        end
    end
    
    if clickedValButton == 1
        Screen('FillRect', MainWindow, black, valButtonRect(2,:));	% Hide button that hasn't been clicked
    else
        Screen('FillRect', MainWindow, black, valButtonRect(1,:));
    end
    
    
    DrawFormattedText(MainWindow, instructStr3, 'center', confButtonTop - 100, white, 60, [], [], 1.5);
    
    
    Screen('Flip', MainWindow);
    
    clickedConfButton = 0;
    while clickedConfButton == 0
        [~, x, y, ~] = GetClicks(MainWindow, 0);
        for i = 1 : confButtons
            if x > confButtonRect(i,1) && x < confButtonRect(i,3) && y > confButtonRect(i,2) && y < confButtonRect(i,4)
                clickedConfButton = i;
            end
        end
    end
    
    
    DATA.awareTestInfo(trial,:) = [trial, trialOrder(trial), clickedValButton, clickedConfButton];
    
    Screen('Flip', MainWindow);
    
    WaitSecs(awareTest_iti);
end

save(datafilename, 'DATA');

for i = 1:2
    Screen('Close', valButtonWin(i));
end
for i = 1:confButtons
    Screen('Close', confButtonWin(i));
end

Screen('Close', instructStr4Win);
Screen('Close', instructStr5Win);

end