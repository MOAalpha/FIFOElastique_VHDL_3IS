--mes_composants.vhd
library ieee;
use ieee.std_logic_1164.all;
package mes_composants_data_supply is
    
component gencptr 
port (RESET1,CLK  : in std_logic;
    ENREAD : out std_logic);
end component;


component udcptrn is
     generic(n : natural :=8);
    port(ud , reset , clk, enable : in std_logic;
               q               : out std_logic_vector(n-1 downto 0));
end component;


component seq_fifo_data_supply 
    port (
        clk, reset, ack, start, fcptr: in STD_LOGIC;
        req, enable_cptr: out STD_LOGIC
    );
end component;

component rom16x8 is
    port (
        csb, OE: in STD_LOGIC;
        adr: in STD_LOGIC_VECTOR (3 downto 0);
        dataout: out STD_LOGIC_VECTOR (7 downto 0)
    );
end component;

end mes_composants_data_supply;