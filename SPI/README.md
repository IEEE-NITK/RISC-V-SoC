# The Serial Peripheral Interface (SPI)
The Serial Peripheral Interface (SPI) is a synchronous serial communication interface specification used for short-distance communication.
- Example of its uses includes SD card reader modules, RFID card reader modules and 2.4 GHz wireless transmitter/receivers all use SPI to communicate with microcontrollers.
- SPI devices communicate in full duplex mode using a master–slave architecture usually with a single master.
- The master (controller) device originates the frame for reading and writing.
- Multiple slave-devices may be supported through selection with individual chip select (CS), sometimes called slave select (SS) lines.
<hr>

## Signals
The SPI bus specifies four logic signals:
- ```SCLK```: Serial Clock (output from master)
- ```MOSI```: Master Out Slave In (data output from master)(Line for the master to send data to the slave)
- ```MISO```: Master In Slave Out (data output from slave)(Line for the slave to send data to the master)
- ```CS``` /```SS```: Chip/Slave Select (active low, output from master to indicate that data is being sent)(Line for the master to select which slave to send data to)
- ```MOSI``` on a master connects to MOSI on a slave. MISO on a master connects to ```MISO``` on a slave

## CLOCK SIGNALS IN SPI:
- he clock signal synchronizes the output of data bits from the master to the sampling of bits by the slave. One bit of data is transferred in each clock cycle, so the speed of data transfer is determined by the frequency of the clock signal. SPI communication is always initiated by the master since the master configures and generates the clock signal. The clock signal in SPI can be modified using the properties of clock polarity and clock phase
- CPOL determines the polarity of the clock. The polarities can be converted with a simple inverter.
- CPOL=0 is a clock which idles at 0, and each cycle consists of a pulse of 1. That is, the leading edge is a rising edge, and the trailing edge is a falling edge.
- CPOL=1 is a clock which idles at 1, and each cycle consists of a pulse of 0. That is, the leading edge is a falling edge, and the trailing edge is a rising edge.
- CPHA determines the timing (i.e. phase) of the data bits relative to the clock pulses. Conversion between these two forms is non-trivial.
- For CPHA=0, the "out" side changes the data on the trailing edge of the preceding clock cycle, while the "in" side captures the data on (or shortly after) the leading edge of the clock cycle.
- For CPHA=1, the "out" side changes the data on the leading edge of the current clock cycle, while the "in" side captures the data on (or shortly after) the trailing edge of the clock cycle.
- The combinations of polarity and phases are often referred to as modes which are commonly numbered according to the following convention, with CPOL as the high order bit and CPHA as the low order bit. For this project we consider the SPI mode as 0.(CPOL=0 and CPHA=0)

## WORKING:
- STEP 1: The master outputs the clock signal ```o_SPI_Clk```
- STEP 2: The master switches the ```SS/CS``` pin to a low voltage state, which activates the slave
- STEP 3: The master sends the data one bit at a time to the slave along the ```MOSI``` line. The slave reads the bits as they are received
- STEP 4: If a response is needed, the slave returns data one bit at a time to the master along the ```MISO``` line. The master reads the bits as they are received
