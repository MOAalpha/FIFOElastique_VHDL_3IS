--------------------------------------------------------------------
-- genadr_tb.vhd
-- Testbench du générateur d'adresse
-- Auteurs : GHERRAS Mohammed-Amine, BOUIDDOUH Fayçal
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity genadr_tb is
end genadr_tb;
 
architecture test of genadr_tb is
 
  constant M : natural := 4;
  constant T : time := 100 ns;               -- période de 10 MHz
 
  signal Reset    : std_logic := '1';
  signal CLK      : std_logic := '0';
  signal incread  : std_logic := '0';
  signal incwrite : std_logic := '0';
  signal selread  : std_logic := '0';
  signal Adrg     : std_logic_vector(M-1 downto 0);
  signal fin      : boolean := false;
 
begin
 
  -- Instanciation directe de l'entité (pas besoin de déclarer le composant)
  DUT : entity work.genadr
    generic map (M => M)
    port map (Reset => Reset, CLK => CLK, incread => incread,
              incwrite => incwrite, selread => selread, Adrg => Adrg);
 
  -- Horloge
  CLK <= not CLK after T/2 when not fin;
 
  -- Scénario : les entrées changent sur front descendant,
  -- les compteurs échantillonnent sur front montant
  stimuli : process
  begin
    -- Reset
    Reset <= '1';
    wait for 2*T;
    wait until falling_edge(CLK);
    Reset <= '0';
 
    -- Test 1 : après reset, les deux adresses valent 0
    selread <= '0';
    wait for 10 ns;
    assert to_integer(unsigned(Adrg)) = 0
      report "Test 1a : adresse d'ecriture differente de 0 apres reset" severity error;
    selread <= '1';
    wait for 10 ns;
    assert to_integer(unsigned(Adrg)) = 0
      report "Test 1b : adresse de lecture differente de 0 apres reset" severity error;
 
    -- Test 2 : 3 impulsions incwrite -> adresse d'ecriture = 3, lecture inchangee
    selread <= '0';
    for i in 1 to 3 loop
      wait until falling_edge(CLK);
      incwrite <= '1';
      wait until falling_edge(CLK);
      incwrite <= '0';
    end loop;
    wait for 10 ns;
    assert to_integer(unsigned(Adrg)) = 3
      report "Test 2a : adresse d'ecriture attendue = 3" severity error;
    selread <= '1';
    wait for 10 ns;
    assert to_integer(unsigned(Adrg)) = 0
      report "Test 2b : adresse de lecture attendue = 0" severity error;
 
    -- Test 3 : 2 impulsions incread -> adresse de lecture = 2, ecriture inchangee
    for i in 1 to 2 loop
      wait until falling_edge(CLK);
      incread <= '1';
      wait until falling_edge(CLK);
      incread <= '0';
    end loop;
    wait for 10 ns;
    assert to_integer(unsigned(Adrg)) = 2
      report "Test 3a : adresse de lecture attendue = 2" severity error;
    selread <= '0';
    wait for 10 ns;
    assert to_integer(unsigned(Adrg)) = 3
      report "Test 3b : adresse d'ecriture attendue = 3" severity error;
 
    -- Test 4 : debordement circulaire, 13 ecritures de plus -> 16 = 0
    for i in 1 to 13 loop
      wait until falling_edge(CLK);
      incwrite <= '1';
      wait until falling_edge(CLK);
      incwrite <= '0';
    end loop;
    wait for 10 ns;
    assert to_integer(unsigned(Adrg)) = 0
      report "Test 4 : l'adresse d'ecriture devait revenir a 0" severity error;
 
    report "Fin de la simulation de genadr" severity note;
    fin <= true;
    wait;
  end process;
 
end test;
