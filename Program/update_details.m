function [] = update_details()


    % variable declarations
    global DATA bonus_session  % need to be in invoking program/function too
    
    
    % finish
    DATA.raw_data('finish') = datestr(now, 0);
    
    
    % bonus
    if isKey(DATA.raw_data, 'bonus_session')
        DATA.raw_data('bonus_session') = bonus_session;  % store session bonus
        bonus_session = 0;  % reset session bonus
    end
    
    if isKey(DATA.raw_data, 'bonus_total')
        DATA.raw_data('bonus_total') = DATA.raw_data('bonus_total') + bonus_session;  % add session bonus to total
    end
    
    
end