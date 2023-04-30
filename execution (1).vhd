library ieee;
use ieee.std_logic_1164.all;

entity exec is
	port(clock,c_in,z_in,write_en_in: in std_logic;instruction_in,data1,data2,data_imm: in std_logic_vector(15 downto 0);z_out,c_out,write_en_out: out std_logic;instruction_out,data_imm_out,data_out,data_out1: out std_logic_vector(15 downto 0));
end entity exec;

-- data 1 and data 2 are for ALU but data_imm is needed for beq instr

architecture bhv of exec is
    signal control_bits : std_logic_vector(3 downto 0);

    component ALU is
        port(ALU_A,ALU_B: in std_logic_vector(15 downto 0);control: in std_logic_vector(2 downto 0); c_in: in std_logic;
            c_out,zero: out std_logic;ALU_C: out std_logic_vector(15 downto 0));
    end component ALU;

    begin
		control_bits(2 downto 0) <= instruction_in(2 downto 0);
        control_bits(3) <= instruction_in(15);
        instruction_out <= instruction_in;
        data_imm_out <= data_imm;
        data_out1 <= data1;
        ALU1: ALU port map(data1,data2,control_bits,c_in,c_out,z_out,data_out);

        proc1: process(clock,c_in,z_in,write_en_in)
        begin
            if(instruction_in(15 downto 12) = "0001" | instruction_in(15 downto 12) = "0010" ) then
                case control_bits(1 downto 0) is
                    when "10" =>
                        write_en_out <= c_in;
                    when "01" =>
                        write_en_out <= z_in;
                    when others =>
                        write_en_out <= write_en_in;
                end case;
            else
                write_en_out <= write_en_in;
            end if;
        end process;

end bhv;
    
