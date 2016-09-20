% spatial, doesn't run as full screen (or at all currently)

function initialInstructionsSpatial()

global MainWindow white black
global scrRes scrCentre

% global testing  % Andy

testing = 1;
debugging = 1;

if testing == 1

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

end
    

instructStr1 = 'On each trial a cross will appear, to warn you that the trial is about to start. Then a set of shapes will appear; an example is shown below.';
instructStr2 = 'Each of these shapes contains a line. Your task is to respond to the line that is contained inside the DIAMOND shape.\n\nIf the line inside the diamond is HORIZONTAL, you should press the C key. If the line is VERTICAL, you should press the M key.';
instructStr3 = 'You should respond as fast as you can, but you should try to avoid making errors.';
instructStr4 = 'You will now do some practice trials.\n\nPlease tell the experimenter when you are ready to begin.';

% read in example display - this image will be drawn to the bottom half of 
% the screen:
    % left border - vertical middle minus half of the example width
    % top border - horizontal middle
    % right border - vertical middle plus half of the example width
    % bottom border - horizontal middle plus the image height
example_image = imread('spatialfunctions/spatialExample.jpg');  % 368 x 368
example_dimensions = [368, 368];
example_rectangle = [(scrCentre(1) - example_dimensions(1) / 2), scrCentre(2), ...
    (scrCentre(1) + example_dimensions(1) / 2), (scrCentre(2) + example_dimensions(2))];

HideCursor;
commandwindow;
Screen('FillRect', MainWindow, black);

% display instructions
show_Instructions(1, instructStr1);
show_Instructions(2, instructStr2);
show_Instructions(3, instructStr3);
show_Instructions(4, instructStr4);


RestrictKeysForKbCheck(KbName('t'));   % Only accept 't' key
KbWait([], 2);
Screen(MainWindow, 'Flip');
RestrictKeysForKbCheck([]); % Re-enable all keys

if debugging == 1;
    ShowCursor;
    sca;
end

end

function show_Instructions(instrTrial, insStr)

global MainWindow white black
global scrRes scrCentre


example_dimensions = [368, 368];
exImageRect = [scrCentre(1) - example_dimensions(1)/2    scrCentre(2)    scrCentre(1) + example_dimensions(1)/2   scrCentre(2) + example_dimensions(2)];

% hide cursor and create black screen, wait for spacebar
HideCursor;
Screen('FillRect', MainWindow, black);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

% set up instructions window
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

KbWait([], 2);

Screen('Close', instrWin);

end