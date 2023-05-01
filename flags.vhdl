library ieee;
use ieee.std_logic_1164.all;

entity Carry_flag is
    port (
        clk : in std_logic;
        en : in std_logic;
        Cy_in : in std_logic;
        Cy_out : out std_logic
    );
end entity;

architecture rtl_c of carry_flag is
    signal reg_value : std_logic := '0';
begin
    process (clk, en)
    begin
        if rising_edge(clk) then
            if en = '1' then
                reg_value <= cy_in;
            end if;
        end if;
    end process;

    cy_out <= reg_value;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity zero_flag is
    port (
        clk : in std_logic;
        en : in std_logic;
        Z_in : in std_logic;
        Z_out : out std_logic
    );
end entity;

architecture rtl_c of Zero_flag is
    signal reg_value : std_logic := '0';
begin
    process (clk, en)
    begin
        if rising_edge(clk) then
            if en = '1' then
                reg_value <= z_in;
            end if;
        end if;
    end process;

    z_out <= reg_value;
end architecture;