library ieee;
use ieee.std_logic_1164.all;

entity IITB_RISC is
    port(clk, reset:in std_logic);
end entity;

architecture behav_cpu of IITB_risc is



component instruction_fetch is 
    port (pc_reset, pr1_reset, clk: in std_logic; instruction_out : out std_logic_vector(15 downto 0);  
    reg_a_data: in std_logic_vector(15 downto 0); reg_b_data: in std_logic_vector(15 downto 0);imm_exec: in std_logic_vector(15 downto 0);
	 m7_cont,m8_cont,m9_cont,m14_cont: in std_logic; pr1_en : in std_logic;pc_en :in std_logic; -- from data hazard
     pc_next: out std_logic_vector(15 downto 0)
    );
end component;

component ID is
    port(pr2_reset: in std_logic;
        pr1_out : in std_logic_vector(15 downto 0); 
         pc_next : in std_logic_vector(15 downto 0);
         pr2_en: in std_logic;
         clk : in std_logic;
         ID_out: out std_logic_vector(55 downto 0)); 
end component;

component operand_read is
    port(pr3_reset: in std_logic;
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
end component;

component exec is
	port(pr4_reset: in std_logic;
        clk: in std_logic;
    pr3: in std_logic_vector(99 downto 0);
    pr4_en: in std_logic;
    ex_out:out std_logic_vector(54 downto 0);
    REGA_data: out std_logic_vector(15 downto 0); decoder2_out:out std_logic_vector(2 downto 0);
    se_out,ALU_C_out:out  std_logic_vector(15 downto 0);M14_Control:out std_logic;
    ex_dest: out std_logic_vector(2 downto 0);
    opcode : out std_logic_vector(2 downto 0));
end component exec;

component memoryaccess is 
    port (pr5_reset, clk: in std_logic;pr4:std_logic_vector(54 downto 0);pr5_en: in std_logic;mem_stage_out: out std_logic_vector(19 downto 0);macc_data:out std_logic_vector(15 downto 0);macc_dest:out std_logic_vector(2 downto 0));
end component;

component write_back is
    port( 
    reg_write_en_out: out std_logic;
    data_out: out std_logic_vector(15 downto 0); 
    dest_reg_out: out std_logic_vector(2 downto 0); 
    pr5_out : in std_logic_vector(19 downto 0)
);
end component;

component load_hazard_detector is
    port (load_dest, reg_a, reg_b: in std_logic_vector(2 downto 0); 
        opcode: in std_logic_vector(3 downto 0);
        prev_hazard_out, hazard_out, clk, pc_en, pr1_en, pr2_en: out std_logic
        );
end component;

signal if_id:std_logic_vector(15 downto 0);
signal id_or:std_logic_vector(55 downto 0);
signal or_exec:std_logic_vector(99 downto 0);
signal exec_macc:std_logic_vector(54 downto 0);
signal macc_wb:std_logic_vector(19 downto 0);
signal s_alu_exec, s_imm_exec, s_pc_next, S_rega_exec,s_df_exec , s_df_wb, s_df_ma, junk: std_logic_vector(15 downto 0);
signal s_df_adr_exec, s_df_adr_ma, s_df_adr_wb, s_decoder_2, s_reg_a_or, s_reg_b_or:std_logic_vector(2 downto 0);
signal s_opcode_exec:std_logic_vector(3 downto 0);
signal s_rf_wr_en,Pr1_en,Pr2_en,Pr3_en,Pr4_en,Pr5_en,s_pc_en,s_m14_control, s_haz, s_prev_haz,s_pc_reset,s_pr1_reset
,s_pr2_reset,s_pr3_reset,s_pr4_reset,s_pr5_reset:std_logic;
begin
    pr3_en<='1';
    pr4_en<='1';
    pr5_en<='1';
    s_pc_reset <= reset;
    s_pr1_reset <= reset;
    s_pr2_reset <= reset;
    s_pr3_reset <= reset or (s_haz and (not s_prev_haz));  -- put 000.. in pr3 when you detect load hazard
    s_pr4_reset <= reset;
    s_pr5_reset <= reset;
    iff: instruction_fetch
    port map(s_pc_reset, s_pr1_reset,clk,if_id,S_rega_exec,s_alu_exec,s_imm_exec,s_decoder_2(0),s_decoder_2(1),s_decoder_2(2),s_m14_control,pr1_en,s_pc_en,s_pc_next);

    inst_decode: ID
    port map(s_pr2_reset,if_id,s_pc_next,pr2_en,clk,id_or);
    
    oper_re: Operand_read
    port map(s_pr3_reset,id_or,s_df_adr_wb,s_df_wb,s_rf_wr_en,pr3_en,clk,s_df_exec,s_df_ma,s_df_adr_exec,s_df_adr_ma,s_reg_a_or,s_reg_b_or,or_exec);

    execution: exec
    port map(s_pr4_reset, clk,or_exec,pr4_en,exec_macc, s_rega_exec, s_decoder_2,s_imm_exec,s_alu_exec,s_m14_control,s_df_adr_exec, s_opcode_exec);

    memacc: memoryaccess
    port map(s_pr5_reset, clk,exec_macc, pr5_en, macc_wb, s_df_ma, s_df_adr_ma);

    wb: write_back
    port map(s_rf_wr_en, s_df_wb, s_df_adr_wb, macc_wb);

    load_haz : load_hazard_detector
    port map(s_df_adr_exec, s_reg_a_or, s_reg_b_or, s_opcode_exec, s_prev_haz, s_haz,clk, s_pc_en, pr1_en, pr2_en );

end architecture;
