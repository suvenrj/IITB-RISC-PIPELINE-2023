library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity adder_3bit is
    Port ( a : in  std_logic_vector(2 downto 0);
           b : in  std_logic_vector(2 downto 0);
           cin : in std_logic;
           sum : out std_logic_vector(2 downto 0));
end entity;

architecture Behavioral of adder_3bit is
signal carry_over , sum_sig: std_logic_vector(2 downto 0):=(others => '0');


begin
    process(a,b,cin,carry_over,sum_sig)
    begin
		  carry_over <=(others => '0');
		  sum_sig<=(others => '0');

            sum_sig(0) <= a(0) xor b(0) xor Cin;
            carry_over(0) <= (a(0) and b(0)) or (a(0) and Cin) or (b(0) and Cin);
    
            loop1: for i in 1 to 2 loop
                sum_sig(i) <= a(i) xor b(i) xor carry_over(i-1);
                carry_over(i) <= (a(i) and b(i)) or (a(i) and carry_over(i-1)) or (b(i) and carry_over(i-1));
            end loop loop1;

	end process;
	sum <= sum_sig;
		  
end architecture;
