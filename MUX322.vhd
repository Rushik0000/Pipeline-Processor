--- File name: MUX32.VHDL 
---  File description: select either input 1 or input 2

library ieee;
use ieee.std_logic_1164.all;

entity Mux322 is
    port (
        In1, In2, In3, In4 : in std_logic_vector(31 downto 0); -- Input data lines
        jump, branch : in std_logic;      -- Select lines
        output : out std_logic_vector(31 downto 0)          -- Output
    );
end entity Mux322;

architecture rtl of Mux322 is
begin
    process(jump, branch, In1, In2, In3, In4)
    begin
        if jump = '0' and branch = '0' then
            Output <= In1;
        elsif jump = '0' and branch = '1' then
            Output <= In2;
        elsif jump = '1' and branch = '0' then
            Output <= In3;
        else
            Output <= In4;
        end if;
    end process;
end architecture rtl;

