library ieee;
use ieee.std_logic_1164.all;

entity pr1 is
    port(Instr : in std_logic_vector(15 downto 0); 
			pr1_wr_en: in std_logic;
			clk: in std_logic;
	 		reset_asynch: in std_logic;
			pr1_out: out std_logic_vector(15 downto 0);
			reset_synch: in std_logic); 
end entity;

architecture behave of pr1 is 

signal reg_sig : std_logic_vector(15 downto 0) :=(others => '0');  -- sign_ext control

    
begin 
process (clk,pr1_wr_en, reset_asynch,reset_synch,reg_sig)
    begin
	if reset_asynch = '0' then
		if rising_edge(clk) then
			if reset_synch = '0' then
				if pr1_wr_en = '1' then
					reg_sig <= instr;
				else
				reg_sig <= reg_sig ;
				end if;
			else 
				reg_sig <= (others => '0');
			end if;
		else
			reg_sig <= reg_sig;
		end if;
	else
		reg_sig <= (others => '0');
	end if;
end process;
pr1_out <= reg_sig;	 
end behave;
