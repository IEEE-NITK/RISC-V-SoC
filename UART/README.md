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


Will be adding more information later:)

Waveform for tx
![alt text](https://github.com/IEEE-NITK/RISC-V-SoC/blob/d9b19529c59d462065d4e1837ee77a3d7c6eb79b/UART/tx/uart_tx.png)
