
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
            <a href="#simulation">Simulation</a>
        </li>
        <li> 
            <a href="#synthesis">Synthesis</a>
        </li>
        <li>
            <a href="#UART">UART</a>
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
        <li>
            <a href="#useful-links">Useful links</a></li>
        </li>     
    </ol>
</details>

## Introduction

This project aims to interface different Peripherals, Memory integrated with RISC-V(<b>R</b>educed <b>I</b>nstruction <b>S</b>et <b>C</b>omputer) processor and successfully implement it on FPGA.
<br>

## About RISC-V Processor

[FemtoRV](https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/README.md) is a minimalistic RISC-V design, with easy-to-read Verilog sources directly written from the RISC-V specification. The most elementary version (quark), an RV32I core, weights 400 lines of VERILOG (documented version), and 100 lines if you remove the comments. We will be using FemtoRV32 quark version for our SoC.

## Simulation

Simulation is the process of creating models that mimic the behavior of the device you are designing (simulation models) and creating models to exercise the device (test benches)
### About iverilog and gtkwave
- Icarus Verilog is an implementation of the Verilog hardware description language.
* GTKWave is a fully featured GTK+ v1. 2 based wave viewer for Unix and Win32 which reads Ver Structural Verilog Compiler generated AET files as well as standard Verilog VCD/EVCD files and allows their viewing.

Installing iverilog and gtwave for **Ubuntu**

```text
$ sudo apt-get install iverilog
$ sudo apt-get install gtkwave
```

To simulate and run the verilog code, follow the format:
```
$ iverilog example.v example_tb.v
```
This command compiles the design, which is spread across two input files. This works for small to medium sized designs. Next execute the compiled program like so:
```
$ vvp a.out
```
To see the output waveform on gtkwave
```
$ gtkwave dumpfile_name.vcd
```

## Synthesis

Synthesis converts a basic RTL (<b>R</b>egister <b>T</b>ransfer <b>Logic</b>) design into a gate-level netlist that includes all of the designer's limitations.

### yosys

Yosys is a framework for Verilog RTL synthesis <br>

**To install yosys follow the instructions mentioned in this repo** : [Yosys Open SYnthesis Suite](https://github.com/YosysHQ/yosys)

Now simply run yosys_run.sh file, to synthesize: 

``` text

yosys -s yosys_run.sh

```

### Gate Level Simulation (GLS)

GLS is generating the simulation output by running test bench with netlist file generated from synthesis tool as design under test. Netlist is logically same as RTL code, therefore, same testbench can be used for it. We perform this to verify logical correctness of the design after synthesizing it. Also ensuring the timing of the design is met.

run the following command format to perform GLS simulation:

```text
$ iverilog -DFUNCTIONAL -DUNIT_DELAY=#0 ../top_module_directory/verilog_model/primitives.v ../top_module_directory/verilog_model/sky130_
  fd_sc_hd.v my_design_synth.v example_tb.v
$ ./a.out
$ gtkwave dumpfile_name.vcd
```

One will observe that the gtkwave waveform for the netlist should match the waveform to that of the RTL-design given the same testbench.

## UART

A UART ( <b>U</b>niversal <b>A</b>synchronous <b>R</b>eceiver <b>T</b>ransmitter ) is a device-to-device hardware communication protocol that uses asynchronous serial communication with configurable speed.

[UART]()

<hr>

## SPI

SPI is a synchronous, full duplex main-subnode-based interface. The data from the main or the subnode is synchronized on the rising or falling clock edge. Both main and subnode can transmit data at the same time. The SPI interface can be either 3-wire or 4-wire.

![spi](/virtual-expo/assets/img/diode/riscv_soc/spi.png)
Image courtesy: [Analog Devices](https://www.analog.com/en/analog-dialogue/articles/introduction-to-spi-interface.html)
  
<hr>

## Memory

Integrating a Synchronous Dynamic Random Access Memory (SDRAM) with a RISC-V processor typically involves designing a memory controller that interfaces with the SDRAM and communicates with the processor through a bus interface. The memory controller manages the flow of data between the processor and the SDRAM, handling tasks such as address decoding, read and write operations, and refresh cycles.

<hr>

## Wishbone

The [WISHBONE](https://wishbone-interconnect.readthedocs.io/en/latest/01_introduction.html#id2) System-on-Chip (SoC) Interconnection Architecture for Portable IP Cores is a flexible design methodology for use with semiconductor IP cores. Its purpose is to foster design reuse by alleviating System-on-Chip integration problems. This is accomplished by creating a common interface between IP cores. This improves the portability and reliability of the system, and results in faster time-to-market for the end use.

<hr>