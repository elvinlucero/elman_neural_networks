% 
%
function [ret] = main (fname)
	% Initialize words.
	words = {'man', 'woman', 'cat', 'mouse', 'book', 'rock', 'dragon', 'monster', 'glass', 'plate', 'cookie', 'pie', 'think', 'sleep', 'see', 'chase', 'move', 'break', 'smell', 'see', 'break', 'smash', 'eat', 'consume', 'null', 'null','null','null','null','null','null','null'};

	% Define the categories of words.
	noun_hum = [1,2];
	noun_anim = [3,4];
	noun_inanim = [5,6];
	noun_agress = [7,8];
	noun_frag = [9,10];
	noun_food = [11,12];
	verb_intran = [13,14];
	verb_tran = [15,16];
	verb_agpat = [17, 18];
	verb_percept = [19, 20];
	verb_destroy = [21, 22];
	verb_eat = [23, 24];

	bits = {};

	for i=1:numel(words)
		temp = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		temp(i) = 1;
		bits{i} = temp; 
    end
    
	% Define templates for sentence generator
	% To access cell arrays, use: template{1}{1}(1)
	% For the sake of this experiment, we'll only use three word sentences...
    % verb_intran not included here as they are part of 2-word sentences.
	template = {
				{noun_hum, verb_eat, noun_food},
				{noun_hum, verb_percept, noun_inanim},
				{noun_hum, verb_destroy, noun_frag},
				{noun_hum, verb_tran, noun_hum},
				{noun_hum, verb_agpat, noun_inanim},
				{noun_anim, verb_eat, noun_food},
				{noun_anim, verb_tran, noun_anim},
				{noun_anim, verb_agpat, noun_inanim},
				{noun_agress, verb_destroy, noun_frag},
				{noun_agress, verb_eat, noun_hum},
				{noun_agress, verb_eat, noun_anim},
				{noun_agress, verb_eat, noun_food}
	};
		
	input = zeros(1,31);
	output = zeros(1,31);

	size_dat = 50;

	randword = mod(floor(rand(size_dat)*100), 2) + 1;
	randtemp = mod(floor(rand(size_dat)*100), size(template,1)) + 1;

	sequence = [];

	% Generate input sequence...
	for i = 1:numel(randtemp)
		for j = 1:3
			sequence = [sequence template{randtemp(i)}{j}(randword(i))];
		end
    end
    
	% Uncomment to validate test data makes sense...
%    words(sequence)
 	 % sequence
    
    % Define the input and target data 
	%inputs = {};
	%targets = {};
    inputs = zeros(32, numel(sequence)-1);
    targets = zeros(32, numel(sequence)-1);
    for i = 1:(numel(sequence)-1)
        inputs(:, i) = bits{sequence(i)}';
		targets(:, i) = bits{sequence(i+1)}';
    end
    % input ex.
    % man eat
    % eat pie
    % pie dragon
    % dragon consume
    % consime woman
    
    % To validate, uncomment these lines
    % val_inputs = [];
    counts = zeros(32,32);
    for i = 1:numel(sequence)-1
        pl = [find(inputs(:,i)), find(targets(:,i))];
        counts(pl(1),pl(2)) = counts(pl(1),pl(2)) + 1;
    %    val_inputs = [val_inputs; pl];
    end
    % input_data = words(val_inputs);
    counts = counts'; 
    
    % Calculate frequencies of word pairs
    for j=1:32
        counts(:,j) = (counts(:,j))/(sum(counts(:,j)));
    end
    ret = counts;   % return set of frequencies per word pair 
                    % each col represents 1 word, col values represent
                    % frequency of proceeding words
    
    % ALL BUGS DOWN HERE...
    
    % Training section
	if strcmp(fname, 'restart')
        save ('vars', 'sequence', 'words');
        net = elmannet();
        % Removes validation and simply runs training data
        %net.divideFcn = 'dividetrain';
        net.inputs{1}.processFcns = {'removeconstantrows'};
        %[Xs,Xi,Ai,Ts] = preparets(net,inputs,targets);
        %[net, tr] = train(net,Xs,Ts,Xi,Ai);
        [net, tr] = train(net, inputs, targets);
    else
        save ('vars', 'sequence', 'words');
        net = load(fname);
        [Xs,Xi,Ai,Ts] = preparets(net, inputs, targets);
        net = train(net,Xs,Ts,Xi,Ai);
	end

	
	% View network
	%view(net);
	%Y = net(Xs,Xi,Ai);
	%perf = perform(net,Y,Ts);
	
	%Y
    save 'f1' 'net' 'tr'
end
