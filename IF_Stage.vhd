-- File name : IF_stage.VHDL
-- this file perform action for instruction fetch stage of mips 
-- it includes pc calculation and 
-- instruction fetch 
-- instruction select based on branch and data hazard

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IF_stage is
  Port (clk :in std_logic;
		rst:in std_logic;   -- if asserted then clear all signal 
		clear_pipe: in std_logic;  -- if asserted it means there is hazard and branch taken 
		Branch_taken:in std_logic;  -- Branch taken is asserted means select branch address
		stall:in std_logic;   --  it means there is data hazards
        Branch_Adder:in std_logic_vector(31 downto 0);  -- branch address calculated from EX stage 
		instruction_read: in std_logic_vector(31 downto 0); -- instruction read from instruction memory
        PC:out std_logic_vector(31 downto 0);
		instruction_fetch: out std_logic_vector(31 downto 0)); -- instruction selected if stall selected is zero );  
end IF_stage;

architecture rtl of IF_stage is
-------------------------------------
signal PC_SELECT, PC_PIPE, PRE_PC :std_logic_vector(31 downto 0):= X"00000000";  ---- initialize all signals
constant clear: std_logic_vector(31 downto 0):= (others=>'0');    -- clear signal to flash the instruction 
signal PC_INCR: std_logic_vector(31 downto 0):= X"00000004";  --- initialize with pc increament value 4 
-----------------------------------------

component MUX32
Port (IN1: in std_logic_vector(31 downto 0);
		IN2: in std_logic_vector(31 downto 0);
        SEL: in std_logic;
        OUTPUT: out std_logic_vector(31 downto 0) );
end component;

component ADDER
Port (IN1: in std_logic_vector(31 downto 0);
		IN2: in std_logic_vector(31 downto 0);
        OUTPUT: out std_logic_vector(31 downto 0) );
end component; 

--------------------------------------------

begin 
  ---  if branch hazard is detected then it will fetch clear instruction means no instruction
	Ins_sel:  MUX32 port map (IN1=> clear, IN2=> instruction_read, SEL=> clear_pipe, OUTPUT=>instruction_fetch);
    process(clk,rst)
    begin
     if rising_edge(clk) then
     -- if rst asserted then PC will be zero 
        if(rst='1') then
           PRE_PC <= (others=>'0');
		   -- if stall is zero then PC SELECT 
        elsif(stall = '0') then   -- stall is 1 then PC value won't change
            PRE_PC <= PC_SELECT;  -- cuurent value of PC 
         end if;   
      end if;    
    end process;
	  PC <= PRE_PC;  
	-- ADDER will calculate PC+4 
	ADDER_4 : ADDER port map (IN1=>PRE_PC, IN2=>PC_INCR, OUTPUT=>PC_PIPE);  ---PC_PIPE current PC + 4 
    -- MUX 32 bit either select  branch address or PC+4
	MUX_32: MUX32 port map (IN1=>Branch_Adder, IN2=>PC_PIPE, SEL=>Branch_taken, OUTPUT=>PC_SELECT);
	
end rtl;
