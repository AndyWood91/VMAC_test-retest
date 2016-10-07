% spatial

function initialInstructions()

global MainWindow white
global scrWidth scrHeigh scrCentre  % Andy

instructStr1 = 'On each trial a cross will appear, to warn you that the trial is about to start. Then a set of shapes will appear; an example is shown below.';
instructStr2 = 'Each of these shapes contains a line. Your task is to respond to the line that is contained inside the DIAMOND shape.\n\nIf the line inside the diamond is HORIZONTAL, you should press the C key. If the line is VERTICAL, you should press the M key.';
instructStr3 = 'You should respond as fast as you can, but you should try to avoid making errors.';

show_Instructions(1, instructStr1);
show_Instructions(2, instructStr2);
show_Instructions(3, instructStr3);

Screen('TextSize', MainWindow, 32);
Screen('TextStyle', MainWindow, 1);
Screen('TextFont', MainWindow, 'Courier New');

DrawFormattedText(MainWindow, 'You will now do some practice trials.\n\nPlease tell the experimenter when you are ready to begin.', 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('t'));   % Only accept t key
KbWait([], 2);
Screen(MainWindow, 'Flip');
RestrictKeysForKbCheck([]); % Re-enable all keys

end

function show_Instructions(instrTrial, insStr)

global MainWindow scrCentre black white

x = 368;
y = 368;

exImageRect = [scrCentre(1) - x/2    scrCentre(2)    scrCentre(1) + x/2   scrCentre(2) + y];

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar


instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextFont', instrWin, 'Courier New');
Screen('TextSize', instrWin, 32);
Screen('TextStyle', instrWin, 1);

[~, ~, instrBox] = DrawFormattedText(instrWin, insStr, 10, 'center' , white, 60, [], [], 1.5);
instrBox_width = instrBox(3) - instrBox(1);
instrBox_height = instrBox(4) - instrBox(2);
textTop = 100;
destInstrBox = [scrCentre(1) - instrBox_width / 2   textTop   scrCentre(1) + instrBox_width / 2   textTop +  instrBox_height];
Screen('DrawTexture', MainWindow, instrWin, instrBox, destInstrBox);

ima=imread('spatialExample.jpg', 'jpg');
Screen('PutImage', MainWindow, ima, exImageRect); % put image on screen
Screen(MainWindow, 'Flip');

KbWait([], 2);  % turning this off will let the experiment run but skips the initial instructions

Screen('Close', instrWin);

end