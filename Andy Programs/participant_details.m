% Participant Details
% TODO: reject floats from str2num conversions


% Data Validation
gender_options = ['M', 'm', 'W', 'w', 'O', 'o'];
hand_options = ['L', 'l', 'A', 'a', 'R', 'r'];
session_options = [1, 2];


% Data Storage
% creates a directory called 'raw_data' if it doesn't already exist
if exist('raw_data', 'dir') ~= 7
    mkdir('raw_data')
else
    % do nothing
end


% Number
while true  % loops until it encounters a break statement
    
    % storing input as string to avoid issues with named variables
    try
        participant_number = input('Participant number --> ', 's');
    catch
        % do nothing
    end
    
    % TODO: work out how to reject floats
    if str2num(participant_number) > 0  % only accept positive integers
        break  % exit the while loop
    else
        % do nothing
    end
   
end


% Session
while true
    
    % storing input as string to avoid issues with named variables
    try
        participant_session = input('Session number (1-2) --> ', 's');
    catch
        % do nothing
    end
    
    if ismember(str2num(participant_session), session_options)
        break  % exit the while loop
    else
        % do nothing
    end
    
end

% TODO: check session number. If 1, ask for inputs, if 2, check inputs


data_filename = ['raw_data/participant', participant_number, ...
    '_session', participant_session];



% Age
while true % loops until it encounters a break statement
    
    % storing input as string to avoid issues with named variables
    try
        participant_age = input('Participant age --> ', 's');
    catch
        % do nothing
    end
    
    % TODO: work out how to reject floats
    if str2num(participant_age) > 0  % only accept positive integers
        break  % exit the while loop
    else
        % do nothing
    end
   
end


% Gender
while true % loops until it encounters a break statement
    
    % storing input as string to avoid issues with named variables
    try
        participant_gender = input(['Participant gender ', ...
            '(use first letter): man/other/woman --> '], 's');
    catch
        % do nothing
    end
    
    % check if participant_gender is a valid option
    if ismember(participant_gender, gender_options)
        break  % exit the while loop
    else
        % do nothing
    end
   
end

% Dominant Hand
while true
    
    % storing input as string to avoid issues with named variables
    try
        participant_hand = input(['Participant dominant hand ', ...
            '(use first letter): left/ambidextrous/right --> '], 's');
    catch
        % do nothing
    end
    
    if ismember(participant_hand, hand_options)
        break  % exit the while loop
    else
        % do nothing
    end
    
end

DATA.participant = participant_number;
DATA.session = participant_session;
% DATA.counterbalance = participant_counterbalance;
DATA.age = participant_age;
DATA.gender = participant_gender;
DATA.hand = participant_hand;
% DATA.start = participant_start

save(data_filename, 'DATA');
