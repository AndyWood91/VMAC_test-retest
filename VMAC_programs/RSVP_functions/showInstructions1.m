% rsvp

function showInstructions1

global MainWindow targetImages bColour white
global screenWidth


% set up instructions window
[instructions_window, ~] = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextFont', instructions_window, 'Segoe UI');
Screen('TextStyle', instructions_window, 0);
image_height = 480;
image_width = image_height * 0.75;

yellow = [255, 255, 0];

% instruction strings
instrString1 = 'In this task you will view streams of images. On each trial, you will see a series of pictures flashed very fast on the screen. Most of the pictures will be upright, but one of them will be rotated to the left or to the right.';
instrString2 = 'Your task is to use the left or right arrow key to identify the direction in which the rotated picture is rotated. In this example, it is in the LEFT direction.';
instrString3 = 'You will now have a chance to practise this task. The pictures will start off flashing quite slowly, and will gradually increase to the speed of the experiment.';


imageTop = 330;  % set top border of example image

centredImageRect = [screenWidth/2 - image_width/2, imageTop, screenWidth/2 + image_width/2, imageTop + image_height/2];  % rotated image


Screen('TextSize', instructions_window, 40);
DrawFormattedText(instructions_window, instrString1, 180, 80, white, 100, [], [], 1.3);
Screen('DrawTexture', instructions_window, targetImages(1), [], centredImageRect);
Screen('TextSize', instructions_window, 28);
DrawFormattedText(instructions_window, 'This picture is rotated to the left', 'center', centredImageRect(4) + 30, yellow, [], [], [], 1.3);
Screen('TextSize', instructions_window, 40);
DrawFormattedText(instructions_window, instrString2, 180, centredImageRect(4) + 180, white, 100, [], [], 1.3);

Screen('DrawTexture', MainWindow, instructions_window);

Screen('Flip', MainWindow);


RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('FillRect', instructions_window, bColour);
DrawFormattedText(instructions_window, instrString3, 180, 120, white, 100, [], [], 1.3);
Screen('DrawTexture', MainWindow, instructions_window);

Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Flip', MainWindow);

Screen('Close', instructions_window);

end