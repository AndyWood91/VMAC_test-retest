clear;
sca;
clc;
KbName('UnifyKeyNames');  % standardise across OSs
% Screen('Preference','TextRenderer', 1);  % use new text renderer
Screen('Preference','TextRenderer', 0);  % use old text renderer
% instructions won't display zzz


% variable declarations
global testing


% testing = 0;  % experimental version
testing = 1;  % testing version


[experiment] = get_details({1:4}, 2, true);


spatial_test_retest;  % run update_details at the end


RSVP_test_retest;  % run update_details at the end
