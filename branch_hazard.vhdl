library ieee;
use ieee.std_logic_1164.all;

entity branch_hazard_detector is
    port(opcode: in std_logic_vector(3 downto 0);
         c_in,z_in: in std_logic;
         branch_haz: out std_logic);
end entity;

architecture bhv_br of branch_hazard_detector is

begin
    pp2 : process(opcode,c_in,z_in)
    begin 
        if opcode ="1000" and z_in='1' then
            branch_haz <= '1';
        elsif opcode = "1001" and c_in='1' then
            branch_haz <= '1';
        elsif opcode = "1010" and (c_in = '1' or z_in ='1') then
            branch_haz <= '1';
        elsif opcode ="1100" or opcode="1101" or opcode= "1111" then
            branch_haz <= '1';
        else
            branch_haz <= '0';
        end if;
    end process;
end architecture;
            
