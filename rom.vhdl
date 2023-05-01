library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all; 
library ieee;
use ieee.numeric_std.all; 
entity rom is 
  port (--init: in std_logic;     
        dataPointer   : in std_logic_vector(15 downto 0);      
        do  : out std_logic_vector(15 downto 0));  
end entity; 

architecture membehave of rom is 
	type RAM is array(0 to ((65536)-1)) of std_logic_vector(15 downto 0) ;
	signal storage: RAM := (others=>(others=>'0')) ;
	begin
	process(dataPointer,storage)
		begin 	-- three arbitary instruction at three locations
					storage(1) <= "0011000000001100"; 
					storage(2) <= "0100010000000000"; 
					storage(5) <= "1111101111110001";
					
					-- if warning comes 'Warning : Pin "instruction_out[x]" is stuck at GND' then it means that ,for all y, storage(y)(x) is '0'. Similarly for VCC for '1'.
					-- Actually this happens if instruction are set in that manner, but computer doesnt understand its intentional and not logical error.
            do <= storage(to_integer(unsigned(dataPointer)));
	end process; 
	end membehave;