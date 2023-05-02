library ieee;
use ieee.std_logic_1164.all;

entity operand_read is
    port(pr3_reset_2: in std_logic;
	    pr3_reset: in std_logic;
	 pr2_out: in std_logic_vector(55 downto 0);
         dest_add: in std_logic_vector(2 downto 0);
         dest_data: in std_logic_vector(15 downto 0);
         rf_wr_en: in std_logic;
         pr3_wr_en:in std_logic;
         clk:in std_logic;
         ex_data,macc_data: in std_logic_vector(15 downto 0);
         ex_dest,macc_dest: in std_logic_vector(2 downto 0);
	 reg_a_adr, reg_b_adr: out std_logic_vector(2 downto 0);
         or_out:out std_logic_vector(99 downto 0));
end entity;

architecture behave_or of operand_read is 

signal data_regfi1,data_regfi2,s3: std_logic_vector(15 downto 0);
signal s1: std_logic_vector(5 downto 0);
signal s2: std_logic_vector(8 downto 0);
signal s4: std_logic;  -- sign_ext control
signal m15_out,m16_out :std_logic_vector (15 downto 0 );
signal op:std_logic_vector(3 downto 0);

component regfi is
    port (
        clk : in std_logic;
        reg_write : in std_logic;
        add_reg_1, add_reg_2, add_write : in std_logic_vector(2 downto 0);
        write_data : in std_logic_vector(15 downto 0);
        data_1, data_2 : out std_logic_vector(15 downto 0)
    );
end component;

component sign_ext is
	port (
		input_6: in std_logic_vector(5 downto 0);
		input_9: in std_logic_vector(8 downto 0);
		control: in std_logic;		

		se_out: out std_logic_vector(15 downto 0)) ;
end component;
    
component mux2x1_16bit is
	port(I0: in std_logic_vector(15 downto 0);
	     I1: in std_logic_vector(15 downto 0);
		 S0: in std_logic;
		I_out:out std_logic_vector(15 downto 0));
end component;

component mux4x1_16 is
	port(I00,I01,I10,I11: in std_logic_vector(15 downto 0);
		 S0: in std_logic_vector(1 downto 0);
		I_out:out std_logic_vector(15 downto 0));
end component;

component pr3 is
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
	 reset_2: in std_logic;
        pr3_out: out std_logic_vector(99 downto 0)); 
end component;

signal D1,D2,imm_out,M2_out,M4_out: std_logic_vector(15 downto 0);
begin 
    reg_a_adr <= pr2_out(14 downto 12);
    reg_b_adr <= pr2_out(17 downto 15);
    op <= pr2_out(39 downto 36);
    reg_file:regfi
    port map(clk,rf_wr_en,pr2_out(14 downto 12),pr2_out(17 downto 15),dest_add,dest_data,D1,D2);

    si_ext: sign_ext
    port map(pr2_out(5 downto 0),pr2_out(8 downto 0),pr2_out(26),IMM_out);

    m4: mux4x1_16
    port map("0000000000000000","0000001000000000",D1,D1,pr2_out(31 downto 30),M4_out);

    m2: mux2x1_16bit
    port map(D2,IMM_out,pr2_out(29),m2_out);

    pr3_reg: pr3
    port map(m15_out,m16_out,Imm_out,pr2_out(55 downto 40),D2,pr2_out(11 downto 9),pr2_out(25 downto 23),pr2_out(20),pr2_out(21),pr2_out(33 downto 32),pr2_out(34),pr2_out(28 downto 27),pr2_out(35),pr2_out(39 downto 36),pr2_out(18),pr2_out(19),pr3_wr_en,clk,pr3_reset,pr3_reset_2,or_out);

    p1_m15:process(op,pr2_out,ex_data,macc_data,ex_dest,macc_dest,m4_out,dest_data,dest_add)
    begin
        if op = "0001" or op = "0000" or op = "0010" or op = "1111" or op = "1000" or op = "1001" or op = "1010" or op = "0100" or op = "0101"  then
            if pr2_out(14 downto 12) = ex_dest then
                m15_out<= ex_data;
            elsif pr2_out(14 downto 12) = macc_dest then
                m15_out<=macc_data;
            elsif pr2_out(14 downto 12) = dest_add then
                m15_out<=dest_data;
            else 
                m15_out<=m4_out;
            end if;
        else
            m15_out<=m4_out;
        end if;
    end process;

    p1_m16:process(op,pr2_out,ex_data,macc_data,ex_dest,macc_dest,m2_out,dest_data,dest_add)
    begin
        if  op = "1000" or op = "1001" or op = "1010" or op = "1101" then
            if pr2_out(17 downto 15) = ex_dest then
                m16_out<= ex_data;
            elsif pr2_out(17 downto 15) = macc_dest then
                m16_out<=macc_data;
            elsif pr2_out(17 downto 15) = dest_add then
                m16_out<=dest_data;
            else 
                m16_out<=m2_out;
            end if;
        else
            m16_out<=m2_out;
        end if;
    end process ;

end architecture;
