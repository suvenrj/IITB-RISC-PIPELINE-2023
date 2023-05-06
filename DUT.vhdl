-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(1 downto 0);
       	output_vector: out std_logic_vector(17 downto 0));
end entity;

architecture DutWrap of DUT is

component IITB_RISC is
    port(clk, reset:in std_logic;dummy:out std_logic_vector(15 downto 0);cy_data,z_data:out std_logic);
end component;


begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: IITB_RISC
			port map (
					-- order of inputs B A
					
					reset => input_vector(1),
					clk => input_vector(0),
					
					
					
               -- order of output OUTPUT
					dummy => output_vector(17 downto 2),
					cy_data=>output_vector(1),
					z_data=>output_vector(0)
					
					);
end DutWrap;