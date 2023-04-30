library ieee;
use ieee.std_logic_1164.all;

entity pc_register is
    port (pc_in: in std_logic_vector(15 downto 0); pc_out : out std_logic_vector(15 downto 0); clock: in std_logic);
end entity;

architecture behave of pc_register is 
    begin 
        proc: process(clock, pc_in)
            begin 
                if (falling_edge(clock)) then
                    pc_out <= pc_in;
                
                end if;
        end process;
end behave;