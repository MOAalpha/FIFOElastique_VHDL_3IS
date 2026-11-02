--
--  seq_fifo_data_supply.vhd
--  
--
library IEEE;
use IEEE.std_logic_1164.all;


entity seq_fifo_data_supply is
    port (
        clk, reset, ack, start, fcptr: in STD_LOGIC;
        req, enable_cptr: out STD_LOGIC
    );
end seq_fifo_data_supply;

architecture seq_fifo_data_supply of seq_fifo_data_supply is
type etat is (repos, ecriture, att_ack, att_cptr);
  signal etat_present : etat;
begin
process(clk, reset)
  begin
    if reset = '1' then etat_present <= repos;
    else
      if clk = '1' and clk'event then
        case etat_present is
        when repos => if start = '0' then etat_present <= ecriture;
                      else etat_present <= repos;
                      end if;
        when ecriture => if ack = '0' then etat_present <= att_ack;
                        else etat_present <= ecriture;
                          end if;
        when att_ack => if ack = '0' then etat_present <= att_ack;
                        else etat_present <= att_cptr; 
                          end if;
        when att_cptr => if fcptr = '0' then etat_present <= att_cptr;
                        else etat_present <= ecriture;
                        end if; 
      end case;
    end if;
  end if;
end process;
req <= '0' when etat_present = ecriture or etat_present = att_ack else '1';
enable_cptr <= '0' when etat_present = ecriture  else '1';
                                         
end seq_fifo_data_supply;