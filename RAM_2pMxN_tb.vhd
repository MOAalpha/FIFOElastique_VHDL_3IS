--RAM_2pMxN_tb.vhd
--GHERRAS Mohammed-Amine
--BOUIDDOUH Faycal
-- Seance1 7-10-2026

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_RAM_2pMxN is
end entity;

architecture sim of tb_RAM_2pMxN is
	signal OE   : std_logic := '0';
	signal SC_n : std_logic := '1';
	signal RW_n : std_logic := '1';
	signal addr : std_logic_vector(3 downto 0) := "0000";
	signal Din  : std_logic_vector(7 downto 0) := x"00";
	signal Dout : std_logic_vector(7 downto 0);
begin

	uut : entity work.RAM_2pMxN
		generic map (M => 4, N => 8)
		port map (
			OE   => OE,
			Din  => Din,
			SC_n => SC_n,
			RW_n => RW_n,
			addr => addr,
			Dout => Dout
		);

	process
	begin
		wait for 20 ns;

		-- ===== ECRITURE 1 : AA a l'adresse 1 =====
		SC_n <= '0';
		OE   <= '0';
		addr <= "0001";
		Din  <= x"AA";
		wait for 5 ns;
		RW_n <= '0';          -- ecriture
		wait for 10 ns;       -- Dout doit etre en Z
		RW_n <= '1';          -- fin d'ecriture
		wait for 5 ns;

		-- ===== ECRITURE 2 : 55 a l'adresse 5 =====
		addr <= "0101";
		Din  <= x"55";
		wait for 5 ns;
		RW_n <= '0';
		wait for 10 ns;
		RW_n <= '1';
		wait for 5 ns;

		-- ===== ECRITURE 3 : 3C a l'adresse 15 =====
		addr <= "1111";
		Din  <= x"3C";
		wait for 5 ns;
		RW_n <= '0';
		wait for 10 ns;
		RW_n <= '1';
		wait for 5 ns;

		-- ===== LECTURES (ordre different) =====
		OE   <= '1';
		addr <= "1111";       -- doit afficher 3C
		wait for 10 ns;
		addr <= "0001";       -- doit afficher AA
		wait for 10 ns;
		addr <= "0101";       -- doit afficher 55
		wait for 10 ns;

		-- ===== HAUTE IMPEDANCE =====
		OE <= '0';            -- OE inactif : Dout en Z
		wait for 10 ns;
		OE   <= '1';
		SC_n <= '1';          -- memoire non selectionnee : Dout en Z
		wait for 10 ns;

		wait;
	end process;

end architecture;