LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity for_write is
generic ( n : integer := 8);  

PORT( Clk,Rst,write_acc,start,size,read_ors,read_ack: in std_logic;
 data_from_cache: in std_logic_vector( n-1 downto 0);
 ram_write_en , write_ack,write_Reg :  out std_logic;
 ram_write_address: out std_logic_vector( 19 downto 0);
 RAM_DataOut: out std_logic_vector(7 downto 0)

);


end entity for_write;


architecture for_write_arch of for_write is

component my_nDFF_fall IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

component my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));

end component;

component my_DFF is 
PORT( clk,rst,en,d : IN std_logic;   q : OUT std_logic);
end component;


component mux2_1 is
		GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
end component;

signal write_Reg_temp,ram_write_en_buf,ram_write_en_temp,last_start_address_en,write_ack_temp,rst_write_reg : std_logic;

signal last_start_address_in, last_start_address_out,first_address,last_address_inc : std_logic_vector (19 downto 0);

signal case3x3_first_address : std_logic_vector (19 downto 0):= X"01009";  --- 3*3+256*256 in hex
signal case5x5_first_address : std_logic_vector (19 downto 0):= X"10019";  --- 5*5+256*256 in hex

begin


rst_write_reg <= ram_write_en_buf or  Rst;
write_Regg:my_DFF port map(Clk,rst_write_reg,write_acc,write_Reg_temp);


write_Reg<= write_Reg_temp;
	
	

ram_write_en_temp <= (read_ors xnor read_ack )and write_Reg_temp;

ram_write_en <= ram_write_en_temp;

ramWriteEnBufLabel: my_DFF port map (Clk,Rst,'1',ram_write_en_temp,ram_write_en_buf);




write_ack_temp <= ram_write_en_buf;

write_ack<=write_ack_temp;



last_start_address_en <= start or ram_write_en_buf;

muxFirstStartAddLabel: mux2_1 generic map (n=>20) port map (case5x5_first_address,case3x3_first_address,size,first_address);

last_address_inc <= std_logic_vector ((unsigned(last_start_address_out))+1);

muxChooseStartAddress: mux2_1 generic map (n=>20) port map (last_address_inc,first_address,start,last_start_address_in);

lastStartAddressRegLabel: my_nDFF generic map (n=> 20) port map (Clk,Rst,last_start_address_en, last_start_address_in, last_start_address_out);

ram_write_address <= last_start_address_out; 

out_in_dma:my_nDFF_fall generic map (n=> 8) port map(Clk,Rst,write_acc,data_from_cache,RAM_DataOut);

end for_write_arch;