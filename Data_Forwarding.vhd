-- File Name: Data_forwarding.vhdl
-- Description : This file content forwarding module this will use to forward data in 
-- data parallelism in MIPS processor 

library IEEE;
use IEEE.std_logic_1164.all;

entity Data_Forwarding is
  Port (WriteReg_EX: in std_logic_vector(4 downto 0);  -- Instruction I+2 Destination register
		WriteReg_ME: in std_logic_vector(4 downto 0);  -- Instruction I+1 Destination register
		REG_WRITE_EX: in std_logic;  -- RegWrite Control IN EX stage
		REG_WRITE_ME: in std_logic;  -- RegWrite Control IN ME stage
		Data_EX_Aluout,Data_ME_LMD: in std_logic_vector(31 downto 0); --- data output for all different level of instructions for ME, and EX stage
        DA_ID_EX,DB_ID_EX: in std_logic_vector(4 downto 0);  -- Insturction I+3 Sources register 1 and 2 address 
		Data_Value_ID1,Data_Value_ID2: in std_logic_vector(31 downto 0); -- -- Insturction I+3 Sources register 1 and 2 value
        Data_valueA,Data_valueB: out std_logic_vector(31 downto 0) );   -- forward unit will select either value from I,I+1,I+2 or own value
end Data_Forwarding;

architecture rtl of Data_Forwarding is
begin
process(DA_ID_EX,DB_ID_EX,Data_EX_Aluout,Data_ME_LMD,Data_Value_ID1,Data_Value_ID2,REG_WRITE_EX,REG_WRITE_ME,WriteReg_EX,WriteReg_ME)
begin
--- ---------------------------------------------------------------------------------
---  if regwrite is asserted and destination register of Execute stage and ID stage source register input 1 same then 
-- aluout of EX stage needs to give input ID stage for previous instruction
    if(WriteReg_EX=DA_ID_EX and REG_WRITE_EX='1') then 
        Data_valueA <= Data_EX_Aluout;
---- if regwrite is asserted destination reg of ME stage is same as ID stage source one then  ME LMD read data needs forward 

    elsif(WriteReg_ME=DA_ID_EX and REG_WRITE_ME='1') then
        Data_valueA <= Data_ME_LMD;
    ---  If all above condition are not satisfied then 
	-- Data value for DATA DA in 1 would be same as in ID_EX_buffer
	else
        Data_valueA <= Data_Value_ID1;    
    end if;  
  ---  if regwrite is asserted and destination register of Execute stage and ID stage source register input 2 same then   aluout of EX stage needs to give input ID stage for previous instruction
  
    if(WriteReg_EX=DB_ID_EX and REG_WRITE_EX='1') then 
        Data_valueB <= Data_EX_Aluout;
---- if regwrite is asserted destination reg of ME stage is same as ID stage source 2 then
-- ME LMD read data needs forward 
    elsif(WriteReg_ME=DB_ID_EX and REG_WRITE_ME='1') then 
        Data_valueB <= Data_ME_LMD;
    ---  If all above condition are not satisfied then 
	-- Data value for DATA DA in 1 would be same as in ID_EX_buffer
	else
        Data_valueB <= Data_Value_ID2;    
    end if;  
	
end process;
end rtl;
