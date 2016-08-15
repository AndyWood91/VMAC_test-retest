% Participant Details


commandwindow;  % moves cursor to the Command Window


% Data Validation
gender_options = ['M', 'm', 'O', 'o', 'W', 'w'];
hand_options = ['L', 'l', 'A', 'a', 'R', 'r'];
session_options = [1, 2];  % make this into a function and set as arg to scale
accept_options = ['Y', 'y'];
reject_options = ['N', 'n'];
counterbalance_options = [1, 2, 3, 4];  % make this into a function and set as arg to scale


% Data Storage
if exist('participant_data', 'dir') ~= 7  % check if participant_data dir exists
    mkdir('participant_data')  % if not, make it
else
    % do nothing
end


% Number & Session Check
while true  % main while loop

    % Number
    while true  % loops for participant number

        % storing input as string to avoid issues with named variables
        try
            participant_number = input('Participant number --> ', 's');
        catch
            % do nothing
        end

        if str2num(participant_number) > 0  % only accept positive integers
            break  % exit number loop
        else
            % do nothing, loop will repeat
        end

    end
    
    % Session
    while true  % loops until it encounters a break statement

        % storing input as string to avoid issues with named variables
        try
            participant_session = input('Session number (1-2) --> ', 's');
        catch
            % do nothing
        end

        if ismember(str2num(participant_session), session_options)
            break  % exit session loop
        else
            % do nothing
        end

    end
    
    
    % Counterbalancing
    % TODO: scale this
    % sets counterbalancing based on the participant number
    participant_counterbalance = mod(str2num(participant_number), ...
        numel(counterbalance_options)) + 1;
    
    
    % In participant_details dir, file format: participant{}_session
    data_filename = ['participant_data/participant', ... 
        participant_number, '_session'];
    
    
    % check if data for this participant and session exists
    if exist([data_filename, participant_session, '.mat'], 'file') == 2
        disp(['Session ', participant_session, ' data already exists ' ...
            'for participant ', participant_number])
        % main loop will repeat
    else  % data doesn't exist
        
        % if session 2, check for session 1 data
        if str2num(participant_session) == 2
            
            if exist([data_filename, '1.mat'], 'file') ~= 2
                disp(['Session 1 data does not exist for participant ', ...
                    participant_number])
                % main while loop will repeat
            else  % essentially, if it's not session 2 (can scale this)
                break  % exit the main while loop
            end
            
        else
            break  % exit the main while loop
        end
        
    end
    

end


if str2num(participant_session) == 1

    % Age
    while true % age loop

        % storing input as string to avoid issues with named variables
        try
            participant_age = input('Participant age --> ', 's');
        catch
            % do nothing
        end

        if str2num(participant_age) > 0  % only accept positive integers
            break  % exit age loop
        else
            % do nothing
        end

    end


    % Gender
    while true % gender loop

        % storing input as string to avoid issues with named variables
        try
            participant_gender = input(['Participant gender ', ...
                '(use first letter): man/other/woman --> '], 's');
        catch
            % do nothing
        end

        % check if participant_gender is a valid option
        if ismember(participant_gender, gender_options)
            break  % exit gender loop
        else
            % do nothing, loop will repeat
        end

    end

    
    % Dominant Hand
    while true  % hand loop

        % storing input as string to avoid issues with named variables
        try
            participant_hand = input(['Participant dominant hand ', ...
                '(use first letter): left/ambidextrous/right --> '], 's');
        catch
            % do nothing
        end

        if ismember(participant_hand, hand_options)
            break  % exit hand loop
        else
            % do nothing, loop will repeat
        end

    end
    
    
    % Save Data
    DATA.age = participant_age;
    DATA.counterbalance = participant_counterbalance;
    DATA.file = data_filename;
    DATA.gender = participant_gender;
    DATA.hand = participant_hand;
    DATA.participant = participant_number;
    DATA.session = participant_session;
    DATA.start = datestr(now, 0);

    save([data_filename, participant_session, '.mat'], 'DATA');
    
elseif str2num(participant_session) == 2
    
    % load previous session data
    load([data_filename, '1.mat']);
    
    disp(['Age:            ', DATA.age])
    disp(['Counterbalance: ', num2str(DATA.counterbalance)])  % remove in final version
    disp(['File:           ', DATA.file])
    disp(['Gender:         ', DATA.gender])
    disp(['Hand:           ', DATA.hand])
    disp(['Participant     ', DATA.participant])  % remove in final version
    disp(['Session         ', DATA.session])  % maybe remove, not sure
    disp(['Time:           ', DATA.start])
    % TODO: add previous bonus

    
    % Turn this into a function
    while true  % accept details loop
        
        try
            accept = input('Are these details correct? (y/n) --> ', 's');
        catch
            % do nothing
        end
        
        if ismember(accept, reject_options)
            sca;
            clear all;
            error('Details are incorrect, exiting program.')
        elseif ismember(accept, accept_options)
            break  % exit the accept loop
        else
            % do nothing, loop will continue
        end

        
    end
    
    
    % Save Data
    % comments are the same across sessions
%     DATA.age = participant_age;
%     DATA.counterbalance = participant_counterbalance;
%     DATA.file = data_filename;
%     DATA.gender = participant_gender;
%     DATA.hand = participant_hand;
%     DATA.participant = participant_number;
    DATA.session = participant_session;
    DATA.start = datestr(now, 0);
    % TODO: save total bonus
    
    save([data_filename, participant_session, '.mat'], 'DATA');
    
    
end