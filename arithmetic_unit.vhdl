library ieee;
use ieee.std_logic_1164.all;

entity arithmetic_unit is
	port(
		A, B: in std_logic_vector(15 downto 0);
		C2:in std_logic;
		Cy:in std_logic;
		C: out std_logic_vector(15 downto 0);
		new_cy: out std_logic;
		new_zero: out std_logic
	);
end entity;


architecture bhv of arithmetic_unit is

signal carry_over , Out_sig: std_logic_vector(15 downto 0);


begin
    process(A,B,C2,Cy)
    begin
        if (C2='0') then

            Out_sig(0) <= a(0) xor b(0) xor Cy;
            carry_over(0) <= (a(0) and b(0)) or (a(0) and Cy) or (b(0) and Cy);
    
            loop1: for i in 1 to 15 loop
                Out_sig(i) <= a(i) xor b(i) xor carry_over(i-1);
                carry_over(i) <= (a(i) and b(i)) or (a(i) and carry_over(i-1)) or (b(i) and carry_over(i-1));
            end loop loop1;
            
            new_cy <= carry_over(15);
            
        else 
            
            loop2: for j in 1 to 15 loop
                Out_sig(j) <= a(j) NAND b(j) ;
                
            end loop loop2;
        end if;
        if Out_sig ="0000000000000000" then
            new_zero <= '1';
        else 
            new_zero <= '0';
        end if;
    end process;
    C <= Out_sig;
end architecture;