--- File name: Adder.VHDL
-- File description: add two inputs 
---  

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity ADDER is
  Port (IN1: in std_logic_vector(31 downto 0);  -- input 1 
		IN2: in std_logic_vector(31 downto 0);  -- input 2
        OUTPUT: out std_logic_vector(31 downto 0) );
end ADDER;
architecture rtl of ADDER is
begin
OUTPUT <= std_logic_vector(unsigned(IN1) + unsigned(IN2)); 
end rtl;
