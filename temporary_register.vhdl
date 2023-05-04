library ieee;
use ieee.std_logic_1164.all;

entity temporary_register is
    port (input  : in  std_logic_vector(15 downto 0);
          enable : in  std_logic;
          output : out std_logic_vector(15 downto 0));
end entity temporary_register;

architecture bhv_tmp of temporary_register is
    signal temp : std_logic_vector(15 downto 0):=(others=>'0');
begin
    process(input, enable,temp)
    begin
	 if enable = '1'  then
        
            temp <= input;
		 
		else 
			temp <= temp;
		end if;
		
		  
    end process;
    output <= temp;
end architecture bhv_tmp;