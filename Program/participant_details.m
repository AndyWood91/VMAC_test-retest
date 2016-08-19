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

% bonus_session, bonus_total, finish need to be set at the end of program
% (maybe write another function for this)


function [] = participant_details(conditions, sessions, bonus)
   
    % variable declarations
    global DATA


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
    
    
    % check input types
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
    if exist('raw_data', 'dir') ~= 7  % check for raw_data directory
        mkdir('raw_data')  % make it if it doesn't exist
    end
    
    
    % details Map - participant details stored here
    details = containers.Map({'start'}, {datestr(now, 0)}, ... 
        'UniformValues', false);
    
    
    % Data Validation
    % inputs are compared to options set here using ismember() and
    % rejected if invalid
    gender_options = 'MmOoWw';
    hand_options = 'AaLlRr';
    accept_options = 'Yy';
    reject_options = 'Nn';
    
    
    commandwindow;
    
    
    % data check loop
    while true

        % Number Loop
        while true

            try
                % storing this as a string to stop Matlab accepting expressions
                % or named variables as inputs
                number = input('Participant number --> ', 's');
            catch
                % do nothing with errors, number loop will repeat
            end

            % Validation
            if str2double(number) > 0  % only accept positive values
                details('number') = number;  % add to details Map
                break  % exit the number loop
            else
                % do nothing, number loop will repeat
            end

        end


        % Session
        if sessions > 1

            % Session loop
            while true

                try
                    % storing this as a string to stop Matlab accepting expressions
                    % or named variables as inputs
                    session = input('Session number --> ', 's');
                catch
                    % do nothing with erros, session loop will repeat
                end

                % validation
                if str2double(session) <= sessions
                    break  % exit the sessions loop
                else
                    % do nothing, session loop will repeat
                end

            end

        else

            session = '1';

        end
        
        details('session') = session;  % add to details Map

        
        % filename doesn't include session number here to make it easier to
        % check for previous session's data
        filename = ['raw_data/participant', number, 'session'];

        
        % check for existing datafile
        if exist([filename, session, '.mat'], 'file') == 2
            
            disp(['Session ', session, ' data for participant ', ... 
                number, ' already exists.'])  
            % data check loop will repeat
            
        else
            
            if str2double(session) == 1
                
                % Age Loop
                while true  % loops until a valid answer is given

                    try
                        % storing this as a string to stop Matlab accepting expressions
                        % or named variables as inputs
                        age = input('Participant age --> ', 's');
                    catch
                        % do nothing with errors, age loop will repeat
                    end

                    % Validation
                    if str2double(age) > 0  % only accept positive values
                        details('age') = age;  % add to details Map
                        break  % exit the age loop
                    else
                        % do nothing, age loop will repeat
                    end

                end


                % Gender Loop
                while true  % loops until a valid answer is given

                    try
                        gender = input(['Participant gender (use first' ...
                            ' letter): man/other/woman --> '], 's');
                    catch
                        % do nothing with errors, gender loop will repeat
                    end

                    % Validation
                    if ismember(gender, gender_options)
                        details('gender') = gender;  % add to details Map
                        break  % exit gender loop
                    else
                        % do nothing, gender loop will repeat
                    end

                end


                % Hand Loop
                while true  % loops until a valid answer is given

                    try
                        hand = input(['Participant dominant hand (use', ...
                            ' first letter): ambidextrous/left/right ', ...
                            '--> '], 's');
                    catch
                        % do nothing with errors, hand loop will repeat
                    end

                    % Validation
                    if ismember(hand, hand_options)
                        details('hand') = hand;  % add to details Map
                        break  % exit hand loop
                    else
                        % do nothing, hand loop will repeat
                    end

                end
                
                
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
                        counterbalance(1, a) = mod(str2double(number), ...
                            conditions{a}(end)) + 1;
                    end
                    
                    details('counterbalance') = counterbalance;
                    
                end
                
                % Bonus
                if bonus 
                    
                    details('bonus_total') = 0;
                    
                    if sessions > 1
                        details('bonus_session') = 0;
                    end
                    
                end
                
                break  % exit the data check loop
            
            % check for previous session data
            else
                
                if exist([filename, num2str(str2double(session) - 1), ...
                        '.mat'], 'file') ~= 2
                
                    disp(['Previous session (', ... 
                        num2str(str2double(session) - 1), ...
                        ') data does not exist for participant ', ...
                        number])
                    % data check loop will repeat

                else
                    
                    load([filename, num2str(str2double(session) - 1), ...
                        '.mat'], 'DATA')
                    clc;
                    disp('Previous session details:')
                    disp(['Participant:    ', DATA.details('number')])
                    disp(['Session:        ', DATA.details('session')])
                    disp(['Start time:     ', DATA.details('start')])
%                     disp(['Finish time:    ', DATA.details('finish')])
%                     for testing, add back in later
                    disp(['Age:            ', DATA.details('age')])
                    disp(['Gender:         ', DATA.details('gender')])
                    disp(['Hand:           ', DATA.details('hand')])
                    disp(['Session bonus:  ', num2str(DATA.details('bonus_session'))])
                    disp(['Total bonus:    ', num2str(DATA.details('bonus_total'))])
                    
                    
                    % confirm loop
                    while true  % loops until a valid answer is given
                        
                        try
                            confirm = input(['Are these details ', ...
                                'correct? (y/n) --> '], 's');
                        catch
                            % do nothing with errors, confirm loop will
                            % repeat
                        end
                        
                        if ismember(confirm, accept_options) || ...
                                ismember(confirm, reject_options)
                            break  % exit the confirm loop
                        else
                            % do nothing, confirm loop will repeat
                        end
                        
                    end
                    
                    if ismember(confirm, accept_options)
                        
                        % update details Map
                        details('age') = DATA.details('age');
                        details('gender') = DATA.details('gender');
                        details('hand') = DATA.details('hand');
                        
                        if isKey(DATA.details, 'counterbalance')
                            details('counterbalance') = ...
                                DATA.details('counterbalance');
                        end
                        
                        if isKey(DATA.details, 'bonus_session')
                            details('bonus_session') = 0;
                        end
                        
                        if isKey(DATA.details, 'bonus_total')
                            details('bonus_total') = ...
                                DATA.details('bonus_total');
                        end
                        
                        clear DATA;  % get rid of previous data
                        
                        break  % exit the data check loop
                        
                    else
                        % rejected details, data check loop will repeat
                    end

                end
                
            end
           
        end
        
    end
    
    
    filename = [filename, session];  % include session now
    details('filename') = filename;  % add to details Map
    
    
    % save DATA
    DATA.details = details;
    save(filename, 'DATA');

end
