--------------------------------------------------------------------
-- dcpt_m.vhd
-- Compteur/décompteur M bits, reset synchrone, entrée de validation
-- Auteurs : GHERRAS Mohammed-Amine, BOUIDDOUH Fayçal
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity DCPT_M is
  generic (M : natural := 4);                -- nombre de bits du compteur
  port (
    ENABLE : in  std_logic;                  -- validation du comptage
    UD     : in  std_logic;                  -- '1' : compte, '0' : décompte
    RESET  : in  std_logic;                  -- reset synchrone
    CLK    : in  std_logic;
    CPTR   : out std_logic_vector(M-1 downto 0)
  );
end DCPT_M;
 
architecture archi_dcpt_m of DCPT_M is
  signal cpt : unsigned(M-1 downto 0) := (others => '0');
begin
 
  process (CLK, RESET)
  begin
    if rising_edge(CLK) then
      if RESET = '1' then                    -- reset synchrone, prioritaire
        cpt <= (others => '0');
      elsif ENABLE = '1' then
        if UD = '1' then
          cpt <= cpt + 1;                    -- repasse à 0 après 2^M - 1
        else
          cpt <= cpt - 1;                    -- repasse à 2^M - 1 après 0
        end if;
      end if;                                -- sinon : garde sa valeur
    end if;
  end process;
 
  CPTR <= std_logic_vector(cpt);
 
end archi_dcpt_m;
