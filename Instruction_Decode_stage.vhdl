library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID is
    port(pr2_reset_synch,pr2_reset: in std_logic;
			pr1_out : in std_logic_vector(15 downto 0); 
         pc_next : in std_logic_vector(15 downto 0);
         pr2_en: in std_logic;
			counter_reset : in std_logic;
         clk : in std_logic;
			
			pc_pr1_LMSM_wr_en : out std_logic;
         ID_out: out std_logic_vector(57 downto 0);
			opcode_lm_sm:out std_logic_vector(3 downto 0));
end entity;



architecture behave of ID is 

component counter is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           start : in  std_logic;
           count : out std_logic_vector(2 downto 0);
           --tf : out std_logic;
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
			rf_write_lm : in std_logic;
         D_out: out std_logic_vector(39 downto 0);
			count: in std_logic_vector(2 downto 0);
			ori_op : in std_logic_vector(3 downto 0)); 
end component;

component pr2 is
    port(decoder_out : in std_logic_vector(39 downto 0); 
        pc_next: in std_logic_vector(15 downto 0);				-- if Instruction at PC is at ID stage then PC_next is PC+2
		pr2_wr_en: in std_logic;
		clk: in std_logic;
        imm_reg_en : in std_logic;
		  lmsm : in std_logic;
		pr2_out: out std_logic_vector(57 downto 0);
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

signal imm,imm_prev_for_lmsm,count_num: std_logic_vector (2 downto 0);
signal imm_sig : unsigned (2 downto 0):="000";
signal opcode : std_logic_vector(3 downto 0);
signal inst_updated : std_logic_vector (15 downto 0);
signal counter_start_sig,temp_en_sig,rf_wr_lm ,reset,lmsm: std_logic;
signal pr2_en_sig:std_logic;
    
begin 
		opcode_lm_sm<=opcode;
		pr2_en_sig<=pr2_en or(not(opcode(3)) and opcode(2) and opcode(1)) ;
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
				if count_num = "000" then
					lmsm <= '0';
				else 
					lmsm<= '1';
				end if;
        elsif opcode = "0111" then
            counter_start_sig <= '1';
            inst_updated (15 downto 12) <= "0101";
            inst_updated (11 downto 9) <= count_num;
            inst_updated (8 downto 6) <= pr1_out(11 downto 9);
            inst_updated (5 downto 3) <= "000";
            inst_updated (2 downto 0) <= imm;
				if count_num = "000" then
					lmsm <= '0';
				else 
					lmsm<= '1';
				end if;
        else
        counter_start_sig <= '0';
        inst_updated <= pr1_out; 
		  lmsm <= '0';
        end if;

    end process;
	
    imm_proc  :process(clk,pr1_out,imm_sig,reset)
    begin
	 if rising_edge(clk) then
        if reset = '1' then
           imm_sig <= ("000");
        elsif (rf_wr_lm = '1' and (opcode = "0110" or opcode = "0111")) then
           --imm <= imm_sig;
			  imm_sig <= imm_sig + 1;
			 else
			 imm_sig<=imm_sig;
        end if; 
		end if;
		  imm <= std_logic_vector(imm_sig);
    end process;
    --one_or_zero <= pr1_out(to_integer(unsigned(count_num)-1));
	 rf_wr_lm <= pr1_out(to_integer(7-unsigned(count_num)));
    
    ID_decoder: Decoder
        port map(inst_updated,rf_wr_lm,dec_pr2,count_num,opcode);
	reset <= count_num(0) and count_num(1) and count_num(2) ; 
	--reg_lmsm : imm_lmsm
		--port map(imm, clk, reset, imm_prev_for_lmsm );

    pipeline_reg: pr2
        port map(dec_pr2,pc_next,pr2_en_sig,clk,temp_en_sig,lmsm,ID_out, pr2_reset,pr2_reset_synch);
    countter : counter
            port map(clk,counter_reset,counter_start_sig,count_num,temp_en_sig);
	pc_pr1_LMSM_wr_en <= (not(counter_start_sig) and not(count_num(0) or count_num(1) or count_num(2) ))
									or(count_num(0) and count_num(1) and count_num(2));
end behave;
