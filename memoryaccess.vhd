library ieee;
use ieee.std_logic_1164.all;

entity memoryaccess is 
    port (clock,write_en_in: in std_logic; add_in, ra_value :in std_logic_vector(15 downto 0);data_out : out std_logic_vector(15 downto 0); opcode: in std_logic_vector(3 downto 0));
end entity;

architecture beh of memoryaccess is 

    component Memory is 
        port ( WE  : in std_logic; clock  : in std_logic; Address   : in std_logic_vector(15 downto 0); d_in  : in std_logic_vector(15 downto 0); d_out  : out std_logic_vector(15 downto 0));  
    end component; 

    signal temp_data: std_logic_vector(15 downto 0);

    begin
        ram1: Memory port map(write_en_in,clock, add_in ,ra_value, temp_data);

        proc1 : process(temp_data, add_in)     --in case of load, add_in acts as memory addres
        begin
            if(opcode = "0100") then
            -- LM 0110
                data_out <= temp_data;
            else
                data_out <= add_in;   -- in cases apart from load, add_in is simply data
            end if;
        end process;


end beh;
