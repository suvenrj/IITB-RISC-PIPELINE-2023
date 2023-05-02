library ieee;
use ieee.std_logic_1164.all;

entity ID is
    port(pr2_reset_synch,pr2_reset: in std_logic;
	 pr1_out : in std_logic_vector(15 downto 0); 
         pc_next : in std_logic_vector(15 downto 0);
         pr2_en: in std_logic;
         clk : in std_logic;
         ID_out: out std_logic_vector(55 downto 0)); 
end entity;



architecture behave of ID is 

component mux2x1 is
	port(I1: in std_logic_vector(2 downto 0);
	     I2: in std_logic_vector(2 downto 0);
		 S0: in std_logic;
		I_out:out std_logic_vector(2 downto 0));
end component;

component Decoder is
    port(pr1 : in std_logic_vector(15 downto 0); 
         D_out: out std_logic_vector(39 downto 0)); 
end component;

component pr2 is
    port(decoder_out : in std_logic_vector(39 downto 0); 
        pc_next: in std_logic_vector(15 downto 0);				-- if Instruction at PC is at ID stage then PC_next is PC+2
		pr2_wr_en: in std_logic;
		clk: in std_logic;
		pr2_out: out std_logic_vector(55 downto 0);
		reset_asynch,reset_synch: in std_logic); 
end component;

signal dec_pr2: std_logic_vector(39 downto 0);  -- sign_ext control

    
begin 
    ID_decoder: Decoder
        port map(pr1_out,dec_pr2);

    pipeline_reg: pr2
        port map(dec_pr2,pc_next,pr2_en,clk,ID_out, pr2_reset,pr2_reset_synch);

    	 
end behave;
