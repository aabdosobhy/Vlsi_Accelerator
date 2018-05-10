LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity mux8x1 is 
	generic (n : integer :=16);
	port(ip1,ip2,ip3,ip4,ip5,ip6,ip7,ip8 : in std_logic_vector( n-1 downto 0 );
	     sel1,sel2,sel3 : in std_logic;
	     op : out std_logic_vector( n-1 downto 0 ));
end entity mux8x1;

architecture a_mux8x1 of mux8x1 is 
	component mux2_1 is
		generic ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0)); 
		     
	end component;
signal x0,x1,x2,x3,x4,x5 : std_logic_vector(n-1 downto 0);
begin 
        u0: mux2_1 generic map(n=>32) PORT MAP (ip1,ip2,sel1,x0);
	u1: mux2_1 generic map(n=>32) PORT MAP (ip3,ip4,sel1,x1);
	u2: mux2_1 generic map(n=>32) PORT MAP (ip5,ip6,sel1,x2);
	u3: mux2_1 generic map(n=>32) PORT MAP (ip7,ip8,sel1,x3);
	u4: mux2_1 generic map(n=>32) PORT MAP (x0,x1,sel2,x4);
	u5: mux2_1 generic map(n=>32) PORT MAP (x2,x3,sel2,x5);
	u6: mux2_1 generic map(n=>32)PORT MAP (x4,x5,sel3,op);




end a_mux8x1;