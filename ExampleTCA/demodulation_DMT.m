function [suite_bits] = demodulation_DMT( signal_receive, prefix_cyclic, allocation_table )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes her
   signal_receive = signal_receive(1+prefix_cyclic:512 + prefix_cyclic);
   signal_receive_f = fft(signal_receive);
   signal_reveive_f = signal_receive_f(1:256);
   for i=1:256
       if (allocation_table(i)~=0)
           suite_bits = MQAMDemod(2^(allocation_table(i)),signal_receive_f);
       end
   end

end

