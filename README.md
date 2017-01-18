# PSC

All files needed for simulation are in this repository.

Let me shortly explain how the project is working :

First, you will only have to use the function 'main.m' in your Matlab terminal to start the simulation.
This programm first initialise the simulated system by evaluating the channel through functions allocation_table and processSNRUnique.
The first one use the second in order to compute the allocation table. The second creates the pilot signal, modulates it with DMT (repartitor.m),
send it through the channel (canal.m) and finally compute the estimated channel, noise per sub-channel and SNR associated.
Then it send those informations to allocation_table.m program which use it to create the allocation table and compute the size of a superframe
(in bits).

After that, lets go back to main.m. It generates a flow of bits, according to the size given by the initialisation phase. IMPORTANT : This size 
can't be changed or be random or it doesn't pass the DMT !!!

This flow of bits are a multiple of superframe length (that's why there is a for loop : we send superframe by superframe and no we can't do 
otherwise because it's in the norm). Each superframe is separated in two kind of datas : Fast Data and Interleaved Data. The only thing that 
change between the two is that Interleaved Data are interleaved whereas Fast Data are not. Except that, they are encoded the same way.

Then we modulate those encoded data with repartitor.m (yes I know, not such a good name). It just modulate the superframe frame by frame and 
then returns the modulated superframe.

After that, we apply the function canal.m to our superframe (I really think the problem is in here). It just do the convolution between the 
superframe and the equivalent filter and then add the noises. 

Finally we demodulate our datas with demodulationDMT and then we decode it. 

And we add the result to our final flow of data. 

We finaly compute the BER.

There is A LOT of Figure into the program so don't be afraid if you see a lot of diagram on your screen. That's normal. You can disable them 
directly in the program.

Good luck !
