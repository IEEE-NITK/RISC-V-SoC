# Basic FIFO Design

Serial ports can easily get overloaded with information let’s build a FIFO to tackle that.

References:</br>
[Verilog Arrays and Memories](https://www.chipverify.com/verilog/verilog-arrays) </br>
[ZipCpu tutorials](https://zipcpu.com/tutorial/lsn-10-fifo.pdf)

**I/O Ports of a FIFO**</br>
Our memories constrain much of our logic:</br>

- Writes to the FIFO memory</br>
- Reads from the FIFO memory</br>

<hr>

### Signals of importance

**i_wr && !o_full**:  i_ data is written to FIFO</br>
**i_rd && !o_empty**: we will return o_data from the FIFO </br>

trick to the addresses...</br>
For a memory of 2^N elements</br>
With an N-bit array index</br>


### Flaws in our design so far</br>

We broke our memory rules, not sure how :/</br>
always (*) o_data = fifo_mem[rd_addr];</br>

Logic also depends on wr_fifo and rd_fifo</br>
These values depend upon o_full and o_empty -> N bit subtract comparison </br>
This will limit the total speed of our design</br>

To be honest, I still am not able to get used to formal verification ;)</br>
So will try simulating all kinds of possible cases to verify the FIFO</br>

Case 1: Write two arbitrary values to it in succession and prove that you can read those same values back later</br>


**Waveform**
![Waveform](https://github.com/IEEE-NITK/RISC-V-SoC/blob/main/UART/fifo/images/waveform.png)

**Memory**
![Memory](https://github.com/IEEE-NITK/RISC-V-SoC/blob/main/UART/fifo/images/memory.png)
 






