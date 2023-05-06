library ieee;
use ieee.std_logic_1164.all;

entity pr4 is
    port(   ALU_out : in std_logic_vector(15 downto 0); 
            RF_wr: in std_logic;				-- if Instruction at PC is at ID stage then PC_next is PC+2
			pr4_wr_en: in std_logic;
            dest_address: in std_logic_vector(2 downto 0);
            mem_wr:in std_logic;
            m5_control:in std_logic_vector(1 downto 0);
            PC_next:in std_logic_vector(15 downto 0);
            Ra_value:in std_logic_vector(15 downto 0);
			clk: in std_logic;
			reset: in std_logic;
			cy_to_ma,z_to_ma: in std_logic;
			pr4_out: out std_logic_vector(56 downto 0)); 

end entity;

architecture behave_pr4 of pr4 is 

signal reg_sig : std_logic_vector(56 downto 0):=(others => '0');  -- sign_ext control

    
begin 
	process (clk,reg_sig,reset)
    begin
	if reset = '0' then
		if rising_edge(clk) then
		    if pr4_wr_en = '1' then
				reg_sig(15 downto 0) <= ALU_out;
				reg_sig(18 downto 16) <= Dest_address;
				reg_sig(19) <= RF_wr;
				reg_sig(20) <= mem_wr;
				reg_sig(22 downto 21) <= m5_control;
				reg_sig(38 downto 23)<= Pc_next;
				reg_sig(54 downto 39)<= Ra_value;
				reg_sig(55)<=cy_to_ma;
				reg_sig(56)<=z_to_ma;
			else
				reg_sig <= reg_sig;	
		    end if;
		else 
			reg_sig <= reg_sig;
		end if;
	else
		reg_sig <= (others => '0');
	end if;
    end process;
    pr4_out <= reg_sig;	 
end architecture;
