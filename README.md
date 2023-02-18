
[![GitHub issues](https://img.shields.io/github/issues/IEEE-NITK/RISC-V-SoC?color=green&label=Issues&style=flat)](https://github.com/IEEE-NITK/RISC-V-SoC/issues)
<br>

<br>
<details>
  <summary>Table of Contents</summary>
    <ol>
        <li>
            <a href="#introduction">Introduction</a>
        </li>
        <li>
            <a href="https://github.com/IEEE-NITK/RISC-V-SoC/tree/main/UART">UART</a>
        </li>
        <li>
            <a href="#SPI">SPI</a> 
        </li>
        <li>
            <a href="#Memory">Memory</a> 
        </li>
        <li>
            <a href="#project-mentors">Project Mentors</a></li>
        </li>
        <li>
            <a href="#project-members">Project Members</a></li>
        </li> 
    </ol>
</details>

## Introduction
This project aims to interface different Peripherals, Memory integrated with RISC-V(<b>R</b>educed <b>I</b>nstruction <b>S</b>et <b>C</b>omputer) processor and successfully implement it on FPGA.

<br>
<hr>

## UART
A UART ( <b>U</b>niversal <b>A</b>synchronous <b>R</b>eceiver <b>T</b>ransmitter ) is a device-to-device hardware communication protocol that uses asynchronous serial communication with configurable speed.

<details>
  <summary>UART basically contains two parts for transmission</summary>
    <ul>
      <li> Transmitter ( tx ) <br> Used to transmit the data serially.
        <p> Clock signal is given by <code> i_clk </code>. <br> The transmitter starts transmitting the data only when the <code> i_wr </code>( write ) is asserted, else transmits one. <br> <code> i_data </code> stores the start bit ( zero ) with the data bits to be transmitted. <br> <code> o_busy </code> signal indicates whether the transmitter is transmitting the data or not. <br> The single bit output of the transmitter is given by <code> o_uart_tx </code> signal.
        </p>
      </li>
      <li>
        Receiver ( rx ) <br>
        Used to receive the data serially.
      </li>
    </ul>
</details>

<br>
<hr>
