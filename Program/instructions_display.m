%% instructions_display  %%

Screen('CloseAll');
KbName('UnifyKeyNames');  % standardises key mappings across OSs

% colours
black = [0, 0, 0];
white = [255, 255, 255];
yellow = [255, 255, 0];

% random number generator
rng('shuffle');  % seed rng based on the clock
random_seed = randi(30000);  % return a pseudorandom number between 1 and 30,000
rng(random_seed);  % then seed rng based on this number


%% PTB PREFERENCES %%

% debug screen
Screen('Preference', 'VisualDebuglevel', 3);  % hide PTB debug screen

% text renderer
Screen('Preference','TextRenderer', 0);  % use legacy text renderer (OS-specific)
Screen('Preference','TextRenderer', 1);  % use HighQ text renderer (OS-specific)


%% main_window %%
% this is the actual display on screen
screen_number = 0;  % display on primary monitor
[main_window, ~] = Screen('OpenWindow', screen_number, black);  % default full screen
frame_rate = round(Screen('FrameRate', main_window));

% dimensions
[screen_width, screen_height] = Screen('WindowSize', main_window);
% screen_resolution = [screen_width, screen_height];
screen_centre = [screen_width, screen_height] / 2;

% rectangles: left, top, right, bottom borders
top_rectangle = [0, 0, screen_width, screen_height / 2];
bottom_rectangle = [0, screen_height / 2, screen_width, screen_height];

% text
Screen('TextFont' , main_window ,'Segoe UI' );
Screen('TextSize', main_window, 46);
Screen('TextStyle', main_window, 0);


%% instruction_window %%
% this is used to set up instruction screens before they're displayed
[instruction_window, ~] = Screen('OpenOffscreenWindow', main_window, black);

% text
Screen('TextFont' , instruction_window ,'Segoe UI' );
Screen('TextSize', instruction_window, 40);
Screen('TextStyle', instruction_window, 0);


%% sequence %%
% turn this into a loop or function - show_instructions below
HideCursor;
Screen('FillRect', instruction_window, yellow, top_rectangle);  % fill top half with yellow rectangle
Screen('DrawTexture', main_window, instruction_window);  % draw instruction_window to main_window
Screen('Flip', main_window)  % update main_window


RestrictKeysForKbCheck(KbName('space'));
ShowCursor;
sca;

