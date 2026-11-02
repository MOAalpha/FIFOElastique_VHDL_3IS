--RAM_2pMxN.vhd
--GHERRAS Mohammed-Amine
--BOUIDDOUH Faycal
-- Séance1 7-10-2026


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity RAM_2pMxN is
	generic(
		M : natural := 4;
		N : natural := 8
	);
	port(
		OE : in std_logic; --Output Enable
		Din : in std_logic_vector(N-1 downto 0); 
		SC_n : in std_logic; --Chip Select, actif a 0
		RW_n : in std_logic; --Read Write, 0 = write, 1 = read
		addr : in std_logic_vector(M-1 downto 0) := (others => '0');
		Dout : out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture rtl of RAM_2pMxN is
	-- Creation de la RAM : 
	type ram_type is array (0 to 2**M-1) of std_logic_vector(N-1 downto 0);
	signal RAM : ram_type;
	--:= (others => (others => '0'));
	
	begin
		process(SC_n, addr, OE, Din, RW_n, RAM)
		begin
			if SC_n = '0' then
				if RW_n = '1' then --Lecture
					if OE = '1' then --Verification output enable
						Dout <= RAM(to_integer(unsigned(addr))); --transforme l'adresse en indice
					else
						Dout <= (others =>'Z');
					end if;
				elsif RW_n = '0' then --Ecriture
					RAM(to_integer(unsigned(addr))) <=  Din;
					Dout <= (others => 'Z');
				else
					Dout <= (others => 'Z'); --Erreur detection
				end if;
			else --SC_n different de zero : mémoire non valide
				Dout <= (others => 'Z');
			end if;
		end process;
	end architecture;