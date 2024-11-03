-- File Name: Hazard_detection
-- This file will detect Data Hazard and Brach Hazard and create control signals accordingly
-- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hazard_detection is
  Port (
		DESR_ID_EX: in std_logic_vector(4 downto 0); --Destination register In ID_EX buf (previous instruction)
		SR1_IF_ID: in std_logic_vector(4 downto 0);  -- Source register 1(DA) in IF_ID buf  (new instruction)
		SR2_IF_ID: in std_logic_vector(4 downto 0); -- Source register 2 (DB) in IF_ID buf  (new instruction) 
		branch_taken:in std_logic;   -- branch taken is 1 then select PC+ branch address
		MemRead_ID_EX: in std_logic; -- MemRead in ID_Ex buf for Load 
		branch_stall:out std_logic;  -- clear all control signal if assered in ID stage 
        Clock_En_IF_ID:out std_logic;  -- Flush the instruction for load data hazards
		clear_pipe: out std_logic;  --- instruction will be cleared when asserted
		stall:out std_logic);   -- if asserted then don't increase PC, create stall
end Hazard_detection;   

architecture rtl of Hazard_detection is
begin


process(branch_taken,SR1_IF_ID,SR2_IF_ID,DESR_ID_EX,MemRead_ID_EX)
begin
   -- Default assignments
    Clock_En_IF_ID <= '0';
    stall <= '0';
    clear_pipe <= '0';
    branch_stall <= '0';
	
	-- IF branch_taken = 1 then it will flush the pipleline instruction sel will be zero 
	-- other wise intruction will be whatever fetch 
    if branch_taken = '1' then
        clear_pipe <= '1';  -- instruction will be zero if one
		branch_stall <= '1'; --- branch stall clear all control signal
    end if;
--  if MemRead Destination register of instruction in decode will be same as source in Fetch stage then 
-- then it is load and in load need one cycle to stall because load solved in wb stage. 
    if (DESR_ID_EX = SR1_IF_ID or DESR_ID_EX = SR2_IF_ID) and MemRead_ID_EX = '1'  then
        stall <= '1';   ---pc won't increase 
		Clock_En_IF_ID <= '1'; -- IF_ID _bUF won't able to read new instruction fetch
		branch_stall <= '1';
    end if;
 
end process;

end rtl;
