library ieee;
use ieee.std_logic_1164.all;

entity pr5 is
    port(data_in : in std_logic_vector(15 downto 0); 
        pc_next: in std_logic_vector(15 downto 0);				-- if Instruction at PC is at ID stage then PC_next is PC+2
		reg_write_en : in std_logic;
        dest_reg: in std_logic_vector(2 downto 0);	
        
        pr5_wr_en: in std_logic;
		clk: in std_logic;
		pr5_out: out std_logic_vector(35 downto 0)
    ); 

end entity;

architecture behave of pr5 is 

signal reg_sig : std_logic_vector(35 downto 0);  -- sign_ext control

    
begin 
	process (clk)
    begin
        if rising_edge(clk) then
            if pr5_wr_en = '1' then
                reg_sig(15 downto 0) <= data_in;
				reg_sig(31 downto 16) <= pc_next;
                reg_sig(32 downto 32) <= reg_write_en;
                reg_sig(35 downto 33) <= dest_reg;
            end if;
        end if;
    end process;
    pr5_out <= reg_sig;	 
end behave;