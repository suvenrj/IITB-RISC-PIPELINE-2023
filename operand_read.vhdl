library ieee;
use ieee.std_logic_1164.all;

entity operand_read is
    port(opcode : in std_logic_vector(3 downto 0); 
            adr1: in std_logic_vector(2 downto 0); 
                adr2: in std_logic_vector(2 downto 0);
                imm6_in: in std_logic_vector(5 downto 0);
                imm9_in: in std_logic_vector(8 downto 0);
                imm_out : out std_logic_vector(5 downto 0);
                opr1: out std_logic_vector(15 downto 0);
                opr2: out std_logic_vector(15 downto 0);
                write_data: in std_logic_vector(15 downto 0);   -- some cross-over with write back stage
                write_signal: in std_logic;
                write_adr: in std_logic_vector(2 downto 0);
                --stuff for data forwarding
                adr1_exec: in std_logic_vector(2 downto 0);
                data1_exec: in std_logic_vector(15 downto 0);
                df1_exec : in std_logic;
                adr2_exec: in std_logic_vector(2 downto 0);
                data2_exec: in std_logic_vector(15 downto 0);
                df2_exec: in std_logic;
                adr1_ma: in std_logic_vector(2 downto 0);
                data1_ma : in std_logic_vector(15 downto 0);
                df1_ma: in std_logic;
                adr2_ma: in std_logic_vector(2 downto 0);
                data2_ma: in std_logic_vector(15 downto 0);
                df2_ma: in std_logic;
                adr1_wb: in std_logic_vector(2 downto 0);
                data1_wb: in std_logic_vector(15 downto 0);
                df1_wb: in std_logic;
                adr2_wb: in  std_logic_vector(2 downto 0);
                data2_wb: in std_logic_vector(15 downto 0));
                df2_wb: in std_logic;
end entity;

architecture behave of operand_read is 

signal data_regfi1,data_regfi2,s3: std_logic_vector(15 downto 0);
signal s1: std_logic_vector(5 downto 0);
signal s2: std_logic_vector(8 downto 0);
signal s4: std_logic;  -- sign_ext control

component register_file is    
  port(
		--state : in std_logic_vector(3 downto 0);
		dinm : in std_logic_vector(15 downto 0);  
	  	regsela : in std_logic_vector(2 downto 0);
		regselb	: in std_logic_vector(2 downto 0);
		regselm : in std_logic_vector(2 downto 0);
		regwrite : in std_logic;
		douta : out std_logic_vector(15 downto 0);
		doutb : out std_logic_vector(15 downto 0) );
end component;

component sign_ext is
	port (
		input_6: in std_logic_vector(5 downto 0);
		input_9: in std_logic_vector(8 downto 0);
		control: in std_logic;		

		se_out: out std_logic_vector(15 downto 0)) ;
end component;
    
begin 

    reg : register_file port map(write_data, adr1, adr2, write_adr, write_signal, data_regfi1, data_regfi2);
    sign_extender : sign_ext port map(imm6_in, imm9_in, s4, s3);
    imm_out <= s3;
    proc_sign_control : process(opcode)
    begin
        if (opcode = "0011") then
            s4<='1';
        else
            s4<='0';
        end if;
    end process;
	proc1 : process(data_regfi1,data1_exec,data1_wb,data1_ma, data_regfi2, opcode)
	 begin
        if (adr1_exec = adr1 and df1_exec='1') then
            opr1 <= data1_exec;
        elsif (adr1_ma = adr1 and df1_ma='1') then
            opr1 <= data1_ma;
        elsif (adr1_wb = adr1 and df1_wb='1') then
            opr1 <= data1_wb;
        else
            if (opcode = "0100" or opcode="0101") then
                opr1 <= data_regfi2;
            elsif (opcode = "0011") then
                if (s3(0)='0') then 
                    opr1<="0000001000000000";
                else
                    opr1 <="0000000000000000";
                end if;
            else
                opr1 <= data_regfi1;
            end if;
        end if;
	 end process;
	proc2 : process(data_regfi2,data2_exec,data2_wb,data2_ma, s3, opcode)
	begin
        if (adr2_exec = adr2 and df2_exec='1') then
            opr2 <= data2_exec;
        elsif (adr2_ma = adr2 and df2_ma='1') then
            opr2 <= data2_ma;
        elsif (adr2_wb = adr2 and df2_wb='1') then
            opr2 <= data2_wb;
        else
            if (opcode = "0100" or opcode="0101" or opcode = "0011") then
                opr2 <= s3;
            else
                opr2 <= data_regfi2;
            end if;
        end if;    
end process;	 
end behave;
