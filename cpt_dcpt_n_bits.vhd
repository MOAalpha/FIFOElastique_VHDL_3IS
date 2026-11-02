library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;
    entity udcptrn is
        generic(n : natural :=8);
        port(ud , reset , clk , enable : in std_logic;
               q               : out std_logic_vector(n-1 downto 0));
   end udcptrn ;
   architecture comp of udcptrn is
   signal tmp : std_logic_vector(n-1 downto 0);
   begin
            q<=tmp;
process(clk)
begin
    if clk='1' and clk'event then
       if reset = '1' then  for i in 0 to n-1 loop
                     tmp(i) <= '0';
                   end loop;  
      else
            if enable ='1' then
               if ud='1' then tmp <= tmp + conv_std_logic_vector(1,n);
               elsif ud='0' then tmp <= tmp - conv_std_logic_vector(1,n); 
               
               end if;
            else tmp<= tmp;
            end if ;
      
      end if; 
end if;  
end process;
end comp;


