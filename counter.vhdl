library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity counter is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
			  en : in std_logic;
           start : in  std_logic;
           count : out std_logic_vector(2 downto 0);
			  max_count : in integer range 0 to 8;
           --tf : out std_logic;   -- not need till now so disabled; undo all tf comments to enable it
			  temp_en : out std_logic);
end entity;
-------------------------------------INITAIL COUNT IS SET AT 1 and then it goes 1->2->3->4->5->6->7  thes are the 7 values it has because we want seven extra cycles.
architecture archi of counter is
    signal temp_count : unsigned(2 downto 0) := "000";
    --signal temp_tf : std_logic := '1';
	 signal count_sig : std_logic_vector(2 downto 0);
    signal started : std_logic := '0';
begin
    process (clk, reset,en)
    begin
        if (reset = '1') then
            temp_count <= "000";
            --temp_tf <= '1';
            started <= '0';
        elsif (rising_edge(clk) and en = '1') then
            if (start = '1' and started = '0') then
                temp_count <= ("001");
                --temp_tf <= '0';
                started <= '1';
            elsif (started = '1') then
                if (temp_count = max_count-1) then
                    temp_count <= ("000");
                    --temp_tf <= '1';
                    started <= '0';
                else
                    temp_count <= temp_count + 1;
                    --temp_tf <= '0';
                end if;
            end if;
        end if;
    end process;
    count_sig <= std_logic_vector(temp_count);
    count <= count_sig;
	 temp_en <= not(count_sig(0) or count_sig(1) or (count_sig(2)));
	 --tf <= temp_tf;
end archi;
