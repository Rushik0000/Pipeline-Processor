--- File name: MUX32.VHDL 
---  File description: select either input 1 or input 2

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX32 is
  Port (IN1: in std_logic_vector(31 downto 0);
		IN2: in std_logic_vector(31 downto 0);
        SEL: in std_logic;
        OUTPUT: out std_logic_vector(31 downto 0) );
end MUX32;

architecture rtl of MUX32 is
begin
OUTPUT <= IN1 when SEL='1' else IN2; 
end rtl;
