function [] = update_details()

    % variable declarations
    global DATA bonus_session  % need to be in invoking program/function too
    
    
    % finish time
    DATA.details('finish') = datestr(now, 0);
    
    
    % bonus
    if isKey(DATA.raw_data, 'bonus_session')
        DATA.raw_data('bonus_session') = bonus_session;
        bonus_session = 0;  % reset
    end
    
    if isKey(DATA.raw_data, 'bonus_total')
        DATA.raw_data('bonus_total') = DATA.raw_data('bonus_total') + bonus_session;
    end
    
end