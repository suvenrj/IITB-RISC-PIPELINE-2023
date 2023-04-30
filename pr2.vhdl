library ieee;
use ieee.std_logic_1164.all;

entity pr2 is
    port(decoder_out : in std_logic_vector(39 downto 0); 
         pc_next: in std_logic_vector(15 downto 0);				-- if Instruction at PC is at ID stage then PC_next is PC+2
			pr2_wr_en: in std_logic;
			clk: in std_logic;
			pr2_out: out std_logic_vector(55 downto 0)); 
end entity;

architecture behave of Decoder is 

signal A,B,C,D,Co,Cy,Z,A1,B1,C1,D1,Co1,Cy1,Z1: std_logic;  -- sign_ext control

    
begin 
	pr2_out(39 downto 0) <= decoder_out(15 downto 0);
	pr2_out(55 downto 40) <= pc_next(15 downto 0);
    	 
end behave;
