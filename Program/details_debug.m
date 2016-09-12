% variable declarations
global DATA
global testing

% testing = 0;  % experimental version (not getting used here)
testing = 1;  % testing version

if testing == 1
    clear DATA;
end

[experiment] = get_details({1:4}, 2, true);

update_details(experiment, 6);
