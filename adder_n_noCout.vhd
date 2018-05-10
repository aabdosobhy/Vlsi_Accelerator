LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- n-bit adder
ENTITY my_nadder_noCout IS
       GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
	
             f : OUT std_logic_vector(n-1 DOWNTO 0)
             );
END my_nadder_noCout;


ARCHITECTURE a_my_nadder OF my_nadder_noCout IS

COMPONENT my_adder IS
	PORT( a,b,cin : IN std_logic; 
              s,cout : OUT std_logic);
END COMPONENT;
Component my_adder_noCout IS
	PORT( a,b,cin : IN std_logic;
		s: OUT std_logic); 
END component;

SIGNAL temp_carry : std_logic_vector(n-1 DOWNTO 0);
--SIGNAl a_xor : std_logic_vector(n-1 downto 0);

BEGIN
 --process(b,cin)
-- begin
--	for i in 0 to n-1 loop
--		 a_xor(i) <= a(i) xor cin;  
--	end loop;

-- end process;

  f0: my_adder PORT MAP(b(0),a(0),'0',f(0),temp_carry(0)); --cin if zero addition operation if 1 subtraction operation
  loop1: FOR i IN 1 TO n-2 GENERATE
          fx: my_adder PORT MAP(b(i),a(i),temp_carry(i-1),f(i),temp_carry(i));
    END GENERATE;
  fn: my_adder_noCout port map (b(n-1),a(n-1),temp_carry(n-2),f(n-1));

END a_my_nadder;



