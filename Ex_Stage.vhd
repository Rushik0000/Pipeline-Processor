-- File name: EX_stage.VHDL 
-- this file contain opration that needs to do in execute stage of MIPS processor 
-- 1- it will evulate expression
-- 2 - it will solve branch and jump and calculate address and check branch condition
-------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity Ex_Stage is
  port (
		Control_EX: in std_logic_vector(6 downto 0);    ----  (Regdst,6),(ALUsrc,5),(Jump,4),(Branch,3),ALU) -- control alu operation 
		PC: in std_logic_vector(31 downto 0);     -----------   Program counter 
		Source_reg2: in std_logic_vector(4 downto 0); ---  source register for R type instruction and destination for all others 
		Des_reg: in std_logic_vector(4 downto 0); -- destination register for R type
		Input1: in std_logic_vector(31 downto 0);  -- Data input 1
		Input2: in std_logic_vector(31 downto 0);  -- data Input 2
		Imm_Value:  in std_logic_vector(31 downto 0);  -- Immediate Value 
        PCSource: out std_logic;  --  Program counter source if branch or jump then 1 
		DesR_WB: out std_logic_vector(4 downto 0); --- destination register in WB stage write back reg address
		Branch_address: out std_logic_vector(31 downto 0);  --calculated  branch address 
		ALUOut: out std_logic_vector(31 downto 0));   --- output of alu
end Ex_Stage;

architecture rtl of Ex_Stage is

signal zero_condition:std_logic;
signal in2,in3: std_logic_vector(31 downto 0);

constant NORI_ALU: std_logic_vector(2 downto 0):= "001";  
constant SRL_ALU: std_logic_vector(2 downto 0):= "010";
constant XOR_ALU: std_logic_vector(2 downto 0):= "011";
constant NAND_ALU: std_logic_vector(2 downto 0):= "100";
constant SUBU_ALU: std_logic_vector(2 downto 0):= "101";
constant ADDI_ALU: std_logic_vector(2 downto 0):= "110";
constant BEQ_ALU: std_logic_vector(2 downto 0):= "111";
constant SW_HW_ALU: std_logic_vector(2 downto 0):= "000";
signal  Input2_selected:std_logic_vector(31 downto 0);
signal Output: std_logic_vector(31 downto 0);
signal input1_selected: std_logic_vector(31 downto 0);
component MUX32
port  (IN1: in std_logic_vector(31 downto 0);
		IN2: in std_logic_vector(31 downto 0);
        SEL: in std_logic;
        OUTPUT: out std_logic_vector(31 downto 0) );
end component;

component MUX5
port  (IN1: in std_logic_vector(4 downto 0);
    IN2: in std_logic_vector(4 downto 0);
        SEL: in std_logic;
        OUTPUT: out std_logic_vector(4 downto 0) );
end component;

 component MUX322
 port (
        in1, in2, in3, in4 : in std_logic_vector(31 downto 0); -- Input data lines
        jump, branch : in std_logic;      -- Select lines
        output : out std_logic_vector(31 downto 0)          -- Output
    );
end component;
begin
     
	Input_select_2 : MUX32 port map (IN1=> Imm_Value, IN2=> Input2, SEL=> Control_EX(5), OUTPUT=>Input2_selected); -- Input2 selectd based  on regdst 
	
	ALUOut <= Output;
	Input1_selected<= Input1;
    process(Input1_selected,Input2_selected,Control_EX(2 downto 0))
    begin
        case(Control_EX(2 downto 0)) is 
			when NORI_ALU =>
				Output<= Input1_selected nor Input2_selected;
			when SRL_ALU =>
				Output <= std_logic_vector(unsigned(Input1_selected) srl to_integer(unsigned(Input2_selected(4 downto 0))));
			when NAND_ALU =>
				Output <= Input1_selected nand Input2_selected;
			when XOR_ALU =>
				Output <= Input1_selected xor Input2_selected;
			when SUBU_ALU =>
				Output <= std_logic_vector(unsigned(Input1_selected) - unsigned(Input2_selected));
			when ADDI_ALU =>
				Output <= std_logic_vector(unsigned(Input1_selected) + unsigned(Input2_selected));
			 when SW_HW_ALU=>
            Output <= std_logic_vector(unsigned(Input1_selected) + unsigned(Input2_selected));  
			when BEQ_ALU =>
				if Input1_selected = Input2_selected then
					Output <= X"00000000";
					zero_condition<='1';
				else 
					zero_condition<='0';
				end if;
			when others =>
				Output <= X"00000000";
        end case;    
    end process;

	
	
    PCSource <= '1' when (Control_EX(3)='1' and zero_condition='1') or Control_EX(4)='1' else '0'; --- branch and jump choose PCsource 1  
	
	Destination_reg_WB: MUX5 port map (IN1=>Des_reg, In2=> Source_reg2, SEL=> Control_EX(6), OUTPUT=> DesR_WB);  -- Destination reg for WB stage
	
	
	in2<= std_logic_vector(unsigned(pc) + unsigned((Imm_Value(29 downto 0) & "00")));
	in3<=(Imm_Value(29 downto 0) & "00");
	
	Brach_adress_cal: MUX322 port map (in1=>(others=>'0'), in2=>in2,in3=>in3,in4=>input1_selected,jump=> Control_EX(4),
										branch=>Control_EX(3), output=>Branch_address);


end rtl;
