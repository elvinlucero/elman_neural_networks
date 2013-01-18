function [ret] = main (strnet, strvar)
    words = {['man'], ['woman'], ['cat'], ['mouse'], ['book'], ['rock'], ['dragon'], ['monster'], ['glass'], ['plate'], ['cookie'], ['pie'], ['think'], ['sleep'], ['see'], ['chase'], ['move'], ['break'], ['smell'], ['hear'], ['destroy'], ['smash'], ['eat'], ['consume']};

    bit = {};
	for i=1:numel(words)
		temp = zeros(32,1);
		temp(i) = 1;
		bit{i} = temp; 
    end
    nets = load(strnet);
    vars = load(strvar);
    
    sequence = vars.sequence;
    net = nets.net;
    
    % Cell array of hidden activations where each index corresponds to the
    % word array index "words"
    hiddens = {};
    hidden = [];
    hid_activations = zeros(150,1);
    for i = 1:numel(words)
       hiddens{i} = []; 
    end
    
    for i = 1:numel(sequence)
        % Get biases
        bias = net.b{1}*ones(1,size(bit{sequence(i)},2));
        
        % Get the activations for the input and hidden...
        in_activations = ([net.IW{1} zeros(150,8)])*bit{sequence(i)};
        if i ~= 1
            hid_activations = (net.LW{1}(:, 1:150)*hidden);
        end
        % Calculate new hidden
        hidden = tansig(in_activations + bias + hid_activations);

        % Store it to cell array of word hiddens
        hiddens{sequence(i)} = [hiddens{sequence(i)} hidden];
    end
    
    hid_means = [];
    for i=1:numel(hiddens)
        i
        hid_means = [hid_means mean(hiddens{i},2)];
    end
    save 'hiddens' 'hid_means'
    
    dendrogram (linkage(hid_means'), 'labels', words, 'orientation', 'left');
end