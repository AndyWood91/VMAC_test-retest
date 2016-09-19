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

% example image
example_image = imread('spatialfunctions/spatialExample.jpg');  % 368 x 368
example_dimensions = [368, 368];
example_rectangle = [(screen_centre(1) - example_dimensions(1) / 2), screen_centre(2), (screen_centre(1) + example_dimensions(1) / 2), (screen_centre(2) + example_dimensions(2))];




HideCursor;

Screen('FillRect',main_window, black);  % fill black screen

Screen('PutImage', main_window, example_image, example_rectangle);
Screen('Flip', main_window);
wait(2000);

ShowCursor;
wait(2000);

sca;



commandwindow;

