library ieee;
use ieee.std_logic_1164.all;

entity memoryaccess is 
    port (pr5_reset, clk: in std_logic;pr4:std_logic_vector(54 downto 0);
    pr5_en: in std_logic;mem_stage_out: out std_logic_vector(19 downto 0);
    macc_data:out std_logic_vector(15 downto 0);
    macc_dest:out std_logic_vector(2 downto 0);
    rf_wr_ma_en:out std_logic);
end entity;

architecture beh_mem of memoryaccess is 

    component Memory is 
        port ( WE  : in std_logic; clock  : in std_logic; Address   : in std_logic_vector(15 downto 0); d_in  : in std_logic_vector(15 downto 0); d_out  : out std_logic_vector(15 downto 0));  
    end component; 

    component mux4x1_16 is
        port(I00,I01,I10,I11: in std_logic_vector(15 downto 0);
             S0: in std_logic_vector(1 downto 0);
            I_out:out std_logic_vector(15 downto 0));
    end component;
    
    component pr5 is
        port(clk: in std_logic;
            data_in : in std_logic_vector(15 downto 0); 
            
            rf_write_en : in std_logic;
            dest_reg: in std_logic_vector(2 downto 0);	
            
            pr5_wr_en: in std_logic;
            reset: in std_logic;
            pr5_out: out std_logic_vector(19 downto 0)
        ); 
    
    end component;

    signal mem_data,m5_out: std_logic_vector(15 downto 0);

    begin
        rf_wr_ma_en<=pr4(19);
        ram1: Memory port map(pr4(20),clk, pr4(15 downto 0) , pr4(54 downto 39), mem_data);

        M5: mux4x1_16
        port map(pr4(15 downto 0),pr4(15 downto 0),mem_data,pr4(38 downto 23),pr4(22 downto 21),m5_out);

        pr5_reg :pr5
        port map(clk,m5_out,pr4(19),pr4(18 downto 16),pr5_en,pr5_reset, mem_stage_out);

        macc_data<=m5_out;
        macc_dest<=pr4(18 downto 16);
        


end architecture;
