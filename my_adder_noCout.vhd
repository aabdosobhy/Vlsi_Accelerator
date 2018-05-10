
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- single bit adder
ENTITY my_adder_noCout IS
		PORT( a,b,cin : IN std_logic;
		      s: OUT std_logic); 
END my_adder_noCout;

ARCHITECTURE a_my_adder_noCout OF my_adder_noCout IS
BEGIN
     PROCESS (a,b,cin)
     BEGIN
              s <= a XOR b XOR cin;
              
     END PROCESS;
END a_my_adder_noCout;

