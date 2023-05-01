library ieee;
use ieee.std_logic_1164.all;

entity Decoder2 is
    port(OPCODE : in std_logic_vector(3 downto 0); 
         C_alu,Z_alu: in std_logic;
         M7_control,M8_control,M9_control: out std_logic);          
end entity;

architecture behave_dec2 of Decoder2 is 
	
signal A,B,C,D,E,F,A1,B1,C1,D1,E1,F1: std_logic;  -- sign_ext control

    
begin 
	A <= OPCODE(3);
	B <= OPCODE(2);
	C <= OPCODE(1);
	D <= OPCODE(0);
    E <= C_alu;
    F <= z_alu;
	A1 <= not OPCODE(3);
	B1 <= not OPCODE(2);
	C1 <= not OPCODE(1);
	D1 <= not OPCODE(0);
	E1 <= not C_alu;
    F1 <= not z_alu;
	
	M7_control <= (A and B and D1) or (A and C1 and D1 and F) or (A and B1 and E and F) or (A and B1 and D and E) or (A and B1 and C and F1 );
	M8_control <= (A and B and D1) or (A and C1 and D1 and F) or (A and B1 and E and F) or (A and B1 and D and E) or (A and B1 and C and F1 );
    M9_control <= (A1) or (B1 and D and E1) or (B1 and C and D) or (B1 and C1 and D1 and F1) or (B1 and C and E1 and F);
end architecture;
