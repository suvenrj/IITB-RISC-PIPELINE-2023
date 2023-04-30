library ieee;
use ieee.std_logic_1164.all;

entity pr2 is
    port(decoder_out : in std_logic_vector(39 downto 0); 
         pc_next: in std_logic_vector(15 downto 0);				-- if Instruction at PC is at ID stage then PC_next is PC+2
			pr2_wr_en: in std_logic;
			clk: in std_logic;
			enable : in std_logic;
			pr2_out: out std_logic_vector(55 downto 0)); 

end entity;

architecture behave of pr2 is 

signal reg_sig : std_logic_vector(55 downto 0);  -- sign_ext control

    
begin 
	process (clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                reg_sig(39 downto 0) <= decoder_out;
				reg_sig(55 downto 40) <= pc_next;
            end if;
        end if;
    end process;
    pr2_out <= reg_sig;	 
end behave;
