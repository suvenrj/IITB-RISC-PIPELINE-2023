library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity complimenter is
    Port ( Inp : in  std_logic_vector(15 downto 0);
           Outp : out std_logic_vector(15 downto 0));
end complimenter;

architecture Behav_comp of complimenter is
begin

    process(inp)
    begin
        for i in 0 to 15 loop
            outp(i) <= not Inp(i);
        end loop;
end process;

end architecture;