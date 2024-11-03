---File name: data_memory.vhdl
-- File description: 1KB Data memory intialize with zero 
-- based on result of execute stage, it reads memory location

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_memory is
    Port (
        clk       : in  STD_LOGIC;
       -- reset     : in  STD_LOGIC;       
        Write_enable  : in  STD_LOGIC;-- decide whether to perform a write operation 
		MemRead     :  in std_logic;   -- if asserted Memory reading possible 
        Data_write   : in  STD_LOGIC_VECTOR(31 downto 0);    -- Data for store operation
		Data_read : out STD_LOGIC_VECTOR(31 downto 0);   -- data for load operation
        Addr  : in  STD_LOGIC_VECTOR(31 downto 0)  -- load or store address 
       
    );
end Data_memory;

architecture rtl of Data_memory is
    type Memory_Array is array (0 to 1024) of std_logic_vector(7 downto 0);   -- 1kb data memory 
    signal Data_mem_array : Memory_Array := (others=>(others=>'0'));  -- intialize with zero all location
    --signal addr4 : std_logic_vector(31 downto 0);
begin
   --Addr4<= addr(29 downto 0)&"00";
    process (Data_write,Addr,Write_enable )
    begin
  if write_enable ='1' then	
		Data_mem_array(to_integer(unsigned(Addr))) <= Data_write(31 downto 24);   -- write on calculated ALU addresss
		Data_mem_array(to_integer(unsigned(Addr)+1))<= Data_write(23 downto 16);  -- write on calculated ALU addresss +1
		Data_mem_array(to_integer(unsigned(Addr)+2))<= Data_write(15 downto 8);  -- write on calculated ALU addresss +2 
		Data_mem_array(to_integer(unsigned(Addr)+3))<= Data_write(7 downto 0);  -- write on calculated ALU addresss +3
	end if;
    end process;
  process (Memread,addr)
    begin
	if MemRead='1' then
		Data_read<= Data_mem_array(to_integer(unsigned(Addr))) & Data_mem_array(to_integer(unsigned(Addr)+1)) & Data_mem_array(to_integer(unsigned(Addr)+2)) & Data_mem_array(to_integer(unsigned(Addr)+3));
	else 
		Data_read<=X"00000000";		
	end if;
	end process;
end rtl;