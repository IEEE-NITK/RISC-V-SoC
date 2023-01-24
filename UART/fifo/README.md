Basic FIFO Design
Serial ports can easily get overloaded with information let’s build a FIFO to tackle that.

References:
Verilog Arrays and Memories
https://zipcpu.com/tutorial/lsn-10-fifo.pdf
Serial Port Reciever:
https://zipcpu.com/tutorial/lsn-09-serialrx.pdf

Build a Block RAM:
https://zipcpu.com/tutorial/lsn-08-memory.pdf

I/O Ports of a FIFO
Our memories constrain much of our logic:
Writes to the FIFO memory
Reads from the FIFO memory

i_wr && !o_full:  i_ data is written to FIFO
i_rd && !o_empty: we will return o_data from the FIFO

trick to the addresses...
For a memory of 2^N elements
With an N-bit array index



Flaws in our design so far
We broke our memory rules, not sure how :/
always (*) o_data = fifo_mem[rd_addr];

Logic also depends on wr_fifo and rd_fifo
These values depend upon o_full and o_empty -> N bit subtract comparison 
This will limit the total speed of our design

To be honest, I still am not able to get used to formal verification
So will try simulating all kinds of possible cases to verify the FIFO

Case 1: Write two arbitrary values to it in succession and prove that you can read those same values back later

 






