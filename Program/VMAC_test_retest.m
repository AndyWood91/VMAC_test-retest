clear;
sca;
clc;
KbName('UnifyKeyNames');  % standardise across OSs


% variable declarations
global testing


% testing = 0;  % experimental version
testing = 1;  % testing version


[experiment] = get_details({1:4}, 2, true);


spatial_test_retest;


RSVP_test_retest;
