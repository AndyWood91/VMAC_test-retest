%% participant_details

% conditions is an optional argument if you want to set counterbalancing.
% Needs to be a cell array containing the range of possible values for each
% condition, e.g. {[1:3] [1:4]} means there are 2 conditions, the first
% with 3 possible values and the second with 4.

% sessions is an optional argument for the number of experimental sessions.
% Default is 1. 

% bonus is an optional logical if the experiment includes a performance
% bonus. Default is false.

% needs to have global DATA declared in invoking program, that's what it
% will save the information to.

% bonus_session, bonus_total, & finish are updated by the update_details
% function, which needs to be run at the end of the experimental program

%% code

function [] = participant_details(conditions, sessions, bonus)
   
    % variable declarations
    global DATA  % needs to be in invoking program/function too


    % set any missing inputs
    if nargin < 3
        bonus = false;  % default, no bonus
    end
        
    if nargin < 2
        sessions = 1;  % default, 1 experimental session
    end
    
    if nargin < 1
        conditions = {};  % default, no conditions
    end
    
    
    % check inputs
    if ~isa(conditions, 'cell')
        error('conditions must be a cell')
    end
    
    if ~isa(sessions, 'double')
        error('sessions must be a double')
    end
    
    if ~isa(bonus, 'logical')
        error('bonus must be a logical')
    end
    
    
    % data storage    
    % identifying information stored separately for anonymity
    if exist('participant_details', 'dir') ~= 7  % check for participant details directory
        mkdir('participant_details')  % make it if it doesn't exist
    end
    
    if exist('raw_data', 'dir') ~= 7  % check for raw_data directory
        mkdir('raw_data')  % make it if it doesn't exist
    end
        
    % details Map - participant details stored here
    details = containers.Map('UniformValues', false);
    
    % raw_data Map - experiment data stored here
    raw_data = containers.Map({'start'}, {datestr(now, 0)}, 'UniformValues', false);
    
    
    % data validation
    % inputs are compared to options set here using ismember() and rejected if invalid
    gender_options = 'MmOoWw';
    hand_options = 'AaLlRr';
    accept_options = 'Yy';
    reject_options = 'Nn';
    
    
    commandwindow;
    
    
    % data check loop
    % these loops will repeat until a valid input is given
    while true

        % number loop
        while true

            try
                number = input('Participant number --> ', 's');  % storing this as a string to stop Matlab accepting expressions or named variables as inputs
            catch
                % do nothing with errors, number loop will repeat
            end

            % validation
            if str2double(number) > 0  % only accept positive values
                details('number') = number;  % add to details Map
                raw_data('number') = number;  % add to raw_data Map
                break  % exit the number loop
            else
                % do nothing, number loop will repeat
            end

        end


        % sessions
        if sessions > 1  % number of experimental sessions, not the current session

            % session loop
            while true

                try
                    session = input('Session number --> ', 's');  % stored as a string to stop Matlab accepting expressions or named variables as inputs
                catch
                    % do nothing with errors, session loop will repeat
                end

                % validation
                if str2double(session) <= sessions
                    break  % exit the session loop
                else
                    % do nothing, session loop will repeat
                end

            end

        else

            session = '1';

        end
        
        raw_data('session') = session;  % add to raw_data Map

        
        % filenames
        data_filename = ['raw_data/participant', number, 'session'];  % data_filename doesn't include session number to make it easier to check for previous session's data
        details_filename = ['participant_details/participant', number];

        
        % check for existing datafile
        if exist([data_filename, session, '.mat'], 'file') == 2
            
            clc;
            data_exists = 'Session %c data for participant %c already exists.\n\n';
            fprintf(data_exists, session, number);
            % data check loop will repeat
            
        else
            
            if str2double(session) == 1  % first session
                
                % age loop
                while true

                    try
                        age = input('Participant age --> ', 's');  % stored as a string to stop Matlab accepting expressions or named variables as inputs
                    catch
                        % do nothing with errors, age loop will repeat
                    end

                    % validation
                    if str2double(age) > 0  % only accept positive values
                        details('age') = age;  % add to details Map
                        break  % exit the age loop
                    else
                        % do nothing, age loop will repeat
                    end

                end


                % gender loop
                while true
                    
                    try
                        gender = input('Participant gender (use first letter): man/other/woman --> ', 's');  % stored as a string to stop Matlab accepting expressions or named variables as inputs
                    catch
                        % do nothing with errors, hand loop will repeat
                    end

                    % validation
                    if ismember(gender, gender_options)
                        
                        % probably a better way to do this
                        if strcmp(gender, 'M') || strcmp(gender, 'm')
                            gender = 'man';
                        elseif strcmp(gender, 'O') || strcmp(gender, 'o')
                            gender = 'other';
                        elseif strcmp(gender, 'W') || strcmp(gender, 'w')
                            gender = 'woman';
                        end
                        
                        details('gender') = gender;  % add to details Map
                        break  % exit gender loop
                        
                    else
                        % do nothing, gender loop will repeat
                    end

                end


                % hand loop
                while true
                    
                    try
                        hand = input('Participant dominant hand (use first letter): ambidextrous/left/right --> ', 's');  % stored as a string to stop Matlab accepting expressions or named variables as inputs
                    catch
                        % do nothing with errors, hand loop will repeat
                    end

                    % validation
                    if ismember(hand, hand_options)
                        
                        % probably a better way to do this
                        if strcmp(hand, 'A') || strcmp(hand, 'a')
                            hand = 'ambidextrous';
                        elseif strcmp(hand, 'L') || strcmp(hand, 'l')
                            hand = 'left';
                        elseif strcmp(hand, 'R') || strcmp(hand, 'r')
                            hand = 'right';
                        end
                        
                        details('hand') = hand;  % add to details Map
                        
                        break  % exit hand loop
                        
                    else
                        % do nothing, hand loop will repeat
                    end

                end
                
                % save participant details and clear data
                DATA.details = details;
                save(details_filename, 'DATA');
                clear('DATA');
                
                
                % Counterbalance
                % TODO: the counterbalancing here should probably
                % increment by a different amount each time if there is
                % more than one condition but I don't have time to build
                % that right now
                if numel(conditions) > 0
                    
                    % blank array to store values
                    counterbalance = zeros(1, numel(conditions));
                    
                    for a = 1:numel(conditions)  % for each condition,
                        % number is divided by the number of possible
                        % values for that condition. Add 1 to shift floor
                        % up from 0 (if number is perfectly divisible by 1)
                        counterbalance(1, a) = mod(str2double(number), conditions{a}(end)) + 1;
                    end
                    
                    raw_data('counterbalance') = counterbalance;
                    
                end
                
                % bonus
                if bonus 
                    raw_data('bonus_session') = 0;
                    raw_data('bonus_total') = 0;                
                end
                
                break  % exit the data check loop
            
            % check for previous session data
            else  % not the first session
                
                if exist([data_filename, num2str(str2double(session) - 1), '.mat'], 'file') ~= 2

                    clc;
                    data_missing = 'Previous session (%c) data does not exist for participant %c.\n\n';
                    fprintf(data_missing, num2str(str2double(session) -1), number);
                    % data check loop will repeat

                else
                    
                    clc;
                    load([details_filename, '.mat'], 'DATA');

                    disp('Previous session details:')
                    disp(['Participant:    ', DATA.details('number')])
                    disp(['Age:            ', DATA.details('age')])
                    disp(['Gender:         ', DATA.details('gender')])
                    disp(['Hand:           ', DATA.details('hand')])
                    
                    load([data_filename, num2str(str2double(session) - 1), '.mat'], 'DATA');
                    
                    disp(['Session:        ', DATA.raw_data('session')])
                    disp(['Start time:     ', DATA.raw_data('start')])
                    
                    if isKey(DATA.raw_data, 'finish')  % for testing, finish won't exist until it's saved at the end of the program
                        disp(['Finish time:    ', DATA.raw_data('finish')])
                    end
                    
                    if isKey(DATA.raw_data, 'bonus_session')
                        disp(['Session bonus:  ', num2str(DATA.raw_data('bonus_session'))])
                    end
                    
                    if isKey(DATA.raw_data, 'bonus_total')
                        disp(['Total bonus:    ', num2str(DATA.raw_data('bonus_total'))])
                    end
                    
                    
                    % confirm loop
                    while true
                        
                        try
                            confirm = input('Are these details correct? (y/n) --> ', 's');
                        catch
                            % do nothing with errors, confirm loop will repeat
                        end
                        
                        if ismember(confirm, accept_options) || ismember(confirm, reject_options)
                            break  % exit the confirm loop
                        else
                            % do nothing, confirm loop will repeat
                        end
                        
                    end
                    
                    if ismember(confirm, accept_options)
                        
                        % get these values from last session's data
                        if isKey(DATA.raw_data, 'counterbalance')
                            raw_data('counterbalance') = DATA.raw_data('counterbalance');
                        end
                        
                        if isKey(DATA.raw_data, 'bonus_session')
                            raw_data('bonus_session') = 0;
                        end
                        
                        if isKey(DATA.raw_data, 'bonus_total')
                            raw_data('bonus_total') = DATA.raw_data('bonus_total');
                        end
                        
                        clear DATA;  % get rid of previous data
                        
                        break  % exit the data check loop
                        
                    else
                        
                        clc;
                        % rejected details, data check loop will repeat
                        
                    end

                end
                
            end
           
        end
        
    end
    
    
    data_filename = [data_filename, session];  % include session now
    raw_data('data_filename') = data_filename;  % add to raw_data Map
   
    % save DATA
    DATA.raw_data = raw_data;
    save(data_filename, 'DATA');

end
