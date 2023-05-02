library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfi is
    port (
        clk : in std_logic;
        reg_write : in std_logic;
        add_reg_1, add_reg_2, add_write : in std_logic_vector(2 downto 0);
        write_data : in std_logic_vector(15 downto 0);
        data_1, data_2 : out std_logic_vector(15 downto 0)
    );
end regfi;

architecture rtl_regfi of regfi is
    type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (0 => (others => '0'),1 => ("0000000000000001"),2 => ("0000000000001111"),3 => ("0000000000000011"),4 => ("0000000000000100"),5 => ("0000000000000101"),6 => ("0000000000000110"),7 => ("0000000000000111")); 
	 

begin
    data_1 <= registers(to_integer(unsigned(add_reg_1)));
    data_2 <= registers(to_integer(unsigned(add_reg_2)));
    process (clk)
    begin
        if rising_edge(clk) then
            if reg_write = '1' then
                registers(to_integer(unsigned(add_write))) <= write_data;
            end if;
        end if;
    end process;
end architecture;