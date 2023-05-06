library ieee;
use ieee.std_logic_1164.all;

entity load_hazard_detector is
    port (load_dest, reg_a, reg_b: in std_logic_vector(2 downto 0); 
        opcode_exec, opcode_rr,opcode_lm_sm: in std_logic_vector(3 downto 0);
        clk:in std_logic;
			pr3_synch_reset_lhd,pc_en, pr1_en, pr2_en: out std_logic
        );
end entity;

architecture behave of load_hazard_detector is
    signal hazard, prev_hazard : std_logic := '0';
    begin 
			
		pr3_synch_reset_lhd <= (hazard and not(prev_hazard))and not (not (opcode_lm_sm(3)) and opcode_lm_sm(2) and (opcode_lm_sm(1)));
        p1: process (clk,prev_hazard,hazard)
        begin
            if rising_edge(clk) then
                prev_hazard <= hazard;
            else 
                prev_hazard <= prev_hazard;
            end if;
        end process;

        p2:  process(prev_hazard,hazard)
        begin
            if2: if (hazard = '1' and prev_hazard='0') then
                pc_en <='0';
                pr1_en <='0';
                pr2_en <='0';
            else
                pc_en <='1';
                pr1_en <='1';
                pr2_en <='1';
            end if;
        end process;
        
        p3: process(opcode_exec, opcode_rr,load_dest,reg_a,reg_b)
        begin
            if3: if ((opcode_exec = "0100" or opcode_exec = "0011") and (opcode_rr = "0001" or opcode_rr = "0010" or opcode_rr = "1000" or opcode_rr = "1001" or opcode_rr = "1010")) then
                if (reg_a = load_dest or reg_b = load_dest) then
                    hazard <= '1';
                else
                    hazard <= '0';
                end if;

            elsif ((opcode_exec = "0100" or opcode_exec = "0011") and (opcode_rr = "0100" or opcode_rr = "1101")) then
                if (reg_b = load_dest) then
                    hazard<='1';
                else
                    hazard<='0';
                end if;

            elsif ((opcode_exec = "0100" or opcode_exec = "0011") and (opcode_rr = "1111" or opcode_rr ="0000")) then
                if (reg_a = load_dest) then
                    hazard<='1';
                else
                    hazard<='0';
                end if; 
				elsif (opcode_exec = "0100" and opcode_rr = "0101") then
					if (reg_a = load_dest or reg_b = load_dest) then
                    hazard<='1';
                else
                    hazard<='0';
                end if; 
            else
					hazard <='0';
					
            end if;
        end process;
        
end architecture;
