library ieee;
use ieee.std_logic_1164.all;
entity full_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           sum : out STD_LOGIC;
           carry_out : out STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is
begin
    sum <= a xor b xor c;
    carry_out <= (a and b) or (b and c) or (a and c);
end Behavioral;

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

signal carry_over , Out_sig: std_logic_vector(15 downto 0):=(others => '0');


begin
    process(A,B,C2,Cy,carry_over,Out_sig)
    begin
        new_cy<='0';
		  carry_over <=(others => '0');
		  Out_sig<=(others => '0');
		  case C2 is
            
            when '1' =>
            loop2: for j in 0 to 15 loop
                Out_sig(j) <= a(j) NAND b(j) ;
                
            end loop loop2;
            when others =>
            Out_sig(0) <= a(0) xor b(0) xor Cy;
            carry_over(0) <= (a(0) and b(0)) or (a(0) and Cy) or (b(0) and Cy);
    
            loop1: for i in 1 to 15 loop
                Out_sig(i) <= a(i) xor b(i) xor carry_over(i-1);
                carry_over(i) <= (a(i) and b(i)) or (a(i) and carry_over(i-1)) or (b(i) and carry_over(i-1));
            end loop loop1;
            
            new_cy <= carry_over(15) xor Cy;
        end case;
		  
		  case Out_sig is
				when "0000000000000000" =>
					new_zero <= '1';
				when others =>
					new_zero <= '0';
			end case;
            
            
    end process;
    
    C <= Out_sig;
end architecture;