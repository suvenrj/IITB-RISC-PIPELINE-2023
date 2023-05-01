library ieee;
use ieee.std_logic_1164.all;

entity write_back is
    port(data_in, pc_next: in std_logic_vector(15 downto 0); 
    dest_reg_in: in std_logic_vector(2 downto 0); 
    reg_write_en_in: in std_logic; 
    reg_write_en_out: out std_logic;
    data_out: out std_logic_vector(15 downto 0); 
    dest_reg_out: out std_logic_vector(2 downto 0); 
    opcode: in std_logic_vector(3 downto 0));
end entity;

architecture arch of write_back is
begin
    dest_reg_out <= dest_reg_in;
    reg_write_en_out <= reg_write_en_in;
    proc1: process (data_in, pc_next) 
    begin
        if (opcode = "1100" or opcode = "1101") then  -- JAL, JLR
            data_out <= pc_next;
        else
            data_out <= data_in;
        end if;
    end process;
end arch ; -- arch