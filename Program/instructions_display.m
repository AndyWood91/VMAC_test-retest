function show_Instructions(instrTrial, insStr)

global MainWindow scr_centre black white

% global ScreenWidth  % Andy

x = 368;
y = 368;

exImageRect = [scr_centre(1) - x/2    scr_centre(2)    scr_centre(1) + x/2   scr_centre(2) + y];

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

Screen('FillRect',MainWindow, black);  % fill black screen
instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextFont', instrWin, 'Courier New');
Screen('TextSize', instrWin, 32);
Screen('TextStyle', instrWin, 1);

[~, ~, instrBox] = DrawFormattedText(instrWin, insStr, 10, 'center' , white, 60, [], [], 1.5);
instrBox_width = instrBox(3) - instrBox(1);
instrBox_height = instrBox(4) - instrBox(2);
textTop = 100;
destInstrBox = [scr_centre(1) - instrBox_width / 2   textTop   scr_centre(1) + instrBox_width / 2   textTop +  instrBox_height];
Screen('DrawTexture', MainWindow, instrWin, instrBox, destInstrBox);

ima=imread('spatialExample.jpg', 'jpg');
Screen('PutImage', MainWindow, ima, exImageRect); % put image on screen
Screen(MainWindow, 'Flip');

KbWait([], 2);  % turning this off will let the experiment run but skips the initial instructions

Screen('Close', instrWin);

end