clear all;
sca;
clc;
KbName('UnifyKeyNames');  % standardise across OSs


% variable declarations
global DATA  % needs to be in invoking program/function too
global testing

% testing = 0;  % experimental version
testing = 1;  % testing version


participant_details({1:4}, 2, true);


spatial_test_retest;


RSVP_test_retest;
