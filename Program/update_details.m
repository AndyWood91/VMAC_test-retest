% session_bonus is an optional argument in the format 

% saves finish time, bonus_session, bonus_total to DATA.experiment

function [] = update_details(experiment, session_bonus)
      

    % set  missing inputs
    if nargin < 2
        session_bonus = 0;  % default, no bonus
    end
    
    
    % finish
    experiment('finish') = datestr(now, 0);
    
    
    % bonus
    if isKey(experiment, 'bonus_session')
        experiment('bonus_session') = session_bonus;  % store session bonus
    end
    
    if isKey(experiment, 'bonus_total')
        experiment('bonus_total') = experiment('bonus_total') + session_bonus;  % add session bonus to total
    end
    
    
    % save
    if exist('raw_data', 'dir') ~= 7  % check for raw_data directory
        mkdir('raw_data')  % make it if it doesn't exist
    end
    
    save(experiment('data_filename'), 'experiment');
    
    
end