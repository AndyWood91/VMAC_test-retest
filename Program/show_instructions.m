function [] = show_instructions(instruction_number, instruction_string)


    % check inputs
    if ~isa(instruction_string, 'char')
        error('variable "instruction_string" must be char');
    end
    
    if ~isa(instruction_number, 'double')
        error('variable "instruction_number" must be double');
    end
    
    
end
