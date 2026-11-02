library ieee;
use ieee.std_logic_1164.all;
use work.mes_composants.all;

entity gencptr is 
port (RESET1,CLK  : in std_logic;
    ENREAD : out std_logic);
end gencptr;
    
 architecture gencptr of gencptr is
 signal S_CPTR : std_logic_vector(3 downto 0);
 signal tmp : std_logic;
 signal reset : std_logic;
 
 
 begin
 cpt4b : udcptrn generic map(4)
                 port map('1' , RESET,CLK,'1',S_CPTR);
  
  
  tmp <= '1' when S_CPTR="1100" else '0';  
  ENREAD <= tmp;
  
  RESET <= RESET1 or tmp;                 
 
 
 end gencptr;
                    

    
    
