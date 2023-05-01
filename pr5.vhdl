library ieee;
use ieee.std_logic_1164.all;

entity pr5 is
    port(clk: in std_logic;
        data_in : in std_logic_vector(15 downto 0); 
        
		rf_write_en : in std_logic;
        dest_reg: in std_logic_vector(2 downto 0);	
        
        pr5_wr_en: in std_logic;
		
		pr5_out: out std_logic_vector(19 downto 0)
    ); 

end entity;

architecture behave of pr5 is 

signal reg_sig : std_logic_vector(19 downto 0);  -- sign_ext control

    
begin 
	process (clk,pr5_wr_en)
    begin
        if rising_edge(clk) then
            if pr5_wr_en = '1' then
                reg_sig(15 downto 0) <= data_in;
				reg_sig(18 downto 16) <= dest_reg;
                reg_sig(19) <= rf_write_en;
            end if;
        end if;
    end process;
    pr5_out <= reg_sig;	 
end behave;