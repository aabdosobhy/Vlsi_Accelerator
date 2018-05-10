LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_dec IS

PORT( in_dec : in std_logic_vector (2 downto 0);
      out_dec: out std_logic_vector (3 downto 0));
END my_dec;

ARCHITECTURE a_my_dec OF my_dec IS
BEGIN
PROCESS (in_dec)
BEGIN
IF in_dec(2) = '0' THEN
		out_dec <= (OTHERS=>'0');
ELSIF in_dec(1 downto 0) = "00" THEN
		out_dec <= ("0001");
ELSIF in_dec(1 downto 0) = "01" THEN
		out_dec <= ("0010");
ELSIF in_dec(1 downto 0) = "10" THEN
		out_dec <= ("0100");
ELSE 
out_dec <= ("1000");
END IF;
END PROCESS;
END a_my_dec;
