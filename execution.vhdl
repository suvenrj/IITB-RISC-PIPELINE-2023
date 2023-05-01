library ieee;
use ieee.std_logic_1164.all;

entity exec is
	port(clk: in std_logic;
    pr3: in std_logic_vector(99 downto 0);
    pr4_en: in std_logic;
    ex_out:out std_logic_vector(54 downto 0);
    REGA_data,REGb_data: out std_logic_vector(15 downto 0); decoder2_out,dest_addr:out std_logic_vector(2 downto 0);
    se_out,ALU_C_out:out  std_logic_vector(15 downto 0);M14_Control:out std_logic;
    ex_data: out std_logic_vector(15 downto 0);
    ex_dest: out std_logic_vector(2 downto 0));
end entity exec;

-- data 1 and data 2 are for ALU but data_imm is needed for beq instr

architecture bhv_exec of exec is
    signal control_bits : std_logic_vector(3 downto 0);

    component basic_ALU is
        port(
            ALU_A, ALU_B: in std_logic_vector(15 downto 0);
            Carry_prev: in std_logic;
            Control: in std_logic_vector(2 downto 0);
            ALU_C: out std_logic_vector(15 downto 0);
            Carry_new,Zero_new : out std_logic
        );
    end component;

    component complimenter is
        Port ( Inp : in  std_logic_vector(15 downto 0);
               Outp : out std_logic_vector(15 downto 0));
    end component;

    component mux2x1_16bit is
        port(I0: in std_logic_vector(15 downto 0);
             I1: in std_logic_vector(15 downto 0);
             S0: in std_logic;
            I_out:out std_logic_vector(15 downto 0));
    end component;

    component mux4x1_1bit is
        port(I00,I01,I10,I11: in std_logic;
             S0: in std_logic_vector(1 downto 0);
            I_out:out std_logic);
    end component;

    component Carry_flag is
        port (
            clk : in std_logic;
            en : in std_logic;
            Cy_in : in std_logic;
            Cy_out : out std_logic
        );
    end component;

    component zero_flag is
        port (
            clk : in std_logic;
            en : in std_logic;
            Z_in : in std_logic;
            Z_out : out std_logic
        );
    end component;
    
    component pr4 is
        port(   ALU_out : in std_logic_vector(15 downto 0); 
                RF_wr: in std_logic;				-- if Instruction at PC is at ID stage then PC_next is PC+2
                pr4_wr_en: in std_logic;
                dest_address: in std_logic_vector(2 downto 0);
                mem_wr:in std_logic;
                m5_control:in std_logic_vector(1 downto 0);
                PC_next:in std_logic_vector(15 downto 0);
                Ra_value:in std_logic_vector(15 downto 0);
                clk: in std_logic;
            
                pr4_out: out std_logic_vector(54 downto 0)); 
    end component;

    component Decoder2 is
        port(OPCODE : in std_logic_vector(3 downto 0); 
             C_alu,Z_alu: in std_logic;
             M7_control,M8_control,M9_control: out std_logic);          
    end component;

    signal cy_frm_alu,cy_old,z_frm_alu,z_old,m1_out,M7_control,M8_control,M9_control:std_logic;
    signal comp_out,m6_out,alu_out:std_logic_vector(15 downto 0);
    signal pr4_outt: std_logic_vector(54 downto 0);
    begin
        cp1: complimenter
        port map(pr3(47 downto 32),comp_out);

        m6: mux2x1_16bit
        port map(pr3(47 downto 32),comp_out,pr3(62),m6_out);

        c_flag: carry_flag
        port map(clk,pr3(53),Cy_frm_alu,cy_old);

        z_flag: zero_flag
        port map(clk,pr3(54),z_frm_alu,z_old);

        alu: basic_ALU
        port map(pr3(31 downto 16),m6_out,cy_old,pr3(57 downto 55),Alu_out,cy_frm_alu,z_frm_alu);

        m1: mux4x1_1bit
        port Map(pr3(51),pr3(51),cy_old,z_old,pr3(59 downto 58),m1_out);

        pr4_reg: pr4
        port map(ALU_out,m1_out,pr4_en,pr3(50 downto 48),pr3(52),pr3(61 downto 60),pr3(83 downto 68),pr3(99 downto 84),clk,pr4_outt);

        Dec_2: Decoder2
        port map(pr3(67 downto 64),cy_frm_alu,z_frm_alu,M7_control,M8_control,M9_control);

        REGA_data<=pr3(31 downto 16);
        REGB_data<=pr3(47 downto 32);
        decoder2_out(0)<=M7_control;
        decoder2_out(1)<=M8_control;
        decoder2_out(2)<=M9_control;
        dest_addr<=pr3(50 downto 48);
        Se_out<=pr3(15 downto 0);
        ALU_c_out<=ALU_out;
        M14_control<= pr3(63);
        ex_data<=alu_out;
        ex_dest<=pr3(50 downto 48);

        ex_out <=pr4_outt;

		

end bhv_exec;