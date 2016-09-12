% detail_debug

% variable declarations
global testing


% testing = 0;  % experimental version
testing = 1;  % testing version


[experiment] = get_details({1:4}, 2, true);


update_details(experiment, 6);
