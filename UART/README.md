# UART Communication
UART(Universal Asynchronous Receiver Transmitter) 
- An interface that sends out data usually byte at a time over a single wire.
- Data transfer is **independant** of clock pulse hence asynchronous
- UARTs can operate in either Half-Duplex(two transmitters sharing a line) or Full-Duplex(two transmitters each with their own line).

## Several Parameters that can be set by user
- Baud Rate (bits transmitted per second)
- Number of Data bits 
- Parity Bit
- Stop bits

As mentioned this interface does not have a clock, the data must be sampled to recover it correctly. It needs to be sampled at least eight times faster than the rate of the data bits. </br>
This means for an *115200* baud UART, the data needs to be sampled **atleast** at 921.6 KHz (115200 * 8 bits).

## UART communication contains two main parts
- Transmitter
- Receiver

## Transmitter ( tx )
It transmits the data serially 8 bits per second. The signals used in the transmitter.
- ```i_clk``` is used for the clock signal.
- Transmits the data only when the ```i_wr``` signal is asserted. Else transmits high signal.
- ```i_data``` stores the start bit ( zero ) with the data bits to be transmitted.
- ```o_busy``` signal indicates whether the transmitter is transmitting the data or not.
- The single bit output of the transmitter is given by ```o_uart_tx``` signal.

We have 4 registers
- ```state``` , ```baud_counter``` , ```local_data``` , ```baud_stb``` , for storing the state of the FSM, the clock cycles, the data bits with start and stop bits, and a flag (for indicating the readiness to transmit next bit i.e., transmits next bit if it is high) respectively.

There are 10 states in our FSM
- ```BIT_ZERO``` , ```BIT_ONE``` , ```BIT_TWO``` , ```BIT_THREE``` , ```BIT_FOUR``` , ```BIT_SIX``` , ```BIT_SEVEN``` are 8 states each for 8 different bits.
- ```LAST``` for last bit in transmition.
- ```IDLE``` when the transmittion isn't taking place.

### Working
This module takes ```i_clk``` , ```i_data``` , ```i_wr``` as inputs and outputs ```o_busy``` , ```o_uart_tx``` . Initially the state is made ```IDLE``` and ```o_busy``` will be low, since the transmission is not started. We have 3 always block which are triggered for each positive ```i_clk``` edge. 

The first block is the state machine. Initially transmission starts when the ```i_wr``` is high and ```o_busy``` is low, ```o_busy``` is asserted and state is assigned as ```START``` as soon as the transmission starts.

When the ```baud_stb``` is high is when state chnages or not. If ```state``` is at ```IDLE``` then it remains at ```IDLE``` and ```o_busy``` becomes low , otherwise it leads to incrementation of state and ```o_busy``` becomes high.

The ```baud_counter``` acts as a decremental counter that keeps track of number of cycles between each bit.

When state changes from ```BIT_SEVEN``` to ```LAST```, all bits have been transferred.

## Receiver ( rx )
It receives data bit by bit at the rate of 8 bits per second.
- ```i_clk``` is used for the clock signal.
- ```i_rx_data``` is bitwise input data signal included with start and stop bits.
- ```o_wr``` is asserted when the data in ```o_data``` is ready to be read.
- ```o_data``` is an output register to output the recived data.

We have 5 registers
- ```STATE```, ```baud_count```, ```zero_baud```, ```ck_uart```, ```q_uart```. For storing fsm state, clock cycles, flag to start next state. where we use ```ck_uart``` to induce delay.

There are 10 states in our FSM
- ```BIT_ZERO```, ```BIT_ONE```, ```BIT_TWO```, ```BIT_THREE```,```BIT_FOUR```, ```BIT_FIVE```, ```BIT_SIX```, ```BIT_SEVEN``` are 8 states for different bits.
- ```IDLE```when there's no receiving taking place, ```STOP_BIT``` to terminate the receiving after getting all 8 bits.

### Working
This module takes ```clk``` , ```i_rx_data``` as inputs and outputs ```o_wr``` , ```o_data``` . Initially the state is made ```IDLE``` and ```o_data```,```o_wr``` will be low, since the receiving is not started. We have 4 always block which are triggered for each positive ```clk``` edge.

When ```ck_uart``` becomes low, it means start bit is detected, state changes from ```IDLE``` to ```BIT_ZERO``` and ```baud_count``` is initilized.

The ```baud_count``` acts as a decremental counter that keeps track of number of cycles between each bit. When the ```baud_count``` reaches zero then ```zero_baud``` flag is set high which increments the state. When state changes from ```BIT_SEVEN``` to ```STOP_BIT```, all bits have been received and the receiving process stops.

Waveform for tx
![alt text](https://github.com/IEEE-NITK/RISC-V-SoC/blob/main/UART/tx/uart_tx.png)
