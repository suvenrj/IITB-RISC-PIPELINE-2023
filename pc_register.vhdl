library ieee;
use ieee.std_logic_1164.all;

entity pc_register is
    port (pc_in: in std_logic_vector(15 downto 0); pc_out : out std_logic_vector(15 downto 0); clock: in std_logic; pc_write_en: in std_logic);
end entity;

architecture behave of pc_register is 
    signal pc_val;
    begin 
        pc_out <= pc_val;
        proc: process(clock, pc_in, pc_write_en)
            begin 
                if (rising_edge(clock)) then
                    if (pc_write_en='1') then
                        pc_val <= pc_in;
                    else
                        pc_val <= pc_val;
                    end if;
                else
                    pc_val <= pc_val;
                end if;
        end process;
end behave;
