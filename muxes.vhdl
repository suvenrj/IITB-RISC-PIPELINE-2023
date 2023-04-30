library ieee;
use ieee.std_logic_1164.all;
entity mux2x1 is
	port(I0: in std_logic_vector(2 downto 0);
	     I1: in std_logic_vector(2 downto 0);
		 S0: in std_logic;
		I_out:out std_logic_vector(2 downto 0));
end entity;

architecture behavioral of mux2x1 is
	begin
		process (S0, I0, I1)
		begin
			if S0 = '0' then
				I_out <= I0;
			else
				I_out <= I1;
			end if;
		end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity mux4x1 is
    Port ( I00 : in  STD_LOGIC_VECTOR (2 downto 0);
			I01 : in  STD_LOGIC_VECTOR (2 downto 0);
			I10: in  STD_LOGIC_VECTOR (2 downto 0);
			I11:in  STD_LOGIC_VECTOR (2 downto 0);
		   S0, S1 : in std_logic;
           I_out : out  STD_LOGIC_VECTOR(2 downto 0));
end mux4x1;

architecture Behavioral of mux4x1 is
begin
    process (I00,I01,I10,I11, S0,S1)
    begin
        if (S1 = '0' and S0 = '0') then
                I_out <= I00;
		elsif (S1 = '0' and S0 = '1') then
            I_out <= I01;
		elsif (S1 = '1' and S0 = '0') then
			I_out <= I10;
		else  
			I_out <= I11;
        end if;
    end process;
end Behavioral;