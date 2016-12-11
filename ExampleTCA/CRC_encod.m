%%CRC Encoding

%This function encodes an input frame given with a CRC-8

%% function : CRC_encod
%  @param : frame : line (1*N)
%  @return : the same frame with the CRC added
function [val_CRC] = CRC_encod(input_frame)
    
    CRC_Gene = comm.CRCGenerator([8 4 3 2 0], 'ChecksumsPerFrame',1);
    input_with_CRC_transpo = step(CRC_Gene, input_frame');
    input_with_CRC = input_with_CRC_transpo';
    val_CRC = input_with_CRC(length(input_frame)+1 : length(input_with_CRC));
    
end
