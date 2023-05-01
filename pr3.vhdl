library ieee;
use ieee.std_logic_1164.all;

entity pr3 is
    port(opr1 : in std_logic_vector(15 downto 0);
        opr2: in std_logic_vector(15 downto 0);
        imm : in std_logic_vector(15 downto 0);
        pc_next: in std_logic_vector(15 downto 0);	-- if Instruction at PC is at ID stage then PC_next is PC+2
        reg_a_data_sw: in std_logic_vector(15 downto 0);	
        dest_reg: in std_logic_vector(2 downto 0);
        alu_control: in std_logic_vector(2 downto 0);
        carry_write_en: in std_logic;
        zero_flag_en: in std_logic;
        m5_control: in std_logic_vector(1 downto 0);
        m6_control: in std_logic;
        m1_control: in std_logic_vector(1 downto 0);
        regfi_write_en: in std_logic;
        data_memory_write_en: in std_logic;
        
        pr3_wr_en: in std_logic;
        clk: in std_logic;
        pr3_out: out std_logic_vector(94 downto 0)); 
            

end entity;

architecture behave of pr3 is 

signal reg_sig : std_logic_vector(94 downto 0);  -- sign_ext control

    
begin 
	process (clk)
    begin
        if rising_edge(clk) then
            if pr3_wr_en = '1' then
                reg_sig(15 downto 0) <= opr1;
				reg_sig(31 downto 16) <= opr2;
                reg_sig(47 downto 32) <= imm;
                reg_sig(63 downto 48) <= pc_next;
                reg_sig(79 downto 64) <= reg_a_data_sw;
                reg_sig(82 downto 80) <= dest_reg;
                reg_sig(85 downto 83) <= alu_control;
                reg_sig(86 downto 86) <= carry_write_en;
                reg_sig(87 downto 87) <= zero_flag_en;
                reg_sig(89 downto 88) <= m5_control;
                reg_sig(90 downto 90) <= m6_control;
                reg_sig(92 downto 91) <= m1_control;
                reg_sig(93 downto 93) <= regfi_write_en;
                reg_sig(94 downto 94) <= data_memory_write_en;
            end if;
        end if;
    end process;
    pr3_out <= reg_sig;	 
end behave;