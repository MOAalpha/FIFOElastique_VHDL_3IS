--------------------------------------------------------------------
-- fastslow_tb.vhd
-- Testbench du module fastslow, valable pour toute valeur de M >= 2
-- Auteurs : GHERRAS Mohammed-Amine, BOUIDDOUH Fayçal
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fastslow_tb is
end fastslow_tb;

architecture test of fastslow_tb is

  constant M : natural := 10;                 -- seule valeur a changer
  constant T : time := 100 ns;               -- periode de 10 MHz

  -- Seuils calcules a partir de M (aucune valeur en dur)
  constant SEUIL_FAST : natural := 2**(M-2);              -- fast = 1 si nb mots < SEUIL_FAST
  constant SEUIL_SLOW : natural := 2**M - 2**(M-2);       -- slow = 1 si nb mots >= SEUIL_SLOW
  constant NB_MAX     : natural := 2**M - 1;              -- plus grande valeur du compteur

  signal Reset    : std_logic := '1';
  signal CLK      : std_logic := '0';
  signal incread  : std_logic := '0';
  signal incwrite : std_logic := '0';
  signal fast     : std_logic;
  signal slow     : std_logic;
  signal fin      : boolean := false;

begin

  DUT : entity work.fastslow
    generic map (M => M)
    port map (Reset => Reset, CLK => CLK, incread => incread,
              incwrite => incwrite, fast => fast, slow => slow);

  -- Horloge, arretee a la fin du scenario
  CLK <= not CLK after T/2 when not fin;

  stimuli : process

    -- n impulsions incwrite (1 par cycle d'horloge, suivies d'un cycle a 0)
    procedure ecrire (n : natural) is
    begin
      for i in 1 to n loop
        wait until falling_edge(CLK);
        incwrite <= '1';
        wait until falling_edge(CLK);
        incwrite <= '0';
      end loop;
    end procedure;

    -- n impulsions incread
    procedure lire (n : natural) is
    begin
      for i in 1 to n loop
        wait until falling_edge(CLK);
        incread <= '1';
        wait until falling_edge(CLK);
        incread <= '0';
      end loop;
    end procedure;

    -- verification des valeurs de fast et slow
    procedure verifier (exp_fast, exp_slow : std_logic; msg : string) is
    begin
      wait for 10 ns;
      assert fast = exp_fast
        report msg & " : fast incorrect" severity error;
      assert slow = exp_slow
        report msg & " : slow incorrect" severity error;
    end procedure;

  begin
    -- Reset : FIFO vide
    Reset <= '1';
    wait for 2*T;
    wait until falling_edge(CLK);
    Reset <= '0';
    verifier('1', '0', "0 mot (apres reset)");

    -- Montee : ecritures
    ecrire(SEUIL_FAST - 1);
    verifier('1', '0', "SEUIL_FAST - 1 mots");      -- encore fast
    ecrire(1);
    verifier('0', '0', "SEUIL_FAST mots");          -- fast retombe
    ecrire(SEUIL_SLOW - 1 - SEUIL_FAST);
    verifier('0', '0', "SEUIL_SLOW - 1 mots");      -- zone normale
    ecrire(1);
    verifier('0', '1', "SEUIL_SLOW mots");          -- slow monte
    ecrire(NB_MAX - SEUIL_SLOW);
    verifier('0', '1', "NB_MAX mots");

    -- Descente : lectures
    lire(NB_MAX - SEUIL_SLOW);
    verifier('0', '1', "SEUIL_SLOW mots (descente)");      -- encore slow
    lire(1);
    verifier('0', '0', "SEUIL_SLOW - 1 mots (descente)");  -- slow retombe
    lire(SEUIL_SLOW - 1 - SEUIL_FAST);
    verifier('0', '0', "SEUIL_FAST mots (descente)");
    lire(1);
    verifier('1', '0', "SEUIL_FAST - 1 mots (descente)");  -- fast remonte

    -- Maintien : sans incwrite ni incread, le compteur ne bouge pas
    wait for 5*T;
    verifier('1', '0', "apres 5 cycles sans activite");
    ecrire(1);
    verifier('0', '0', "SEUIL_FAST mots (prouve que le compteur etait fige)");

    report "Fin de la simulation de fastslow" severity note;
    fin <= true;
    wait;
  end process;

end test;