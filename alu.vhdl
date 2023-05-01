library ieee;
use ieee.std_logic_1164.all;

entity basic_ALU is
    port(
        ALU_A, ALU_B: in std_logic_vector(15 downto 0);
		Carry_prev: in std_logic;
        Control: in std_logic_vector(2 downto 0);
        ALU_C: out std_logic_vector(15 downto 0);
		Carry_new,Zero_new : out std_logic
    );
end entity;

architecture behav of basic_ALU is
	component arithmetic_unit is 
		port(
			A, B: in std_logic_vector(15 downto 0); 
			C2:in std_logic;
			Cy : in std_logic;		
			C: out std_logic_vector(15 downto 0);
			new_cy: out std_logic;
			new_zero: out std_logic
		);
	end component;
	component mux2x1_1bit is
		port(I0: in std_logic;
			I1: in std_logic;
			S0: in std_logic;
			I_out:out std_logic);
		end component;
signal s3 : std_logic_vector (15 downto 0);
signal c0,c1,s1,s2,s4,s5 : std_logic;
	begin
		c0<='0';
		c1<='1';
    	m1: mux2x1_1bit
		port map(c0,c1,
				Control(0),s1);
		m2: mux2x1_1bit
		port map(s1,Carry_prev,
				Control(1),s2);
		main_unit : arithmetic_unit
		port map(ALU_A,ALU_B,Control(2),s2,s3,s4,s5);
		ALU_C <= s3;
		Carry_new <= s4;
		Zero_new <= s5;
end architecture;
