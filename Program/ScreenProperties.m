classdef ScreenProperties
    
    properties
        % all the stuff I get/set from the screen display
        
        % colours
        black = [0, 0, 0];
        white = [255, 255, 255];
        
        screen_number = 0;  % primary monitor
        main_window = Screen('OpenWindow', screen_number, black);
        frame_rate = round(Screen('FrameRate', main_window));
        
        % dimensions
        [screen_width, screen_height] = Screen('WindowSize', main_window);
        screen_resolution = [screen_width, screen_height];
        screen_centre = screen_resolution / 2;
    end
    
    methods
        %
    end
    
    enumeration
        %
    end
    
end