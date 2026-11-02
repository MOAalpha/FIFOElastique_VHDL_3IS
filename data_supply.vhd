--
--  data_supply.vhd
--  
--
library IEEE;
use IEEE.std_logic_1164.all;
use work.mes_composants_data_supply.all;


entity data_supply is
    port (
        clk, reset, ack, start: in STD_LOGIC;
        req: out STD_LOGIC;
        data_out : out std_logic_vector(7 downto 0)
    );
end data_supply;

architecture data_supply of data_supply is
signal sig_adr : std_logic_vector(3 downto 0);
signal sig_E, fcptr : std_logic;

begin
  
  U_rom : rom16x8 port map ('0', '1', sig_adr, data_out);
  U_genadrom : udcptrn generic map(4) port map('1', reset, clk, sig_E, sig_adr);
  U_genfcptr : gencptr  port map( reset, clk, fcptr);
  U_seq : seq_fifo_data_supply port map (clk, reset, ack, start, fcptr, req, sig_E); 
  
end data_supply;
  