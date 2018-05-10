LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity mux8x1 is
GENERIC ( n : integer := 16); 
		PORT (in0,in1,in2,in3,in4,in5,in6,in7 : IN std_logic_vector(n-1 DOWNTO 0);
                    s0,s1,s2	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END ENTITY mux8x1;


ARCHITECTURE mux8x1_a OF mux8x1 IS
BEGIN
     
   out1 <=  in0 when s2 ='0' and s1='0' and s0='0'
      	else in1 when s2 ='0' and s1='0' and s0='1' 
	else in2 when s2 ='0' and s1='1' and s0='0'
	else in3 when s2 ='0' and s1='1' and s0='1'
	else in4 when s2 ='1' and s1='0' and s0='0'
	else in5 when s2 ='1' and s1='0' and s0='1'
	else in6 when s2 ='1' and s1='1' and s0='0'
	else in7;


     
END mux8x1_a;