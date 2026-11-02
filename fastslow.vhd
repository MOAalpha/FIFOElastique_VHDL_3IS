--------------------------------------------------------------------
-- fastslow.vhd
-- Indicateur FIFO presque vide, ou presque pleine
-- Auteurs : GHERRAS Mohammed-Amine, BOUIDDOUH Fayçal
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity fastslow is 
	generic (M: natural :=4);
	port(
	Reset : in std_logic;
	CLK : in std_logic;
	incread : in std_logic;
	incwrite : in std_logic;
	fast : out std_logic;
	slow : out std_logic
	);
end fastslow;

architecture archi_fastslow of fastslow is
	signal cptr_s : std_logic_vector(M-1 downto 0);
	signal enable_s: std_logic;
	
begin
	enable_s <= incread or incwrite; --s'active s'il y a eu une ecriture ou une lecture
	fifo_size : entity work.dcpt_m
	generic map (M => M)
	port map (
		ENABLE => enable_s,
		UD => incwrite, --la taille augmente quand on écrit, baisse quand on lit (mais on suppose incwrite et incread complémentaire).
		RESET => Reset,
		CLK => CLK,
		CPTR => cptr_s
	);

	fast <= cptr_s(M-1) nor cptr_s(M-2);
	slow <= cptr_s(M-1) and cptr_s(M-2);
end architecture;