--------------------------------------------------------
---File Name: MIPS.VHDL
--- File description : contains all modules 
--- it contains IF_stage, ID_Stage, Instruction_memory, Data_memory, Data_Forwarding, Hazard_detection, memory stage and etc
-- combine all performing MINI Mips capable of executing these all instructions NORI, SRL, XOR, NANDI, SUBU, ADDI, BEQ, LH, SW, JR and J in pipeline.
-- this is top module file 

library ieee;
use ieee.std_logic_1164.all;

entity MIPS is 
port (clk: in std_logic;
	   rst: in std_logic);
end MIPS;

architecture rtl of MIPS is 


component ADDER
  Port (IN1: in std_logic_vector(31 downto 0);  -- input 1 
		IN2: in std_logic_vector(31 downto 0);  -- input 2
        OUTPUT: out std_logic_vector(31 downto 0) );
end component;


component Instruction_memory
  port(
    Mem_Address     : in std_logic_vector(31 downto 0);   --- Program counter in to read Instruction memory 
    Instruction_out : out std_logic_vector(31 downto 0)   ----  instructoin out from the Instruction memory
  );
 end component;
 
 
 component IF_stage
  Port (clk :in std_logic;
		rst:in std_logic;   -- if asserted then clear all signal 
		clear_pipe: in std_logic;  -- if asserted it means there is hazard and branch taken 
		Branch_taken:in std_logic;  -- Branch taken is asserted means select branch address
		stall:in std_logic;   --  it means there is data hazards
        Branch_Adder:in std_logic_vector(31 downto 0);  -- branch address calculated from EX stage 
		instruction_read: in std_logic_vector(31 downto 0); -- instruction read from instruction memory
        PC:out std_logic_vector(31 downto 0);
		instruction_fetch: out std_logic_vector(31 downto 0));  -- instruction selected if stall selected is zero 
		  
end component;


component ID_Stage
   Port (clk:in std_logic;
		instruction_in: in std_logic_vector(31 downto 0);  --- 32 bit instruction 
        DA_Value,DB_Value,Imm_Value:out std_logic_vector(31 downto 0); -- all values DA, DB and Immdiate value for calc
		RegWrite:in std_logic;                    -- check Regwrite in WB stage
		Branch_stall: in STD_LOGIC;    --- stall pipeline 
		Write_Back: in std_logic_vector(4 downto 0);  -- write back regiter in WB stage 
		WriteB_Value:in std_logic_vector(31 downto 0); --- write back value in wb stage 
		--  Control signal is combined of all stages control signal 
		-- Control signal(10 downto 4) are ex stage signal RegDst& ALUSrc & Jump & Branch & ALU 
		-- control signal (3 downto 2) are for MEM stage (MemRead & MemWrite likewise) and (1 downto 0) for WB stage (MemToReg & RegWrite)
		Control_signal: out std_logic_vector (10 downto 0)
       );
end component;


component Data_Forwarding
 Port (WriteReg_EX: in std_logic_vector(4 downto 0);  -- Instruction I+2 Destination register
		WriteReg_ME: in std_logic_vector(4 downto 0);  -- Instruction I+1 Destination register
		REG_WRITE_EX: in std_logic;  -- RegWrite Control IN EX stage
		REG_WRITE_ME: in std_logic;  -- RegWrite Control IN ME stage
		Data_EX_Aluout,Data_ME_LMD: in std_logic_vector(31 downto 0); --- data output for all different level of instructions for WB, ME, and EX stage
        DA_ID_EX,DB_ID_EX: in std_logic_vector(4 downto 0);  -- Insturction I+3 Sources register 1 and 2 address 
		Data_Value_ID1,Data_Value_ID2: in std_logic_vector(31 downto 0); -- -- Insturction I+3 Sources register 1 and 2 value
        Data_valueA,Data_valueB: out std_logic_vector(31 downto 0) );   -- forward unit will select either value from I,I+1,I+2 or own value
end component;



component Hazard_detection
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
	end component;


component Data_memory
     Port (
        clk       : in  STD_LOGIC;
       -- reset     : in  STD_LOGIC;       
        Write_enable  : in  STD_LOGIC;-- decide whether to perform a write operation 
		MemRead     :  in std_logic;   -- if asserted Memory reading possible 
        Data_write   : in  STD_LOGIC_VECTOR(31 downto 0);    -- Data for store operation
		Data_read : out STD_LOGIC_VECTOR(31 downto 0);   -- data for load operation
        Addr  : in  STD_LOGIC_VECTOR(31 downto 0)  -- load or store address 
       
    );
end component;

 component EX_Stage
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
 end component;

		
		
signal pc: std_logic_vector(31 downto 0);
signal instruction_read,instruction_sel : std_logic_vector(31 downto 0);
signal branch_taken,stall,clear_pipe, branch_stall: std_logic;

--------------------------------------------------------------------------------------------------------------------------
signal IF_ID_BUF : std_logic_vector(63 downto 0);  -- Buffer between IF and ID stage contain instruction and PC
signal Imm_Value_Calc: std_logic_vector(31 downto 0); -- Immdiate value from ID stage 
signal ID_EX_BUF : std_logic_vector(153 downto 0);  -- buffer between Instuction decode  and EXecute stage 
signal ME_WB_BUF : std_logic_vector(134 downto 0);  -- buffer between Instuction Memory  and write back stage 
signal EX_ME_BUF : std_logic_vector(136 downto 0);  --- buffer between Instuction Execute   and Memory stage 


-------------------------------------------------------------------------------------------------------

signal DA_data,DB_data,WriteB_Value: std_logic_vector(31 downto 0);
signal DA,DB: std_logic_vector(31 downto 0);
signal writereg:std_logic_vector (4 downto 0);
signal Data_read: std_logic_vector(31 downto 0);
signal Control_signal: std_logic_vector(10 downto 0);    
signal Clock_En_IF: std_logic;     --- if zero then instruction pass to IF ID buffer 
-------------------------------------------
signal ALU_OUTPUT: std_logic_vector(31 downto 0);
constant clear: std_logic_vector(31 downto 0):= (others=>'0');

signal Branch_Adder_out: std_logic_vector(31 downto 0);

begin 
-- instruction reading 
read_instruction : Instruction_memory port map(Mem_Address=>pc,    --- reading instruction
											Instruction_out=>instruction_read);
											
instruction_fetch_stage: IF_stage port map (clk=> clk,             --- Instruction fetch 
											rst=> rst,
											clear_pipe=>clear_pipe,
											Branch_taken=> branch_taken,
											stall=>stall,
											Branch_Adder=> Branch_Adder_out, 
											instruction_read=>instruction_read,
											pc=>pc,
											instruction_fetch=>instruction_sel);
											

process (clk,rst)
begin
	if rising_edge(clk) then 
		if rst='1' then
		--- if asserted IF ID buffer will be zero 
			IF_ID_BUF<=(others=>'0');
			
		elsif (Clock_En_IF='0') then   ---clock enable is zero then only IF ID buffer can read PC and instruction
			IF_ID_BUF<= PC & instruction_sel;
			-- IF_ID_buf has instructoin as well as Program counter value
		end if;
		
		if rst='1' then   ---all set zero if rst
			ID_EX_BUF<=(others=>'0');  -- Buffer clear ID_EX_BUF
			EX_ME_BUF<=(others=>'0');  -- buffer clear EX_ME_BUF
			ME_WB_BUF<=(others=>'0'); -- buffer clear ME_WB_BUF
			
		else 
		  --- MSB 11 bits are control signals so 154 bits in total for ID_EX buffer 
					   
			---RegDSt 153 & ALUSrc 52 & Jump 51 & Branch 50 & ALU 49,48,47& MemRead 46 & MemWrite 45 & MemToReg 44& RegWrite	43  
			----  DA_Data (111 to 142 ), DB_data (79 to 110 ) and Immdiate value (47 to 78) 
			----   PC (15 to 46)  first 0 to 14 bits for location of Rs,Rt,Rd  
			ID_EX_BUF<= Control_signal 
			           & DA_data & DB_data & Imm_Value_Calc &  IF_ID_BUF (63 downto 32) & IF_ID_BUF(25 downto 21) & IF_ID_BUF(20 downto 16) & IF_ID_BUF(15 downto 11);
			
			----136 bits  MemRead 136 & MemWrite 135 & MemToReg 134& RegWrite 133  control signals
			--- for DB (101 to 132) , output of ALU (69 to 100) , 32 bit immediate value( 37 to 68), PC (36 to 5) and  write reg (4 to 0)
			EX_ME_BUF<= ID_EX_BUF(146 downto 143 ) & DB  & ALU_OUTPUT  & ID_EX_BUF(78 downto 47) 
						& ID_EX_BUF(46 downto 15) & writereg;
	
			
				--  writereg 0 to 4, PC (36 to 5), Immediate value (68 to 37), Output of ALU  (100 to 69), Data_read (101 to 132), controls(133 to 134)			
			ME_WB_BUF<= EX_ME_BUF(134 downto 133) &  Data_read  & EX_ME_BUF(100 downto 69) & 
						EX_ME_BUF(68 downto 37)  & EX_ME_BUF(36 downto 5) & EX_ME_BUF (4 downto 0);

	end if;
end if;
end process;


stall_pipeline: Hazard_detection port map (DESR_ID_EX=>ID_EX_BUF(9 downto 5),  --stall processor 
										SR1_IF_ID=>IF_ID_buf(25 downto 21),    --- create stalls signals for IF and ID stage 
										SR2_IF_ID=>IF_ID_BUF(20 downto 16),  
										branch_taken=>branch_taken,
										MemRead_ID_EX=> ID_EX_BUF(146),
										Branch_stall=>Branch_stall,
										Clock_En_IF_ID=>Clock_En_IF,
										clear_pipe=>clear_pipe,
										stall=>stall);



ID_stage_decode: ID_Stage port map (clk=>clk,
									instruction_in=> IF_ID_BUF(31 downto 0),    ---- instruction decode 
									DA_Value=> DA_data,DB_Value=>DB_data,
									Imm_Value=>Imm_Value_Calc,
									RegWrite=>ME_WB_BUF(133),
									Branch_stall=> branch_stall,
									write_back=>ME_WB_BUF(4 downto 0), 
									WriteB_Value=> WriteB_Value,
									Control_signal=>Control_signal );	


Forwarding_Data: Data_Forwarding port map(WriteReg_EX =>EX_ME_BUF(4 downto 0),    ---data forwarding in case of data hazards check destination resigter with source register all stages 
										WriteReg_ME=> ME_WB_BUF(4 downto 0),    -- forwarding is detected then data is forwarded
										REG_WRITE_EX=>EX_ME_BUF(133), 
										REG_WRITE_ME=> ME_WB_BUF(133),
										Data_EX_Aluout=> EX_ME_BUF(100 downto 69),
										Data_ME_LMD=>WriteB_Value,
									    DA_ID_EX=> ID_EX_BUF(14 downto 10),DB_ID_EX=> ID_EX_BUF(9 downto 5),
										Data_Value_ID1=> ID_EX_BUF(142 downto 111),
										Data_Value_ID2=>ID_EX_BUF(110 downto 79),
										Data_valueA=>DA,Data_valueB =>DB);	

Execute_stage: EX_Stage port map(Control_EX=>ID_EX_BUF(153 downto 147),            --- execute stage
								PC=>ID_EX_BUF(46 downto 15),
								Source_reg2=>ID_EX_BUF(9 downto 5),
								Des_reg=>ID_EX_BUF(4 downto 0),
								Input1=>DA,Input2=>DB,
								IMM_Value=> ID_EX_BUF(78 downto 47),
							     PCSource=>branch_taken, 
								 DesR_WB=>writereg, 
								 Branch_address=>Branch_Adder_out,
								 ALUOut=> ALU_OUTPUT);
								  
Memory_stage: Data_memory port map(clk=>clk,                                    --memory stage 
								Write_enable=>EX_ME_BUF(135),
								MemRead=>EX_ME_BUF(136), 
								Data_write=>EX_ME_BUF(132 downto 101),
								Data_read=>Data_read,
								Addr=>EX_ME_BUF(100 downto 69) );
								
WriteB_Value<= ME_WB_BUF(100 downto 69) when ME_WB_BUF(134)='0' else ((31 downto 16=>ME_WB_BUF(116)) & ME_WB_BUF(116 downto 101));  --- write back stage
	
end rtl;