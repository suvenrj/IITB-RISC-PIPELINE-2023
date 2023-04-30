
--- CONTROL FOR ALU (4 bits): ADD/NAND , SUB/DON'T SUB, WITH/WITHOUT CARRY, COMPLEMENT/NOT COMPLEMENT 
--                              0           1                2                       3

library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port(ALU_A,ALU_B: in std_logic_vector(15 downto 0);control: in std_logic_vector(3 downto 0); c_in: in std_logic;
		c_out,zero: out std_logic;ALU_C: out std_logic_vector(15 downto 0));
end entity ALU;

architecture behave of ALU is

function add(ALU_A,ALU_B: in std_logic_vector(15 downto 0);control: in std_logic_vector(3 downto 0); c_in: in std_logic)
	return std_logic_vector  is
	variable output_add : std_logic_vector(17 downto 0);
	variable carry: std_logic := c_in and control(2);  
    variable input_2: std_logic_vector(15 downto 0);
   
begin
	if (control(3)='1') then      -- complement of ALU_B if complement control bit is 1
		input_2 := not ALU_B;
	else
		input_2 := ALU_B;
	end if;
	for j in 0 to 15 loop
		output_add(j) := ((ALU_A(j) xor input_2(j)) xor carry);			
		carry := (((ALU_A(j) xor input_2(j)) and carry) or (ALU_A(j) and input_2(j)));
	end loop;
	output_add(16):=carry;
	if( output_add(16 downto 0) = "00000000000000000") then
		output_add(17) := '1';
	else 
		output_add(17) :='0';
	end if;
	return output_add;
end add;


function sub(ALU_A,ALU_B: in std_logic_vector(15 downto 0))
	return std_logic_vector  is
	variable output_diff : std_logic_vector(17 downto 0);
	variable carry: std_logic := '1';  
    variable input_2: std_logic_vector(15 downto 0);
   
begin     -- complement of ALU_B if complement control bit is 1
	input_2 := not ALU_B;
	for j in 0 to 15 loop
		output_diff(j) := ((ALU_A(j) xor input_2(j)) xor carry);			
		carry := (((ALU_A(j) xor input_2(j)) and carry) or (ALU_A(j) and input_2(j)));
	end loop;
	output_diff(16):=carry;
	if( output_diff(16 downto 0) = "00000000000000000") then
		output_diff(17) := '1';
	else 
		output_diff(17) :='0';
	end if;
	return output_diff;
end sub;


function nan(ALU_A,ALU_B: in std_logic_vector(15 downto 0);control: in std_logic_vector(2 downto 0))
	return std_logic_vector  is
	variable output_nan : std_logic_vector(17 downto 0);
    variable input_2: std_logic_vector(15 downto 0);
        
begin
	if (control(3)='1') then      -- complement of ALU_B if complement control bit is 1
		input_2 := not ALU_B;
	else
		input_2 := ALU_B;
	end if;
	for j in 0 to 15 loop
		output_nan(j) := (ALU_A(j) nand input_2(j));
	end loop;
	if(output_nan= "000000000000000000") then
		output_nan(17) := '1';
	else 
		output_nan(17) :='0';
	end if;
	output_nan(16) :='0';
	return output_nan;
end nan;


signal arb:std_logic_vector(17 downto 0);	
	
begin

proc1 : process(control,ALU_A,ALU_B,arb)
begin 
	if (control(1)='0') then
		case control(0) is
			when '0' =>
				arb<=add(ALU_A,ALU_B, control, c_in);
			when '1' =>
				arb<=nan(ALU_A,ALU_B,control);
			when others =>
				arb<=add(ALU_A,ALU_B,control,c_in);	
		end case;
	else
		arb <= sub(ALU_A, ALU_B);
	end if;
	ALU_C<=arb(15 downto 0);
	c_out<=arb(16);
	zero<=arb(17);
end process;
end architecture behave;



		
