library ieee;
use ieee.std_logic_1164.all;

entity IITB_RISC is
    port(clk:in std_logic);
end entity;

architecture behav_cpu of IITB_risc is

component instruction_fetch is 
    port (clk: in std_logic; instruction_out : out std_logic_vector(15 downto 0);  
    reg_a_data: in std_logic_vector(15 downto 0); reg_b_data: in std_logic_vector(15 downto 0);imm_exec: in std_logic_vector(15 downto 0);
	 m7_cont,m8_cont,m9_cont,m14_cont: in std_logic; pr1_en : in std_logic;pc_en :in std_logic -- from data hazard
    );
end component;

component ID is
    port(pr1_out : in std_logic_vector(15 downto 0); 
         pc_next : in std_logic_vector(15 downto 0);
         pr2_en: in std_logic;
         clk : in std_logic;
         ID_out: out std_logic_vector(55 downto 0)); 
end component;

component operand_read is
    port(pr2_out: in std_logic_vector(55 downto 0);
         dest_add: in std_logic_vector(2 downto 0);
         dest_data: in std_logic_vector(15 downto 0);
         rf_wr_en: in std_logic;
         pr3_wr_en:in std_logic;
         clk:in std_logic;
         ex_data,macc_data: in std_logic_vector(15 downto 0);
         ex_dest,macc_dest: in std_logic_vector(2 downto 0);

         or_out:out std_logic_vector(99 downto 0));
end component;

component exec is
	port(clk: in std_logic;
    pr3: in std_logic_vector(99 downto 0);
    pr4_en: in std_logic;
    ex_out:out std_logic_vector(54 downto 0);
    REGA_data,REGb_data: out std_logic_vector(15 downto 0); decoder2_out,dest_addr:out std_logic_vector(2 downto 0);
    se_out,ALU_C_out:out  std_logic_vector(15 downto 0);M14_Control:out std_logic;
    ex_data: out std_logic_vector(15 downto 0);
    ex_dest: out std_logic_vector(2 downto 0));
end component exec;

component memoryaccess is 
    port (clk: in std_logic;pr4:std_logic_vector(54 downto 0);pr5_en: in std_logic;mem_stage_out: out std_logic_vector(19 downto 0);macc_data:out std_logic_vector(15 downto 0);macc_dest:out std_logic_vector(2 downto 0));
end component;

component write_back is
    port( 
    reg_write_en_out: out std_logic;
    data_out: out std_logic_vector(15 downto 0); 
    dest_reg_out: out std_logic_vector(2 downto 0); 
    pr5_out : in std_logic_vector(19 downto 0)
);
end component;
signal if_id:std_logic_vector(15 downto 0);
signal id_or:std_logic_vector(54 downto 0);
signal or_exec:std_logic_vector(99 downto 0);
signal exec_macc:std_logic_vector(54 downto 0);
signal macc_wb:std_logic_vector(19 downto 0);
begin
    if: instruction_fetch
    port map();

    inst_decode: ID
    port map();
    
    oper_re: Operand_read
    port map();

    execution: exec
    port map();

    memacc: memoryaccess
    port map();

    wb: write_back
    port map();

end architecture;
