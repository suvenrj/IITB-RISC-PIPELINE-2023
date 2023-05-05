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
	signal storage: RAM := ( 
							  0=>"0110101011111111",
							  1=>"0111110011101010", --i2
							  2=>"0001000110111000", --i3
							  3=>"0111101011101011", --i4
							 64=>"1111100010000000", --i5
							 65=>"0010101011111000",
							 66=>"0010101011111000",
							 67=>"0010101011111000",
							 68=>"0010101011111000",
							206=>"0011101000000110", --i6
							138=>"0011101000000110",
							139=>"0100101100000001",
							140=>"0010111101001100",
							141=>"0001011111001111",
							142=>"1001010011011110",
							143=>"0011010000000001",
									--144=>"0110000010011010",
									
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