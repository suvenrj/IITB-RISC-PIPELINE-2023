library ieee;
use ieee.std_logic_1164.all;

entity pr3 is
    port(opr1 : in std_logic_vector(15 downto 0); --
        opr2: in std_logic_vector(15 downto 0); --
        imm : in std_logic_vector(15 downto 0); --
        pc_next: in std_logic_vector(15 downto 0);	-- if Instruction at PC is at ID stage then PC_next is PC+2
        reg_a_data_sw: in std_logic_vector(15 downto 0);	--
        dest_reg: in std_logic_vector(2 downto 0); --
        alu_control: in std_logic_vector(2 downto 0);  --
        carry_write_en: in std_logic; --
        zero_flag_en: in std_logic; --
        m5_control: in std_logic_vector(1 downto 0); ---
        m6_control: in std_logic; ---
        m1_control: in std_logic_vector(1 downto 0); --
        m14_control: in std_logic;
        opcode: in std_logic_vector(3 downto 0);
        regfi_write_en: in std_logic; --
        data_memory_write_en: in std_logic; --
        pr3_wr_en: in std_logic;
        clk: in std_logic;
	reset : in std_logic;
	 
        pr3_out: out std_logic_vector(99 downto 0)); 
end entity;

architecture behave of pr3 is 

signal reg_sig : std_logic_vector(99 downto 0);  -- sign_ext control

    
begin 
	process (clk,pr3_wr_en)
    begin
	if reset = '0' then
		if rising_edge(clk) then
		    if pr3_wr_en = '1' then
			reg_sig(15 downto 0) <= imm;
					reg_sig(31 downto 16) <= opr1;
			reg_sig(47 downto 32) <= opr2;
			reg_sig(50 downto 48) <= dest_reg;
			reg_sig(51) <= regfi_write_en;
			reg_sig(52) <= data_memory_write_en;
			reg_sig(53) <= carry_write_en;
			reg_sig(54) <= zero_flag_en;
			reg_sig(57 downto 55) <= alu_control;
			reg_sig(59 downto 58) <= m1_control;
			reg_sig(61 downto 60) <= m5_control;
			reg_sig(62) <= m6_control;
			reg_sig(63) <= m14_control;
			reg_sig(67 downto 64) <= opcode;
			reg_sig(83 downto 68) <= pc_next;
			reg_sig(99 downto 84) <= reg_a_data_sw;
		    end if;
		end if;
	else 
		reg_sig <= (others => '0');
	end if;
    end process;
    pr3_out <= reg_sig;	 
end behave;
