library ieee;
use ieee.std_logic_1164.all;

entity instruction_fetch is 
    port (clk: in std_logic; instruction_out : out std_logic_vector(15 downto 0);  
    reg_a_data: in std_logic_vector(15 downto 0); reg_b_data: in std_logic_vector(15 downto 0);imm_exec: in std_logic_vector(15 downto 0);
	 m7_cont,m8_cont,m9_cont,m14_cont: in std_logic; pr1_en : in std_logic;pc_en :in std_logic -- from data hazard
    );
end entity;

architecture behave of instruction_fetch is 
    signal c_6,c_2,s1,s2,s3,s4,s5,s6,s7,s8: std_logic_vector(15 downto 0);

    component pc_register is
        port (pc_in: in std_logic_vector(15 downto 0); pc_out : out std_logic_vector(15 downto 0); clock: in std_logic; pc_write_en: in std_logic);
    end component;
    
    component alu_pc_2 is 
        port(alu_pc : in std_logic_vector(15 downto 0); alu_const_in: in std_logic_vector(15 downto 0); out_pc : out std_logic_vector(15 downto 0));
    end component;
    
    component rom is 
    port (    
          dataPointer   : in std_logic_vector(15 downto 0);      
          do  : out std_logic_vector(15 downto 0));  
    end component; 
	component mux2x1_16bit is
        port(I0: in std_logic_vector(15 downto 0);
             I1: in std_logic_vector(15 downto 0);
             S0: in std_logic;
            I_out:out std_logic_vector(15 downto 0));
    end component;
    component pr1 is
        port(Instr : in std_logic_vector(15 downto 0); 
                pr1_wr_en: in std_logic;
                clk: in std_logic;
                pr1_out: out std_logic_vector(15 downto 0)); 
    
    end component;
    begin 
    c_6 <= "0000000011111010";
    c_2 <= "0000000000000001";
    m7 : mux2x1_16bit
        port map(c_2,c_6,m7_cont,s2);
    adder1 : alu_pc_2
        port map(s1,s2,s3);
    m8 : mux2x1_16bit
        port map(reg_a_data,s3,m8_cont,s4);
    adder2 : alu_pc_2
        port map(s4,imm_exec,s5);
    m9 : mux2x1_16bit
        port map(s5,s3,m9_cont,s6);
    m14 : mux2x1_16bit
        port map(s6,reg_b_data,m14_cont,s7);
    PC : pc_register 
        port map(s7, s1, clk,pc_en);
    Inst_mem : rom
        port map(s1,s8);
    pr1_reg : pr1
        port map(s8,pr1_en,clk,instruction_out);
end behave;