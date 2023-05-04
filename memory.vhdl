library ieee;
use std.standard.all;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
entity Memory is 
  port (--init: in std_logic;  
		WE  : in std_logic;
		clock  : in std_logic;   
        Address   : in std_logic_vector(15 downto 0);   
        d_in  : in std_logic_vector(15 downto 0);   
        d_out  : out std_logic_vector(15 downto 0));  
end entity; 

architecture membehave of Memory is 
	type RAM is array(0 to 255) of std_logic_vector(15 downto 0);
	signal storage: RAM :=(5=>"0000000000001110",6=>"0000000000001001",7=>"0000000000001010",8=>"0000000000001111",11=>"1111111111000000",
								 16=>"0000000000010001",17=>"0000000000001000",18=>"0000000000001011",19=>"1111111111111111",others=>(others=>'0'));
	
	begin
	
			
	process(clock,d_in,storage,address)
		begin
			
			--report "dataPointer:"&integer'image(to_integer(unsigned(dataPointer)));
			-- if (init = '1') then
			-- 	storage(0) <= "0000000001010100"; -- LHI R0, 000000100
			-- 	storage(1) <= "0000000001010100"; -- LHI R1, 000000010
			-- 	storage(2) <= "0000000001010100"; -- ADD R2 <- R1+R0
			-- 	storage(3) <= "0000000001010100"; -- ADDI R1 <- 000001+R0
			-- 	storage(4) <= "0000000001010100"; -- SW R2 -> M[R1+000001] 
			-- 	storage(5) <= "0000000001010100"; -- LW R3 <- M[R1+000001]
			-- 	storage(6) <= "0000000001010100"; -- BEQ R2,R3 to PC+000100;				
			-- 	storage(10) <= "0000000001010100"; -- JAL R4, 0...000010;
			-- 	storage(12) <= "0000000001010100"; -- NND R2 <- R1 nand R0
			-- 	storage(13) <= "0000000001010100"; -- OC_TER
				
				
                --change initialization values
			if rising_edge(clock) then
			
				if (WE = '1') then
				--report "memwr:"&integer'image(to_integer(unsigned(dataPointer)));
					storage(to_integer(unsigned(Address))) <= d_in;
					--d_out <= d_in;
				--else
					--d_out <= storage(to_integer(unsigned(Address)));
				
				end if;
				
			end if;
			--d_out<= d_in;
				d_out <= storage(to_integer(unsigned(Address)));
	end process; 
	
	
	end membehave;