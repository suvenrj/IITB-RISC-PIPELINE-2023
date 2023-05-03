library ieee;
use ieee.std_logic_1164.all;


entity modder is
	port (
		input: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0)) ;
end modder;

architecture internal of modder is
	
function modular(input: in std_logic_vector(15 downto 0))
return std_logic_vector is
	variable op_vector : std_logic_vector(15 downto 0):= (others=>'0');
begin
	op_vector := input and "0000000011111111";
	return op_vector;
end modular;


begin
	P1 : process( input)
		begin
			output <= modular(input);
		end process P1;
end internal ;
