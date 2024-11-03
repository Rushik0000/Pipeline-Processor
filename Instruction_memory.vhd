---File name: Instruction_memory.vhdl
-- File description: 1KB instruction memory intialize with few instructions
-- based on the PC value Memory Address read 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Instruction_memory is
  port(
    Mem_Address     : in std_logic_vector(31 downto 0);   --- Program counter in to read Instruction memory 
    Instruction_out : out std_logic_vector(31 downto 0)   ----  instructoin out from the Instruction memory
  );
end Instruction_memory;
architecture rtl of Instruction_memory is

type ins_mem_array is array (0 to 1023) of std_logic_vector(7 downto 0);  -- Define memory array (1 Kb)
signal ins_memory : ins_mem_array := (
	-----------------
	X"18",    --ADDI R1,R1,20
	X"21",
	X"00",
	X"14",
	--------------------------
  X"18",  -- ADDI R2,R2, 2
  X"42",
  X"00",
  X"02",
	-----------------
	X"18",       --- ADDI R13,R1,#f;
	X"2D",
	X"00",
	X"0F",
	---------------------------------
	X"18",     --- ADDI R14,R1, #2;
	X"2E",
	X"00",
	X"02",
	----------------------------
	X"18",     --- ADDI R15,R1, #5;
	X"2F",
	X"00",
	X"05",

	--------------------
	X"24",     -- SW R1, R2,2
	X"41",
	X"00",
	X"02",
	-----------------
	X"20",     -- LW R3, R2,2
	X"43",
	X"00",
	X"02",
	-----------------
	X"18",     --ADDI R3,R3, 5;
	X"63",
	X"00",
	X"05",
	----------------------------
	X"18",     -- ADDI R4,R4,15;
	X"84",
	X"00",
	X"0F",
	----------------------
	X"18",     -- ADDI R5,R5, 5
	X"A5",
	X"00",
	X"05",
	--------------------------
	X"18",     --ADDI R6,R5, F;
	X"A6",
	X"00",
	X"0F",
	----------------------------------
	X"1C",     -- BEQ R6,R1, 4
	X"26",
	X"00",
	X"04",
	--------------------------
	X"18",     -- -- ADDI R4,R4,255;  -- dummy should not be run 
	X"84",
	X"00",
	X"FF",
	------------------------------------
	X"18",     -- -- ADDI R4,R4,255;  -- dummy should not be run 
	X"A5",
	X"00",
	X"05",	
	-------------------------------------------
	X"00",     ----- dummy should not be load
	X"00",
	X"00",
	X"00",
	------------------------------
	--X"00000000"
	X"18",     -- ADDI R10,R5,15;
	X"AA",
	X"00",
	X"0F",
	------------------------------------
	X"18",     -- ADDI R5,R5, 5
	X"A5",
	X"00",
	X"05",
	----------------------------
	X"00",     -- XOR r9,r3,r2
	X"43",
	X"48",
	X"03",
	--------------------------------
	X"04",     -- NORI R7,R6, 1;
	X"C7",
	X"00",
	X"01",
	-------------------------------------
	X"10",     -- NANDI R8,R7, 2
	X"E8",
	X"00",
	X"02",
	--------------------------------------
	X"01",    --SUBU R11, R8,R9;  
	X"09",
	X"58",
	X"05",
	--------------------------------------
	X"01",    -- SRL R12, R11, R2  
	X"62",
	X"60",
	X"02",
	---------------------------
	X"2C",    -- J#3;
	X"00",
	X"00",
	X"03",
	-------------------------
	X"19",     -- ADDI R13, R13, D
	X"AD",
	X"00",
	X"0D",
	--------------------
	
	
	  others => (others => '0'));  -- Initialize memory content to all zeros

  begin
    instruction_out <= ins_memory(to_integer(unsigned(Mem_Address))) & ins_memory(to_integer(unsigned(Mem_Address)+1)) & ins_memory(to_integer(unsigned(Mem_Address)+2))& ins_memory(to_integer(unsigned(Mem_Address)+3)) ; -- reading instruction
end rtl;
