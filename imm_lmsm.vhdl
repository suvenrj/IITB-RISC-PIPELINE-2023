library ieee;
use ieee.std_logic_1164.all;

entity imm_lmsm is
    port (
        data_in  : in  std_logic_vector(2 downto 0);
        clk      : in  std_logic;
        reset    : in  std_logic;
        data_out : out std_logic_vector(2 downto 0)
    );
end entity;

architecture behavioral_lm_sm of imm_lmsm is
    signal reg : std_logic_vector(2 downto 0) := (others => '0');
begin
    process (clk, reset,reg)
    begin
        if rising_edge(clk) then
		      if reset = '0' then
				    reg <= data_in;
				else
					 reg <= (others => '0');
			   end if;
        else
            reg <= reg;
        end if;
    end process;
    data_out <= reg;
end architecture;