
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
            <a href="#Sythesis">Sythesis</a>
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
## Simulation
Simulation is the process of creating models that mimic the behavior of the device you are designing (simulation models) and creating models to exercise the device (test benches)
### About iverilog and gtkwave
- Icarus Verilog is an implementation of the Verilog hardware description language.
* GTKWave is a fully featured GTK+ v1. 2 based wave viewer for Unix and Win32 which reads Ver Structural Verilog Compiler generated AET files as well as standard Verilog VCD/EVCD files and allows their viewing.

Installing iverilog and gtwave for **Ubuntu**
```
$ sudo apt-get install iverilog
$ sudo apt-get install gtkwave
```
To simulate and run the verilog code, follow the format:
```
$ iverilog -o my_design example.v example_tb.v
```
This command compiles the design, which is spread across two input files, and generates the compiled result into the "my_design" file. This works for small to medium sized designs. Next execute the compiled program like so:
```
$ vvp my_design
```
To see the output waveform on gtkwave
```
$ gtkwave dumpfile_name.vcd
```

## Synthesis
Synthesis converts a basic RTL (<b>R</b>egister <b>T</b>ransfer <b>Logic</b>) design into a gate-level netlist that includes all of the designer's limitations.

### yosys

Yosys is a framework for Verilog RTL synthesis <br>

**Steps to install yosys**<br>
Install dependencies: 
```
$ sudo apt-get install build-essential clang bison flex \
  libreadline-dev gawk tcl-dev libffi-dev git \
  graphviz xdot pkg-config python3 libboost-system-dev \
  libboost-python-dev libboost-filesystem-dev zlib1g-dev
```





