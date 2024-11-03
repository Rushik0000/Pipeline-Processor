-- File name: Testbench.vhdl 
-- File description: Instantiate MIPS processor 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Testbench is
end Testbench;

architecture rtl of Testbench is

-- Define the clock period (in nanoseconds)
constant CLOCK_PERIOD : time := 100 ns;

--main module of MIPS
component MIPS is 
  port(
       clk : in std_logic;
	   rst: in std_logic);
end component;

signal rst: std_logic := '0';
signal clk: std_logic := '0';

begin

-- body part(main part)
Processor: MIPS port map(clk=> clk, rst=>rst);


--unit_data_mem : Data_memory
--port map(clk => clk1);


process 
begin 

rst<= '1';
wait for 400 ns;
  rst<= '0';
  wait;
end process;
  
  
process
begin
   -- Initialize clock
     clk<= '0';
   
   -- Loop forever, toggling the clock
   while true loop
      -- Toggle clock
      clk <= not clk;
      
      -- Delay for half the clock period
      wait for CLOCK_PERIOD / 2;
   end loop;
end process;
  

end rtl;

