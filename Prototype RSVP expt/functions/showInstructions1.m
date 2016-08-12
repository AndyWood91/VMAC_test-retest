function showInstructions1

global MainWindow targetImages bColour white
global screenWidth

instrWindow = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextFont', instrWindow, 'Segoe UI');
Screen('TextStyle', instrWindow, 0);

yellow = [255, 255, 0];


instrString = 'In this experiment you will view streams of images. On each trial, you will see a series of pictures flashed very fast on the screen. Most of the pictures will be upright, but one of them will be rotated to the left or to the right.';
instrString2 = 'Your task is to use the left or right arrow key to identify the direction in which the rotated picture is rotated. In this example, it is in the LEFT direction.';
instrString3 = 'You will now have a chance to practise this task. The pictures will start off flashing quite slowly, and will gradually speed up to the speed of the experiment.';
[imageWidth, imageHeight] = Screen('WindowSize', targetImages(1));

imageTop = 330;
centredImageRect = [screenWidth/2 - imageWidth/2, imageTop, screenWidth/2 + imageWidth/2, imageTop + imageHeight];

Screen('TextSize', instrWindow, 40);
DrawFormattedText(instrWindow, instrString, 180, 80, white, 100, [], [], 1.3);
Screen('DrawTexture', instrWindow, targetImages(1), [], centredImageRect);
Screen('TextSize', instrWindow, 28);
DrawFormattedText(instrWindow, 'This picture is rotated to the left', 'center', centredImageRect(4) + 30, yellow, [], [], [], 1.3);
Screen('TextSize', instrWindow, 40);
DrawFormattedText(instrWindow, instrString2, 180, centredImageRect(4) + 180, white, 100, [], [], 1.3);

Screen('DrawTexture', MainWindow, instrWindow);

Screen('Flip', MainWindow);


RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('FillRect', instrWindow, bColour);
DrawFormattedText(instrWindow, instrString3, 180, 120, white, 100, [], [], 1.3);
Screen('DrawTexture', MainWindow, instrWindow);

Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Flip', MainWindow);

Screen('Close', instrWindow);

end