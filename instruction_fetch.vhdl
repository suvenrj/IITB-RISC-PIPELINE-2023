library ieee;
use ieee.std_logic_1164.all;

entity instruction_fetch is 
    port (clock: in std_logic; instruction_out : out std_logic_vector(15 downto 0); opcode_exec: in std_logic_vector(3 downto 0); 
    reg_a_data: in std_logic_vector(15 downto 0); reg_b_data: in std_logic_vector(15 downto 0);imm_exec: in std_logic_vector(15 downto 0); branch_taken: in std_logic
    );
end entity;

architecture behave of instruction_fetch is 
    signal s1, s2, s3, s4, s5, s6, s7: std_logic_vector(15 downto 0);
	 -- needs to be changed
    
    component pc_register is
        port (pc_in: in std_logic_vector(15 downto 0); pc_out : out std_logic_vector(15 downto 0); clock: in std_logic);
    end component;
    
    component alu_pc_2 is 
        port(alu_pc : in std_logic_vector(15 downto 0); alu_const_in: in std_logic_vector(15 downto 0); out_pc : out std_logic_vector(15 downto 0));
    end component;
    
    component rom is 
    port (    
          dataPointer   : in std_logic_vector(15 downto 0);      
          do  : out std_logic_vector(15 downto 0));  
    end component; 
    
    begin 
    
    PC : pc_register port map(s6, s1, clock);
    PC_ALU : alu_pc_2 port map (s1, s2);
    PC_IMM_ALU: alu_pc_2 port map (s4, s7);
    INSTRUCTION_MEM : rom port map (s1, instruction_out);

    s7 <= imm_exec<<2;

    proc_mux_7: process(opcode_exec, branch_taken)
    begin
        if ((opcode_exec="1000" or opcode_exec="1001" or opcode_exec="1010" or opcode_exec = "1100") and branch_taken='1') then
            s2 <= "0000000000000110";
        else
            s2 <= "0000000000000010";
        end if;
    end process;
    proc_mux_12: process(opcode_exec, branch_taken, s3, reg_a_data)
    begin
        if (((opcode_exec="1000" or opcode_exec="1001" or opcode_exec="1010") and branch_taken='1')  or opcode_exec = "1100") then
            s4 <= s3;
        elsif (opcode_exec = "1111")
            s4 <= reg_a_data;
        else
            s4<='0';
        end if;
    end process;
    proc_mux_6: process(opcode_exec, branch_taken, s3, s5, reg_b_data)
    begin
        if (opcode_exec = "1101") then
            s6 <= reg_b_data;
        elsif (((opcode_exec="1000" or opcode_exec="1001" or opcode_exec="1010") and branch_taken='1')  or opcode_exec = "1100" or opcode_exec = "1111") then
            s6 <= s5;
        else
            s6<= s3;
        end if;
    end process;
end behave;