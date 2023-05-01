library ieee;
use ieee.std_logic_1164.all;

entity exec is
	port(clock,c_in,z_in,write_en_in,m6_control: in std_logic;m1_control:in std_logic_vector(1 downto 0);alu_control:in std_logic_vector(2 downto 0);data1,data2,data_imm: in std_logic_vector(15 downto 0);z_out,c_out,write_en_out: out std_logic;data_imm_out,data_out,data_out1: out std_logic_vector(15 downto 0));
end entity exec;

-- data 1 and data 2 are for ALU but data_imm is needed for beq instr

architecture bhv of exec is
    signal control_bits : std_logic_vector(3 downto 0);
    signal data_2c : std_logic_vector(15 downto 0);

    component basic_ALU is
	    port(ALU_A, ALU_B: in std_logic_vector(15 downto 0);Carry_prev: in std_logic;Control: in std_logic_vector(2 downto 0);ALU_C: out std_logic_vector(15 downto 0);Carry_new,Zero_new : out std_logic);
    end component;

    component complimenter is
        port ( Inp : in  std_logic_vector(15 downto 0);Outp : out std_logic_vector(15 downto 0));
    end component;

    begin
		control_bits(2 downto 0) <= alu_control;
        control_bits(3) <= m6_control;
        data_imm_out <= data_imm;
        data_out1 <= data1;
        CPL : complimenter port map(data2,data_2c);

        proc0: process(data_2c)
        begin
            if(control_bits(3)='1') then
                data2 <= data_2c;
            else
                data2 <= data2;
            end if;
        end process;
        
        ALU1: basic_ALU port map(data1,c_in,control_bits,data_out,c_out,z_out);

        proc1: process(clock,c_in,z_in,write_en_in) --  i think there is no need of process here
                case m1_control(1 downto 0) is
                    when "10" =>
                        write_en_out <= c_in;
                    when "11" =>
                        write_en_out <= z_in;
                    when others =>
                        write_en_out <= write_en_in;
                end case;
        end process;

end bhv;
    
