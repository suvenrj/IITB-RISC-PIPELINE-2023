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
	type RAM is array(0 to ((65536)-1)) of std_logic_vector(15 downto 0);
	signal storage: RAM;
	begin
	process(dataPointer)
		begin 
			--report "dataPointer:"&integer'image(to_integer(unsigned(dataPointer)));
			-- if (init = '1') then
			-- 	storage(0) <= "0011000000000100"; -- LHI R0, 000000100
			-- 	storage(1) <= "0011001000000010"; -- LHI R1, 000000010
			-- 	storage(2) <= "0001000001010000"; -- ADD R2 <- R1+R0
			-- 	storage(3) <= "0000000001000001"; -- ADDI R1 <- 000001+R0
			-- 	storage(4) <= "0111010001000001"; -- SW R2 -> M[R1+000001] 
			-- 	storage(5) <= "0101011001000001"; -- LW R3 <- M[R1+000001]
			-- 	storage(6) <= "1000010011000100"; -- BEQ R2,R3 to PC+000100;				
			-- 	storage(10) <= "1001100000000010"; -- JAL R4, 0...000010;
			-- 	storage(12) <= "0010000001010000"; -- NND R2 <- R1 nand R0
			-- 	storage(13) <= "0100000001010000"; -- OC_TER
            --     --change initialization values
			-- end if;
            do <= storage(to_integer(unsigned(dataPointer)));
	end process; 
	end membehave;