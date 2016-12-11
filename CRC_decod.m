%%CRC Decoding

%This function decodes an input frame given with a CRC-8

%% function : CRC_decod
%  @param : frame : line (1*N) with the CRC
%  @return : 
%       output_without_CRC : the same frame without the CRC
%       error_nb : the number of errors
function [output_without_CRC, error_nb] = CRC_decod(input, CRC)
    
    input_with_CRC = [input CRC];
    CRC_Deco = comm.CRCDetector([8 4 3 2 0], 'ChecksumsPerFrame',1);
    [output_without_CRCtranspo, error_nb] = step(CRC_Deco, input_with_CRC');
    output_without_CRC = output_without_CRCtranspo';
    
end