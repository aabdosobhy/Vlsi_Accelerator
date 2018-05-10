LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_nDFF_fall IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END my_nDFF_fall;

ARCHITECTURE a_my_nDFF_fall OF my_nDFF_fall IS
BEGIN
PROCESS (Clk,Rst,enb)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
ELSIF falling_edge(Clk) and enb = '1' THEN
		q <= d;
END IF;
END PROCESS;
END a_my_nDFF_fall;

