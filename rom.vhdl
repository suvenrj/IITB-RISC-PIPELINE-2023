library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
entity rom is 
  port (--init: in std_logic;
			clk : in std_logic;
        dataPointer   : in std_logic_vector(15 downto 0);      
        do  : out std_logic_vector(15 downto 0));  
end entity; 

architecture membehave of rom is 
	type RAM is array(0 to ((65536)-1)) of std_logic_vector(15 downto 0) ;
	signal storage: RAM := (0=>"1111101111110001",
									4=>"0000001000000010", --i1
									5=>"0000010000000100", --i2
									6=>"0000100000001000", --i3
									7=>"0001000000010000", --i4
									8=>"0010000000100000", --i5
									10=>"1110100000110000", --i6
									others=>(others=>'0'));
	signal data : std_logic_vector(15 downto 0) := (others => '0');
	begin
	
	process(data,storage,dataPointer)
	
		begin 	-- three arbitary instruction at three locations
		
		--if rising_edge(clk) then	
					
					-- if warning comes 'Warning : Pin "instruction_out[x]" is stuck at GND' then it means that ,for all y, storage(y)(x) is '0'. Similarly for VCC for '1'.
					-- Actually this happens if instruction are set in that manner, but computer doesnt understand its intentional and not logical error.
            data <= storage(to_integer(unsigned(dataPointer)));
		--else
			--data <= data;
		--end if;
	do <=data;
	end process;
	end membehave;