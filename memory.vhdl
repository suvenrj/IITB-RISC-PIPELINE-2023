library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all; 
library ieee;
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
	type RAM is array(0 to 14) of std_logic_vector(15 downto 0);
	signal storage: RAM;
	begin
	process(WE,Address,storage,clock)
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
				
--				storage(0) <= "0011000000000100"; -- LHI R0, 000000100
--				storage(1) <= "0011001000000010"; -- LHI R1, 000000010
--				storage(2) <= "0001000001010000"; -- ADD R2 <- R1+R0
--				storage(3) <= "0000000001000001"; -- ADDI R1 <- 000001+R0
--				storage(4) <= "0111010001000001"; -- SW R2 -> M[R1+000001] 
--				storage(5) <= "0101011001000001"; -- LW R3 <- M[R1+000001]
--				storage(6) <= "1000010011000100"; -- BEQ R2,R3 to PC+000100;				
--				storage(10) <= "1001100000000010"; -- JAL R4, 0...000010;
--				storage(12) <= "0010000001010000"; -- NND R2 <- R1 nand R0
--				storage(13) <= "0100000001010000"; -- OC_TER
                --change initialization values
				d_out <= storage(to_integer(unsigned(Address)));
			if (WE = '1') then
				--report "memwr:"&integer'image(to_integer(unsigned(dataPointer)));
				storage(to_integer(unsigned(Address))) <= d_in;
			end if;
	end process; 
	end membehave;