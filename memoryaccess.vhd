library ieee;
use ieee.std_logic_1164.all;

entity memoryaccess is 
    port (clock,write_en_in: in std_logic;instruction_in,data_in,add_in,data_imm_in:std_logic_vector(15 downto 0); instruction_out,data_out,data_imm_out : out std_logic_vector(15 downto 0));
end entity;

architecture beh of memoryaccess is 

    component Memory is 
        port ( WE  : in std_logic; clock  : in std_logic; Address   : in std_logic_vector(15 downto 0); d_in  : in std_logic_vector(15 downto 0); d_out  : out std_logic_vector(15 downto 0));  
    end component; 

    signal temp_data: std_logic_vector(15 downto 0);

    begin
        ram1: Memory port map(write_en_in,clock,add_in,data_in,temp_data);

        proc1 : process(temp_data)
        begin
            if(instruction_In(15 downto 12) = "0100") then
            -- LM 0110
                data_out <= temp_data;
            else
                data_out <= data_in;
            end if;
        end process;


end beh;

