library ieee;
use ieee.std_logic_1164.all;

entity pr5 is
	port(clk: in std_logic;
		data_in : in std_logic_vector(15 downto 0); 
		
		rf_write_en : in std_logic;
		dest_reg: in std_logic_vector(2 downto 0);	
		
		pr5_wr_en: in std_logic;
		reset: in std_logic;
		pr5_out: out std_logic_vector(21 downto 0);
		cy_to_wb,z_to_wb: in std_logic
	); 
end entity;

architecture behave of pr5 is 

signal reg_sig : std_logic_vector(21 downto 0):=(others => '0');  -- sign_ext control

    
begin 
	process (clk,pr5_wr_en,reg_sig,reset)
    begin
	if reset = '0' then
		if rising_edge(clk) then
		    if pr5_wr_en = '1' then
				reg_sig(15 downto 0) <= data_in;
				reg_sig(18 downto 16) <= dest_reg;
				reg_sig(19) <= rf_write_en;
				reg_sig(20)<=cy_to_wb;
				reg_sig(21)<=z_to_wb;
			else
				reg_sig <= reg_sig;
		    end if;
		else
			reg_sig <= reg_sig;
		end if;
	else
		reg_sig <= (others => '0');
	end if;
    end process;
    pr5_out <= reg_sig;	 
end behave;
