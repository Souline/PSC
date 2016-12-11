function [frame_out] = scrambler (frame_in, scrambling_sequence)
	% La calculation base est mise ?? 2 car la sortie de step est un entier compris entre 0 et baseCalculation-1.
	% Le polynome correspond aux registres utilis??s pour la sommes. Pour la norme ADSL il s'agit des registres 0, -18 et -23
    scrambler_object = comm.Scrambler(2, [0, -18, -23], scrambling_sequence);
    
	frame_out = step(scrambler_object, frame_in');
    frame_out = frame_out';
end
