--- File name: MUX5.VHDL 
---  File description: select either input 1 or input 2

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX5 is
  Port (In1: in std_logic_vector(4 downto 0);
		In2 : in std_logic_vector(4 downto 0);
        SEL: in std_logic;
        OUTPUT: out std_logic_vector(4 downto 0) );
end MUX5;

architecture rtl of MUX5 is
begin
OUTPUT <= IN1 when SEL='1' else IN2; 
end rtl;
