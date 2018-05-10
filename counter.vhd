
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;  
entity counter is
  generic (n:integer :=2); 
  Port ( 
    xin: IN std_logic_vector(n-1 DOWNTO 0);
    rst,clk : in STD_LOGIC;
    down: in STD_LOGIC;                             
    z : out STD_LOGIC_vector( n-1 downto 0 ));
end counter;

architecture Behavioral of Counter is
  signal zint:  unsigned( n-1 downto 0 ) ; 
  signal zero:STD_LOGIC_vector( n-1 downto 0 );   
begin
  z<= std_logic_vector(zint);  
  zero<=(others=>'0');           
  zint<= unsigned(xin) when  rst ='1' 
	else zint when zint= unsigned(zero)
  else zint-1 when  down ='1' and falling_edge(clk);

end Behavioral;

