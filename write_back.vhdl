library ieee;
use ieee.std_logic_1164.all;

entity write_back is
    port( 
    reg_write_en_out: out std_logic;
    data_out: out std_logic_vector(15 downto 0); 
    dest_reg_out: out std_logic_vector(2 downto 0);
    cy_for_exec, z_for_exec:out std_logic;
    pr5_out : in std_logic_vector(21 downto 0)
);
end entity;

architecture arch of write_back is
begin
    dest_reg_out <= pr5_out(18 downto 16);
    reg_write_en_out <= pr5_out(19);
    data_out <= pr5_out(15 downto 0);
    cy_for_exec<=pr5_out(20);
    z_for_exec<=pr5_out(21);
end arch ; -- arch
