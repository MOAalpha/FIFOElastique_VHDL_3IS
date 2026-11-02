--------------------------------------------------------------------
-- genadr.vhd
-- Générateur d'adresse de la FIFO élastique
-- Auteurs : GHERRAS Mohammed-Amine, BOUIDDOUH Fayçal
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity genadr is
  generic (M : natural := 4);                 -- taille du bus d'adresse (2^M mots)
  port (
    Reset    : in  std_logic;
    CLK      : in  std_logic;
    incread  : in  std_logic;                 -- avance le pointeur de lecture
    incwrite : in  std_logic;                 -- avance le pointeur d'écriture
    selread  : in  std_logic;                 -- choix de l'adresse envoyée à la RAM
    Adrg     : out std_logic_vector(M-1 downto 0)
  );
end genadr;

architecture archi_genadr of genadr is

  -- Déclaration du compteur-décompteur (noms des ports d'après la figure 6 :
  -- à adapter à votre propre DCPT_M, ou à récupérer dans votre package)
  component DCPT_M
    generic (M : natural := 4);
    port (
      ENABLE : in  std_logic;
      UD     : in  std_logic;
      RESET  : in  std_logic;
      CLK    : in  std_logic;
      CPTR   : out std_logic_vector(M-1 downto 0)
    );
  end component;

  -- Signaux internes : sorties des deux compteurs
  signal adr_read  : std_logic_vector(M-1 downto 0);
  signal adr_write : std_logic_vector(M-1 downto 0);

begin

  -- Compteur des adresses de lecture (comptage seulement : UD = '1')
  U_CPT_READ : DCPT_M
    generic map (M => M)
    port map (ENABLE => incread, UD => '1', RESET => Reset,
              CLK => CLK, CPTR => adr_read);

  -- Compteur des adresses d'écriture
  U_CPT_WRITE : DCPT_M
    generic map (M => M)
    port map (ENABLE => incwrite, UD => '1', RESET => Reset,
              CLK => CLK, CPTR => adr_write);

  -- Multiplexeur 2 vers 1 (instruction concurrente, pas besoin de composant)
  -- Convention choisie ici : selread = '1' -> adresse de lecture
  Adrg <= adr_read when selread = '1' else adr_write;

end archi_genadr;