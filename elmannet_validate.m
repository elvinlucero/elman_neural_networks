function [ret] = main (word)
    words = {['man'], ['woman'], ['cat'], ['mouse'], ['book'], ['rock'], ['dragon'], ['monster'], ['glass'], ['plate'], ['cookie'], ['pie'], ['think'], ['sleep'], ['see'], ['chase'], ['move'], ['break'], ['smell'], ['see'], ['break'], ['smash'], ['eat'], ['consume'], ['null'], ['null'],['null'],['null'],['null'],['null'],['null'],['null']};

    idx = 1;
    for i = 1:numel(words)
       if strcmp(words(i), word)
          idx = i;
       else
           continue;
       end
    end
    
    % Find bit representation of word
    bit = zeros(32,1);
    bit(idx) = 1;
    
    % Load learned network
    net = load('f1.mat');
    out = sim(net.net, bit);
    
    % This is stupid but it works.
    ret = [];
    for j=1:numel(words)
        % Strings from 3 vectors will concatenate into each other if stored
        % in array ['3' '0' 'man'] -> '30man'
        % Will not have concatenation problems if separate strings into
        % cell array thus:
        % Ret is vector where each row is cell array containing (in str format):
        % {bit turned on for word, probability of proceeding word, corresponding proceeding word}
        ret = [ ret; % previous ret
               {num2str(bit(j)), num2str(out(j)), words{j}}]; % add new row
    end
end