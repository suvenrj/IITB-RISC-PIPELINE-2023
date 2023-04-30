library ieee;
use ieee.std_logic_1164.all;
entity mux2x1 is
	port(I1: in std_logic_vector(2 downto 0);
	     I2: in std_logic_vector(2 downto 0);
		 S0: in std_logic;
		I_out:out std_logic_vector(2 downto 0));
end entity;

architecture behavioral of mux2x1 is
	begin
		process (S0, I1, I2)
		begin
			if S0 = '0' then
				I_out <= I1;
			else
				I_out <= I2;
			end if;
		end process;
end architecture;