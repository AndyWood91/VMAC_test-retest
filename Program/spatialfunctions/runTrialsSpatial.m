
function totalPay = runTrials(exptPhase)

global MainWindow scr_centre DATA datafilename
global keyCounterbal starting_total exptSession
global distract_col
global white black gray yellow
global bigMultiplier smallMultiplier
global zeroPayRT oneMSvalue
global stim_size stim_pen nf



timeoutDuration = 2;     % 2 timeout duration
iti = 0.5;            % 0.5
correctFBDuration = [0.7, 2];       %[0.001, 0.001]    [0.7, 2]  Practice phase feedback duration  1.4 Main task feedback duration
errorFBDuration = [0.7, 2.5];       %[0.001, 0.001]      [0.7, 2.5]  Practice phase feedback duration  2 Main task feedback duration

fixation = [0.4  0.5  0.6];     %[0.001, 0.001, 0.001]    [0.4  0.5  0.6] Fixation durations (sampled randomly)

initialPause = 1.5;   % 3 ***
breakDuration = 15;  % 20 ***


exptTrialsPerBlock = 24;    % 24. This is used to ensure people encounter the right number of each of the different types of distractors.
NumRareDistract = 4;       % 2. So 2 trials per block with each of distractor types 3-4.

exptTrialsBeforeBreak = 4 * exptTrialsPerBlock;     % 4 * exptTrialsPerBlock = 96

pracTrials = 10;    % 10
exptTrials = 3 * exptTrialsBeforeBreak;    % 6 * exptTrialsBeforeBreak


stimLocs = 6;       % Number of stimulus locations
stim_size = 92;     % 92 Size of stimuli
stim_pen = 8;      % Pen width of stimuli
lineLength = 30;    % Line of target line segments
line_pen = 6;       % Pen width of line segments

circ_diam = 200;    % Diameter of imaginary circle on which stimuli are positioned
fix_size = 20;      % This is the side length of the fixation cross

bonusWindowWidth = 400;
bonusWindowHeight = 100;
bonusWindowTop = 230;

roundRT = 0;

winMultiplier = zeros(3);
winMultiplier(1) = bigMultiplier;         % Common distractor associated with big win
winMultiplier(2) = smallMultiplier;     % Common distractor associated with small win
winMultiplier(3) = smallMultiplier;         % All gray circles, small win


% This plots the points of a large diamond, that will be filled with colour
d_pts = [stim_size/2, 0;
    stim_size, stim_size/2;
    stim_size/2, stim_size;
    0, stim_size/2];

% This plots the points of a smaller diamond that will be drawn in black
% inside the previous one to make a frame (this is a pain, but you can't
% use FramePoly as it has limits on allowable pen widths). The first line is
% Pythagoras to make sure the pen width is correct.
d_inset = sqrt(2*(stim_pen^2));
small_d_pts = [stim_size/2, d_inset;
    stim_size - d_inset, stim_size/2;
    stim_size/2, stim_size - d_inset;
    d_inset, stim_size/2];

% Create an offscreen window, and draw the two diamonds onto it to create a diamond-shaped frame.
diamondTex = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 stim_size stim_size]);
Screen('FillPoly', diamondTex, gray, d_pts);
Screen('FillPoly', diamondTex, black, small_d_pts);

% Create an offscreen window, and draw the fixation cross in it.
fixationTex = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 fix_size fix_size]);
Screen('DrawLine', fixationTex, white, 0, fix_size/2, fix_size, fix_size/2, 2);
Screen('DrawLine', fixationTex, white, fix_size/2, 0, fix_size/2, fix_size, 2);


% Create a rect for the fixation cross
fixRect = [scr_centre(1) - fix_size/2    scr_centre(2) - fix_size/2   scr_centre(1) + fix_size/2   scr_centre(2) + fix_size/2];

% The oblique line segments need to have the same length as the vertical /
% horizontal target lines. Use Pythagoras to work out vertical and
% horizontal displacements of these lines (which are equal because lines
% are at 45 deg).

obliqueDisp = round(sqrt(lineLength * lineLength / 2));



% Create a matrix containing the six stimulus locations, equally spaced
% around an imaginary circle of diameter circ_diam
% Also create sets of points defining the positions of the oblique and
% target (horizontal / vertical) lines that appear inside each stimulus
stimRect = zeros(stimLocs,4);
lineRight = zeros(stimLocs,4);
lineLeft = zeros(stimLocs,4);
lineVert = zeros(stimLocs,4);
lineHorz = zeros(stimLocs,4);
lineOrientation = zeros(1,stimLocs);   % Used below; preallocating for speed

for i = 0 : stimLocs - 1    % Define rects for stimuli and line segments
    stimRect(i+1,:) = [scr_centre(1) - circ_diam * sin(i*2*pi/stimLocs) - stim_size / 2   scr_centre(2) - circ_diam * cos(i*2*pi/stimLocs) - stim_size / 2   scr_centre(1) - circ_diam * sin(i*2*pi/stimLocs) + stim_size / 2   scr_centre(2) - circ_diam * cos(i*2*pi/stimLocs) + stim_size / 2];
    
    lineVert(i+1,:) = [stimRect(i+1,1) + stim_size/2   stimRect(i+1,2) + (stim_size-lineLength)/2    stimRect(i+1,1) + stim_size/2    stimRect(i+1,2) + stim_size/2 + lineLength/2];
    lineHorz(i+1,:) = [stimRect(i+1,1) + (stim_size-lineLength)/2   stimRect(i+1,2) + stim_size/2    stimRect(i+1,1) + stim_size/2 + lineLength/2    stimRect(i+1,2) + stim_size/2];
    
    lineRight(i+1,:) = [stimRect(i+1,1) + (stim_size-obliqueDisp)/2   stimRect(i+1,2) + stim_size/2 + obliqueDisp/2   stimRect(i+1,1) + stim_size/2 + obliqueDisp/2   stimRect(i+1,2) + (stim_size-obliqueDisp)/2];
    lineLeft(i+1,:) = [stimRect(i+1,1) + (stim_size-obliqueDisp)/2   stimRect(i+1,2) + (stim_size-obliqueDisp)/2   stimRect(i+1,1) + stim_size/2 + obliqueDisp/2   stimRect(i+1,2) + stim_size/2 + obliqueDisp/2];
end


% Create a full-size offscreen window that will be used for drawing all
% stimuli and targets (and fixation cross) into
stimWindow = Screen('OpenOffscreenWindow', MainWindow, black);


% Create a small offscreen window and draw the bonus multiplier into it
bonusTex = Screen('OpenOffscreenWindow', MainWindow, yellow, [0 0 bonusWindowWidth bonusWindowHeight]);
%Screen('FrameRect', bonusTex, yellow, [], 8);
Screen('TextSize', bonusTex, 40);
Screen('TextFont', bonusTex, 'Calibri');
Screen('TextStyle', bonusTex, 0);
DrawFormattedText(bonusTex, [num2str(bigMultiplier), ' x  bonus trial!'], 'center', 'center', black);




if exptPhase == 0
    numTrials = pracTrials;
    DATA.practrialInfo = zeros(pracTrials, 9);
    
    distractArray = zeros(1, pracTrials);
    distractArray(1 : pracTrials) = 5;
    
else
    numTrials = exptTrials;
    DATA.expttrialInfo = zeros(exptTrials, 15);
    
    distractArray = zeros(1,exptTrialsPerBlock);
    distractArray(1 : NumRareDistract) = 3;
    distractArray(1 + NumRareDistract : NumRareDistract + (exptTrialsPerBlock - NumRareDistract) / 2) = 1;
    distractArray(1 + NumRareDistract + (exptTrialsPerBlock - NumRareDistract) / 2 : exptTrialsPerBlock) = 2;
    
end

totalPay = 0;

shuffled_distractArray = shuffleTrialorder(distractArray, exptPhase);   % Calls a function to shuffle trials

trialCounter = 0;
block = 1;
trials_since_break = 0;

% build skip here
RestrictKeysForKbCheck([KbName('c'), KbName('m')]);   % Only accept keypresses from keys C and M

WaitSecs(initialPause);

for trial = 1 : numTrials
    
    trialCounter = trialCounter + 1;    % This is used to set distractor type below; it can cycle independently of trial
    trials_since_break = trials_since_break + 1;
    
    targetLoc = randi(stimLocs);
    
    distractLoc = targetLoc;
    while distractLoc == targetLoc
        distractLoc = randi(stimLocs);
    end
    
    targetType = 1 + round(rand);   % Gives random number, either 1 or 2
    distractType = shuffled_distractArray(trialCounter);
    
    fix_pause = fixation(randi(3));
    
    Screen('FillRect', stimWindow, black);  % Clear the screen from the previous trial by drawing a black rectangle over the whole thing
    Screen('DrawTexture', stimWindow, fixationTex, [], fixRect);
    for i = 1 : stimLocs
        Screen('FrameOval', stimWindow, gray, stimRect(i,:), stim_pen, stim_pen);       % Draw stimulus circles
    end
    Screen('FrameOval', stimWindow, distract_col(distractType,:), stimRect(distractLoc,:), stim_pen, stim_pen);      % Draw distractor circle
    
    for i = 1 : stimLocs
        lineOrientation(i) = round(rand);
        if lineOrientation(i) == 0
            Screen('DrawLine', stimWindow, white, lineLeft(i,1), lineLeft(i,2), lineLeft(i,3), lineLeft(i,4), line_pen);
        else
            Screen('DrawLine', stimWindow, white, lineRight(i,1), lineRight(i,2), lineRight(i,3), lineRight(i,4), line_pen);
        end
    end
    
    Screen('DrawTexture', stimWindow, diamondTex, [], stimRect(targetLoc,:));
    
    if targetType == 1
        Screen('DrawLine', stimWindow, white, lineHorz(targetLoc,1), lineHorz(targetLoc,2), lineHorz(targetLoc,3), lineHorz(targetLoc,4), line_pen);
    else
        Screen('DrawLine', stimWindow, white, lineVert(targetLoc,1), lineVert(targetLoc,2), lineVert(targetLoc,3), lineVert(targetLoc,4), line_pen);
    end
    
    
    Screen('FillRect',MainWindow, black);
    Screen(MainWindow, 'Flip');     % Clear screen
    WaitSecs(iti);
    
    Screen('DrawTexture', MainWindow, fixationTex, [], fixRect);
    Screen(MainWindow, 'Flip');     % Present fixation cross
    WaitSecs(fix_pause);
    
    
    Screen('DrawTexture', MainWindow, stimWindow);
    st = Screen(MainWindow, 'Flip');      % Present stimuli, and record start time (st) when they are presented.
    
    et = KbWait([], 2, st + timeoutDuration);        % Accurate measure of the time at which a key is pressed, stored as end time (et). The 2 in arg list means it waits till all keys released, then logs first pressed. Final arg means it waits for a set period then times out.
    
    % But KbWait doesn't record which key is pressed, so...
    [~, ~, keyCode] = KbCheck;      % This stores which key is pressed (keyCode)
    keyCodePressed = find(keyCode, 1, 'first');     % If participant presses more than one key, KbCheck will create a keyCode array. Take the first element of this array as the response
    keyPressed = KbName(keyCodePressed);    % Get name of key that was pressed
    
    rt = 1000 * (et - st);      % Response time in ms
    
    correct = 0;
    timeout = 0;
    
    
    if isempty(keyPressed)      % No key pressed (i.e. timeout)
        timeout = 1;
        trialPay = 0;
        Beeper;
        fbStr = 'TOO SLOW\n\nPlease try to respond faster';
        
    else
        
        fbStr = 'ERROR';
        
        if keyPressed == 'c'
            if keyCounterbal == targetType     % If C = horizontal and line is horizontal, or if C = vertical and line is vertical
                correct = 1;
                fbStr = 'correct';
            end
            
        elseif keyPressed == 'm'
            if keyCounterbal ~= targetType     % If M = horizontal and line is horizontal, or if M = vertical and line is vertical
                correct = 1;
                fbStr = 'correct';
            end
            
        end
        
        if exptPhase == 1       % If this is NOT practice
            
            roundRT = round(rt);    % Round RT to nearest integer
            
            if roundRT >= zeroPayRT
                trialPay = 0;
            else
                trialPay = (zeroPayRT - roundRT) * oneMSvalue * winMultiplier(distractType);
                %trialPay = round(trialPay * 100) / 100;     % Round amount earned to nearest .01c
            end
            
            if winMultiplier(distractType) == bigMultiplier
                Screen('DrawTexture', MainWindow, bonusTex, [], [scr_centre(1)-bonusWindowWidth/2   bonusWindowTop   scr_centre(1)+bonusWindowWidth/2    bonusWindowTop+bonusWindowHeight]);
            end
            
%             rtStr = ['RT = ', num2str(roundRT), ' milliseconds'];
            
            if correct == 0
                totalPay = totalPay - trialPay;
                fbStr = ['Lose ', char(nf.format(trialPay)), ' points'];
                %Beeper;
                Screen('TextSize', MainWindow, 48);
                DrawFormattedText(MainWindow, 'ERROR', 'center', bonusWindowTop + bonusWindowHeight + 100 , white);
                trialPay = -trialPay;   % This is so it records correctly in the data file
                
            elseif correct == 1
                totalPay = totalPay + trialPay;
                fbStr = ['+', char(nf.format(trialPay)), ' points'];
            end
            
            Screen('TextSize', MainWindow, 32);
            DrawFormattedText(MainWindow, format_payStr(totalPay + starting_total), 'center', 740, white);
            
        end
    end
    
    
    Screen('TextSize', MainWindow, 48);
    DrawFormattedText(MainWindow, fbStr, 'center', 'center', yellow);
    
    
    Screen('Flip', MainWindow);
    if correct == 0
        WaitSecs(correctFBDuration(exptPhase + 1));
    else
        WaitSecs(errorFBDuration(exptPhase + 1));
    end
    
    Screen('Flip', MainWindow);
    WaitSecs(iti);
    
    
    if exptPhase == 0
        DATA.practrialInfoSpatial(trial,:) = [exptSession, trial, targetLoc, targetType, distractLoc, distractType, timeout, correct, rt];
    else
        DATA.expttrialInfoSpatial(trial,:) = [exptSession, block, trial, trialCounter, trials_since_break, targetLoc, targetType, distractLoc, distractType, timeout, correct, rt, roundRT, trialPay, totalPay];
        
        if mod(trial, exptTrialsPerBlock) == 0
            shuffled_distractArray = shuffleTrialorder(distractArray, exptPhase);     % Re-shuffle order of distractors
            trialCounter = 0;
            block = block + 1;
        end
        
        if (mod(trial, exptTrialsBeforeBreak) == 0 && trial ~= numTrials);
            save(datafilename, 'DATA');
            take_a_break(breakDuration, initialPause);
            trials_since_break = 0;
        end
        
    end
    
    save(datafilename, 'DATA');
end


Screen('Close', diamondTex);
Screen('Close', fixationTex);
Screen('Close', stimWindow);


end



function shuffArray = shuffleTrialorder(inArray,ePhase)

acceptShuffle = 0;

while acceptShuffle == 0
    shuffArray = inArray(randperm(length(inArray)));     % Shuffle order of distractors
    acceptShuffle = 1;   % Shuffle always OK in practice phase
    if ePhase == 1
        if shuffArray(1) > 2 || shuffArray(2) > 2
            acceptShuffle = 0;   % Reshuffle if either of the first two trials (which may well be discarded) are rare types
        end
    end
end

end



function aStr = format_payStr(ii)

global nf

if ii < 0
    aStr = [char(nf.format(ii)), ' total'];
else
    aStr = [char(nf.format(ii)), ' total'];
end

end




function take_a_break(breakDur, pauseDur)

global MainWindow white

DrawFormattedText(MainWindow, ['Time for a break\n\nSit back, relax for a moment! You will be able to carry on in ', num2str(breakDur),' seconds\n\n\nRemember that the faster you make correct responses, the more you will earn in this task!'], 'center', 'center', white, 50, [], [], 1.5);

Screen(MainWindow, 'Flip');
WaitSecs(breakDur);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

DrawFormattedText(MainWindow, 'Please place your index fingers on the C and M keys\n\nand press the spacebar when you are ready to continue', 'center', 'center' , white);
Screen(MainWindow, 'Flip');

KbWait([], 2);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck([KbName('c'), KbName('m')]);   % Only accept keypresses from keys C and M

WaitSecs(pauseDur);

end