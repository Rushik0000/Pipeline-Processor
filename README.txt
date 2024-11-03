Project : 32 bit Mini MIPS
Group 3: Rushik Shingala, Abhishek Bhavsar, Saha Anandamoyi

Folder name: Mini MIPS CAD
This folder contains below files (All files are written in VHDL)

1. MIPS.vhd : In this file, all modules are interconnected together.
2. IF_stage.vhd: In this file, First stage of MIPS known as an instruction fetch is implemented.
3. ID_stage.vhd: In this file, second stage of MIPS known as an instruction decode is implemented.
4. Ex_stage.vhd : In this file, third stage of MIPS known as an Execute stage is implemented.
5. Data_memory.vhd: In this file, Data memory and MIPS fourth stage known as a Memory is implemented.
6. Hazard_detection.vhd: In this file, Data and Branch Hazards are detected and stall signals are created.
7. Data_Forwading.vhd: In this file, Data hazards are detected and if possible then data forwarding is done.
8. Instruction_Memory.vhd : In this file, Instruction memory design and instructions are written.
9. MUX5.vhd : In this file, 5 bit multiplexer implemented.
10.MUX32.vhd : In this file, 32 bit multiplexer implemented.
11.MUX322.vhd: In this file, 32 bit multiplexer implemented with 2 select lines (2*4).
12.ADDER.vhd : This file add two inputs (Pc+4).
13.Testbench.vhd: In this file, testbench written to simulate Mini MIPS.