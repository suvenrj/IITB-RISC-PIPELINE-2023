library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Iins is
    port(pr2_reset_synch,pr2_reset: in std_logic;
			pr1_out : in std_logic_vector(15 downto 0); 
         pc_next : in std_logic_vector(15 downto 0);
         pr2_en: in std_logic;
			counter_reset : in std_logic;
         clk : in std_logic;
			
			pc_pr1_LMSM_wr_en : out std_logic;
         ID_out: out std_logic_vector(56 downto 0)); 
end entity;



architecture behave of Iins is 

component counter is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           start : in  std_logic;
           count : out std_logic_vector(2 downto 0);
           tf : out std_logic;
			  temp_en : out std_logic);
end component;
component mux2x1 is
	port(I1: in std_logic_vector(2 downto 0);
	     I2: in std_logic_vector(2 downto 0);
		 S0: in std_logic;
		I_out:out std_logic_vector(2 downto 0));
end component;

component Decoder is
    port(pr1 : in std_logic_vector(15 downto 0); 
         D_out: out std_logic_vector(39 downto 0);
			ori_op : in std_logic_vector(3 downto 0)); 
end component;

component pr2 is
    port(decoder_out : in std_logic_vector(39 downto 0); 
        pc_next: in std_logic_vector(15 downto 0);				-- if Instruction at PC is at ID stage then PC_next is PC+2
		pr2_wr_en: in std_logic;
		clk: in std_logic;
        imm_reg_en : in std_logic;
		pr2_out: out std_logic_vector(56 downto 0);
		reset_asynch,reset_synch: in std_logic); 
end component;

component adder_3bit is
    Port ( a : in  std_logic_vector(2 downto 0);
           b : in  std_logic_vector(2 downto 0);
           cin : in std_logic;
           sum : out std_logic_vector(2 downto 0));
end component;

component imm_lmsm is
    port (
        data_in  : in  std_logic_vector(2 downto 0);
        clk      : in  std_logic;
        reset    : in  std_logic;
        data_out : out std_logic_vector(2 downto 0)
    );
end component;

signal dec_pr2: std_logic_vector(39 downto 0);  -- sign_ext control

signal imm_sig,imm,imm_prev_for_lmsm,count_num: std_logic_vector (2 downto 0);
signal opcode : std_logic_vector(3 downto 0);
signal inst_updated : std_logic_vector (15 downto 0);
signal counter_start_sig,one_or_zero,tf_flag,temp_en_sig : std_logic;

    
begin 
		
		opcode <= pr1_out(15 downto 12);
    inst_updating : process(pr1_out, count_num,imm,opcode)
	 begin
        if opcode = "0110" then
            counter_start_sig <= '1';
            inst_updated (15 downto 12) <= ("0100");
            inst_updated (11 downto 9) <= std_logic_vector(unsigned(count_num));
            inst_updated (8 downto 6) <= pr1_out(11 downto 9);
            inst_updated (5 downto 3) <= "000";
            inst_updated (2 downto 0) <= imm;
        
        elsif opcode = "0111" then
            counter_start_sig <= '1';
            inst_updated (15 downto 12) <= "0101";
            inst_updated (11 downto 9) <= count_num;
            inst_updated (8 downto 6) <= pr1_out(11 downto 9);
            inst_updated (5 downto 3) <= "000";
            inst_updated (2 downto 0) <= imm;
        else
        counter_start_sig <= '0';
        inst_updated <= pr1_out; 
        end if;

    end process;
    imm_proc  :process(count_num,imm_sig)
    begin
        if count_num ="001" then
            imm <= ("000");
        else
            imm <= imm_sig;
        end if; 
    end process;
    one_or_zero <= pr1_out(to_integer(unsigned(count_num)-1));
    adder : adder_3bit
        port map(imm_prev_for_lmsm,"000",one_or_zero,imm_sig);
    
    ID_decoder: Decoder
        port map(inst_updated,dec_pr2,opcode);
		
	reg_lmsm : imm_lmsm
		port map(imm, clk, tf_flag, imm_prev_for_lmsm );

    pipeline_reg: pr2
        port map(dec_pr2,pc_next,pr2_en,clk,temp_en_sig,ID_out, pr2_reset,pr2_reset_synch);
    countter : counter
            port map(clk,counter_reset,counter_start_sig,count_num,tf_flag,temp_en_sig);
	pc_pr1_LMSM_wr_en <= not(counter_start_sig) or(count_num(0) and count_num(1) and count_num(2) );
end behave;
