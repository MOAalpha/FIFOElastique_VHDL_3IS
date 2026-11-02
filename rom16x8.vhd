--
--  Rom 16x8
--  
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity rom16x8 is
    port (
        csb, OE: in STD_LOGIC;
        adr: in STD_LOGIC_VECTOR (3 downto 0);
        dataout: out STD_LOGIC_VECTOR (7 downto 0)
    );
end rom16x8;

architecture rom16x8 of rom16x8 is
type memo is array (0 to 15) of std_logic_vector(0 to 7);
constant rom : memo := 
("00000000", "00000001", "00000010", "00000011", 
 "00000100", "00000101", "00000110", "00000111",
 "00001000", "00001001", "00001010", "00001011",
 "00001100", "00001101", "00001110", "00001111");
						
begin
dataout <= rom (conv_integer(adr)) 
                when (csb='0'and OE='1') else "ZZZZZZZZ";
end rom16x8;
