function [val_CRC] = CRC_coding(input_frame)
    
    %generate CRC polinomial and set the bits number is 8
    CRC_po = comm.CRCGenerator([8 4 3 2 0], 'ChecksumsPerFrame',1);
   
    %get CRC datas
    input_with_CRC_transpo = step(CRC_po, input_frame');
    
    %change column vector to row vector
    input_with_CRC = input_with_CRC_transpo';
    
    %get the detection part of data
    val_CRC = input_with_CRC(length(input_frame)+1 : length(input_with_CRC));

    
end
