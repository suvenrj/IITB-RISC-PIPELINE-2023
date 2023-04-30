library ieee;
use ieee.std_logic_1164.all;

entity alu_pc_2 is 
    port(alu_pc : in std_logic_vector(15 downto 0); alu_const_in: in std_logic_vector(15 downto 0); out_pc : out std_logic_vector(15 downto 0));
end entity alu_pc_2;

architecture behave of alu_pc_2 is
    function add(alu_pc_2, alu_const: in std_logic_vector(15 downto 0))
        return std_logic_vector is
            variable out_add: std_logic_vector(15 downto 0);
            variable carry: std_logic := '0';
        begin
            for j in 0 to 15 loop 
                out_add(j) := alu_pc_2(j) xor alu_const(j) xor carry;
                carry := (((alu_pc_2(j) xor alu_const(j)) and carry) or (alu_pc_2(j) and alu_const(j)));
            end loop;
        return out_add;
    end add;
begin
    proc1: process(alu_pc, alu_const_in)
    begin
        out_pc <= add(alu_pc,alu_const_in);
    end process;
end behave ; 