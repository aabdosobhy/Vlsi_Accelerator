LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(8 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 511) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type := (
   --0     => X"6400",
   --1     => X"0004",
   --2     => X"6401",
   --3     => X"0007",
   --4     => X"2008",
   --5     => X"0c01",
   --6   => X"2224",
   --7   => X"0c00",
   --8   => X"2000",
  --509     => X"0006",
  --510     => X"0007",
   --511     => X"0008",
  OTHERS => X"0000"
);

	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END syncrama;

