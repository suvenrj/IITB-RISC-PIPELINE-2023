library ieee;
use ieee.std_logic_1164.all;

entity pr2 is
    port(decoder_out : in std_logic_vector(39 downto 0); 
        pc_next: in std_logic_vector(15 downto 0);				-- if Instruction at PC is at ID stage then PC_next is PC+2
		pr2_wr_en: in std_logic;
		clk: in std_logic;
		pr2_out: out std_logic_vector(55 downto 0);
		reset_asynch,reset_synch: in std_logic); 
end entity;

architecture behave of pr2 is 

signal reg_sig : std_logic_vector(55 downto 0):=(others => '0');  -- sign_ext control

    
begin 
process (clk, reset_synch,reset_asynch)
    begin
	if reset_asynch = '0' then
		if rising_edge(clk) then
			if reset_synch = '0'then
				if pr2_wr_en = '1' then
					reg_sig(39 downto 0) <= decoder_out;
					reg_sig(55 downto 40) <= pc_next;
				else 
					reg_sig <= reg_sig;
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
pr2_out <= reg_sig;	 
end behave;
