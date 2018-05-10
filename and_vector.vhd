LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

entity and_vector is 

generic ( n : integer := 8); 
port ( input: std_logic_vector( n-1 downto 0);

output : out std_logic



);


end entity and_vector;


ARCHITECTURE and_vector_a of and_vector is 


begin 
output <= and_reduce(input);

end and_vector_a;
