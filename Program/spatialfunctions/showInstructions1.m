% spatial version
% runs on its own, but not when called from spatial_test_retest;

function showInstructions1

global MainWindow bColour white black
global scrCentre testing

testing = 1;
if testing == 1
    % set up main window
    screen_number = 0;
    main_window = Screen(screen_number, 'OpenWindow');
    Screen('TextFont', main_window, 'Courier New');
    Screen('TextSize', main_window, 34);

    % colours
    black = BlackIndex(main_window);
    white = WhiteIndex(main_window);

    % get screen dimensions
    [screen_width, screen_height] = Screen('WindowSize', screen_number);
    screen_resolution = [screen_width, screen_height];
    screen_centre = screen_resolution / 2;
else
    % get from invoking program
end


% set up instructions window
[instructions_window, ~] = Screen('OpenOffscreenWindow', MainWindow, bColour);
Screen('TextFont', instructions_window, 'Segoe UI');
Screen('TextSize', instructions_window, 40);
Screen('TextStyle', instructions_window, 0);


% read in example display - this image will be drawn to the bottom half of 
% the screen:
    % left border - vertical middle minus half of the example width
    % top border - horizontal middle
    % right border - vertical middle plus half of the example width
    % bottom border - horizontal middle plus the image height


example_image = imread('spatialfunctions/spatialExample.jpg');
example_dimensions = [368, 368];
example_rectangle = [(scrCentre(1) - example_dimensions(1) / 2), scrCentre(2), ...
    (scrCentre(1) + example_dimensions(1) / 2), (scrCentre(2) + example_dimensions(2))];
example_texture = Screen('MakeTexture', MainWindow, example_image);


% instruction strings
instrString1 = 'On each trial a cross will appear, to warn you that the trial is about to start. Then a set of shapes will appear; an example is shown below.';
instrString2 = 'Each of these shapes contains a line. Your task is to respond to the line that is contained inside the DIAMOND shape.\n\nIf the line inside the diamond is HORIZONTAL, you should press the C key. If the line is VERTICAL, you should press the M key.';
instrString3 = 'You should respond as fast as you can, but you should try to avoid making errors.';
instrString4 = 'You will now do some practice trials.\n\nPlease tell the experimenter when you are ready to begin.';

HideCursor;

% display instructions
% str1
DrawFormattedText(instructions_window, instrString1, 100, 80, white, 100, [], [], 1.3);  % instructions string
Screen('DrawTexture', instructions_window, example_texture, [], example_rectangle);  % example display
Screen('DrawTexture', MainWindow, instructions_window);  % put instructions on MainWindow
Screen('Flip', MainWindow);  % show MainWindow

RestrictKeysForKbCheck(KbName('Space'));   % wait for spacebar
KbWait([], 2);

% str2
Screen('FillRect', instructions_window, bColour);  % black fill
DrawFormattedText(instructions_window, instrString2, 100, 80, white, 100, [], [], 1.3);
Screen('DrawTexture', instructions_window, example_texture, [], example_rectangle);  % example display
Screen('DrawTexture', MainWindow, instructions_window);
Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

% str3
Screen('FillRect', instructions_window, bColour);  % black fill
DrawFormattedText(instructions_window, instrString3, 100, 80, white, 100, [], [], 1.3);
Screen('DrawTexture', instructions_window, example_texture, [], example_rectangle);  % example display
Screen('DrawTexture', MainWindow, instructions_window);
Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

% str4
Screen('TextSize', MainWindow, 32);
Screen('TextStyle', MainWindow, 1);
Screen('TextFont', MainWindow, 'Courier New');

Screen('FillRect', instructions_window, bColour);  % black fill
DrawFormattedText(instructions_window, instrString4, 'center', 'center', white);
Screen('DrawTexture', MainWindow, instructions_window);
% DrawFormattedText(MainWindow, instrString4, 'center', 'center' , white);
Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('t'));   % Only accept c key
KbWait([], 2);
Screen(MainWindow, 'Flip');
RestrictKeysForKbCheck([]); % Re-enable all keys


Screen('Flip', MainWindow);
Screen('Close', instructions_window);
Screen('Close', MainWindow);

end