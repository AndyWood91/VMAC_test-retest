
function awareInstructions()

global bigMultiplier

instructStr1 = ['During this experiment, whether each trial was a \n"', num2str(bigMultiplier),' x bonus" trial or not was determined by the colour of the coloured circle that appeared on that trial. When certain colours appeared in the display, it would be a \n"', num2str(bigMultiplier), ' x bonus" trial, and when other colours appeared it would not be.'];
instructStr1 = [instructStr1, '\n\nIn the final phase we will test what you have remembered about the different colours of circles.'];


show_Instructions(1, instructStr1, 12);      % 12

end


function show_Instructions(~, insStr, instrPause)

global MainWindow scrCentre black white gray

instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextFont', instrWin, 'Courier New');
Screen('TextSize', instrWin, 32);
Screen('TextStyle', instrWin, 1);

[~, ~, instrBox] = DrawFormattedText(instrWin, insStr, 'left' , 'center' , white, 60, [], [], 1.5);
instrBox_width = instrBox(3) - instrBox(1);
instrBox_height = instrBox(4) - instrBox(2);
textTop = 150;
destInstrBox = [scrCentre(1) - instrBox_width / 2   textTop   scrCentre(1) + instrBox_width / 2   textTop + instrBox_height];
Screen('DrawTexture', MainWindow, instrWin, instrBox, destInstrBox);

Screen('Flip', MainWindow, [], 1);

contButtonWidth = 1000;
contButtonHeight = 100;
contButtonTop = 800;

contButtonWin = Screen('OpenOffscreenWindow', MainWindow, gray, [0 0 contButtonWidth contButtonHeight]);
Screen('TextSize', contButtonWin, 28);
Screen('TextFont', contButtonWin, 'Arial');
DrawFormattedText(contButtonWin, 'Click here using the mouse to continue', 'center', 'center', white);

contButtonRect = [scrCentre(1) - contButtonWidth/2   contButtonTop  scrCentre(1) + contButtonWidth/2  contButtonTop + contButtonHeight];
Screen('DrawTexture', MainWindow, contButtonWin, [], contButtonRect);


WaitSecs(instrPause);

Screen('Flip', MainWindow);
ShowCursor('Arrow');


clickedContButton = 0;
while clickedContButton == 0
    [~, x, y, ~] = GetClicks(MainWindow, 0);

    if x > contButtonRect(1) && x < contButtonRect(3) && y > contButtonRect(2) && y < contButtonRect(4)
        clickedContButton = 1;
    end

end


Screen('Close', instrWin);
Screen('Close', contButtonWin);

end