clear;
sca;
clc;
KbName('UnifyKeyNames');  % standardise across OSs



% variable declarations
global testing experiment


% testing = 0;  % experimental version
testing = 1;  % testing version

Screen('Preference', 'VisualDebuglevel', 3); %DANIEL - this should hide the PTB startup screen so it looks a little bit smoother for the participant.


if testing == 1
    % skip PTB calibration
%     Screen('Preference','TextRenderer', 0);  % use old text renderer
    Screen('Preference','TextRenderer', 1);  % use new text renderer
elseif testing == 0
    % run PTB calibration
%     Screen('Preference','TextRenderer', 0);  % use old text renderer
    Screen('Preference','TextRenderer', 1);  % use new text renderer
else
    error('variable "testing" isn''t set properly')
end


[experiment] = get_details({1:4}, 2, true);


spatial_test_retest;


RSVP_test_retest;
