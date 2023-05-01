library ieee;
use ieee.std_logic_1164.all;

-- Sign extender with two inputs, first for SE6, and other for SE9

-- Control
-- 0 -**SE-6**
-- 1 -**SE-9**
-- Control=A'C + AB

entity sign_ext is
	port (
		input_6: in std_logic_vector(5 downto 0);
		input_9: in std_logic_vector(8 downto 0);
		control: in std_logic;		

		se_out: out std_logic_vector(15 downto 0)) ;
end sign_ext;

architecture internal of sign_ext is
	
function SE_6(input_6: in std_logic_vector(5 downto 0))
return std_logic_vector is
	variable se_6_out : std_logic_vector(15 downto 0):= (others=>'0');
begin
	L00 :for i in 0 to 5 loop
		se_6_out(i) := input_6(i);
	end loop L00;
	L01 : for i in 6 to 15 loop
		se_6_out(i) := se_6_out(i-1);
	end loop L01;
	return se_6_out;
end SE_6;

function SE_9(input_9: in std_logic_vector(8 downto 0))
return std_logic_vector is
	variable se_9_out : std_logic_vector(15 downto 0):= (others=>'0');
begin
	L10 :for i in 0 to 8 loop
		se_9_out(i) := input_9(i);
	end loop L10;
	L11 : for i in 9 to 15 loop
		se_9_out(i) := se_9_out(i-1);
	end loop L11;
	return se_9_out;
end SE_9;

begin
	P1 : process( input_6,input_9,control)
		begin
			if control = '0' then
				se_out <= SE_6(input_6);
			else 
				se_out <= SE_9(input_9);
			end if;
	end process P1;
end internal ;
