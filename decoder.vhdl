library ieee;
use ieee.std_logic_1164.all;

entity Decoder is
    port(pr1 : in std_logic_vector(15 downto 0);
			rf_write_lm : in std_logic;
         D_out: out std_logic_vector(39 downto 0);
			ori_op : in std_logic_vector(3 downto 0)); --original opcode
end entity;





architecture behave of Decoder is 

component mux2x1 is
	port(I0: in std_logic_vector(2 downto 0);
	     I1: in std_logic_vector(2 downto 0);
		 S0: in std_logic;
		I_out:out std_logic_vector(2 downto 0));
end component;

component mux4x1 is
    Port ( I00 : in  STD_LOGIC_VECTOR (2 downto 0);
			I01 : in  STD_LOGIC_VECTOR (2 downto 0);
			I10: in  STD_LOGIC_VECTOR (2 downto 0);
			I11:in  STD_LOGIC_VECTOR (2 downto 0);
		   S0, S1 : in std_logic;
           I_out : out  STD_LOGIC_VECTOR(2 downto 0));
end component;
	

signal A,B,C,D,Co,Cy,Z,A1,B1,C1,D1,Cy1,Z1,zero,m11,m22: std_logic;  -- sign_ext control

    
begin 
	A <= pr1(15);
	B <= pr1(14);
	C <= pr1(13);
	D <= pr1(12);
	Co <= pr1(2);
	Cy <= pr1(1);
	Z <= pr1(0);
	A1 <= not pr1(15);
	B1 <= not pr1(14);
	C1 <= not pr1(13);
	D1 <= not pr1(12);
	--Co1 <= not pr1(2); -- never used
	Cy1 <= not pr1(1);
	Z1 <= not pr1(0);
	
	
	
   D_out(8 downto 0) <= pr1(8 downto 0);			--Storing same IMM
	D_out(39 downto 36) <= pr1(15 downto 12);		--Storing OPCODE
	D_out(11 downto 9) <= pr1(11 downto 9);			--Stroing Destination address
	--D_out()<= pr1()
	D_out(18) <= ((A1 and  B1) or (A1 and  D1) or (A and  C1 and B))  and (rf_write_lm or (not(not(ori_op(3)) and ori_op(2) and ori_op(1)))); --Register File write enable
	D_out(19) <= (A1 and  B and D) and rf_write_lm  ; 				--Data Memory write enable
	D_out(20) <= (A1 and B1 and C1); 				-- C flag Write enable
	D_out(21) <= (not(not(ori_op(0))and(ori_op(1)) and(ori_op(2)) and not(ori_op(3))))
						and ((A1 and B1 and C1) or (A1 and B1 and D1) or (A1 and C1 and D1));		-- Z flag enable
	D_out(22) <= pr1(2);								-- Compliment bit	*Not used further yet*
	D_out(23) <= (A and B1);							-- ALU(C0)
	D_out(24) <= not(A or B) and (not(C or D1)) and (Cy and Z);						-- ALU(C1)
	D_out(25) <= not(A or B) and (C and D1);			--ALU(C2)
	D_out(26) <= (A1 and C)	or (A and B);			--SE control
	D_out(27) <=  Z;				--M1_C0
	D_out(28) <= (B1) and (A1) and (C or D) and (Cy or Z) and (Cy1 or Z1) and (C1 or D1);		-- M1_C1
	D_out(29) <= ((A1 and B) or (C and D) or (A1 and C1 and D1));									-- M2
	D_out(30) <= A1 and pr1(8);				--M4-C0  -- pr(8) 9th bit in inst; MSB in IMM9
	D_out(31) <= (D1) or (A1 and C1) or (A and B1) or (B and C);				--M4-C1
	D_out(32) <= A;						-- M5-C0
	D_out(33) <= B; 						--M5-C1
	D_out(34) <= (A and B1) or (B1 and C1 and D and Co) or (B1 and C and D1 and Co); 			--M6
	D_out(35) <= not(not(A and B) or C or D1) ;		--M14
	
	
	
	m11<=A1 and (C1 or B1);
	m22<=A1 and B and C1 and D;
	m1: mux2x1 
	port map(
		pr1(11 downto 9),
		pr1(8 downto 6),
		m11,
		D_out(14 downto 12)
	);
	m2: mux4x1 
	port map(
		pr1(8 downto 6),
		pr1(5 downto 3),
		pr1(11 downto 9),
		pr1(11 downto 9),
		A1,
		m22,
		D_out(17 downto 15)
	);




    	 
end behave;
