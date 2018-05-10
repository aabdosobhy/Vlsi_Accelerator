LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity img_address is 

port (Clk,Rst,read_wind_acc,ack_F,ack_Img,stride,size : in std_logic;
upc_out : in std_logic_vector (19 downto 0);

upc_Img_address : out std_logic_vector( 19 downto 0);
last_start_address : out std_logic_vector(19 downto 0)

);


end entity img_address;

architecture img_address_arch of img_address is


component mux8x1 is
GENERIC ( n : integer := 16); 
		PORT (in0,in1,in2,in3,in4,in5,in6,in7 : IN std_logic_vector(n-1 DOWNTO 0);
                    s0,s1,s2	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;
 
component my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));

end component;


component mux2_1 is
		GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
end component;

component and_vector is 
generic ( n : integer := 8); 
port ( input: std_logic_vector( n-1 downto 0);

output : out std_logic



);
end component;

signal last_start_address_in,last_start_address_plus1,last_start_address_plus3,last_start_address_plus5,
last_start_address_plus2,last_start_address_plus3plus256,last_start_address_plus5plus256,last_start_address_out,upc_plus256 : std_logic_vector(19 downto 0);

signal address_276 : std_logic_vector (8 downto 0) := "001010001";
signal address_262 : std_logic_vector (8 downto 0) := "011000001";

signal islast_address_276,islast_address_262 : std_logic_vector(8 downto 0);
signal mid,least,least_selmux,mid_selmux,last_address_en : std_logic;

begin


last_start_address_plus1 <= std_logic_vector(unsigned(last_start_address_out)+1);
last_start_address_plus3 <= std_logic_vector(unsigned(last_start_address_out)+3);
last_start_address_plus5 <= std_logic_vector(unsigned(last_start_address_out)+5);
last_start_address_plus2 <= std_logic_vector(unsigned(last_start_address_out)+2);
last_start_address_plus3plus256 <=  std_logic_vector(unsigned(last_start_address_plus3)+1);
last_start_address_plus5plus256 <=  std_logic_vector(unsigned(last_start_address_plus5)+1);





mux8: mux8x1 generic map (n=>20) port map (last_start_address_plus1,last_start_address_plus3,last_start_address_plus5,upc_out,
						last_start_address_plus2,last_start_address_plus3plus256,last_start_address_plus5plus256,
						upc_out,least_selmux,mid_selmux,stride,last_start_address_in);

islast_address_276 <=  last_start_address_in(8 downto 0) xnor address_276;
islast_address_262 <= last_start_address_in (8 downto 0) xnor address_262;

midlabel: and_vector  generic map (n=>9) port map (islast_address_276,mid);

leastlabel: and_vector generic map (n=>9) port map (islast_address_262,least);

least_selmux <= (least and not (size)) or ack_F;
mid_selmux <= (mid and size) or ack_F;

last_address_en <= ack_F  or ack_Img;
lastAddressLabel :  my_nDFF generic map (n=>20) port map (Clk,Rst,last_address_en,last_start_address_in,last_start_address_out);

upc_plus256 <= std_logic_vector((unsigned(upc_out)+256)); 
mux6:  mux2_1 generic map (n=>20) port map (upc_plus256,last_start_address_out,read_wind_acc,upc_Img_address);

last_start_address <= last_start_address_out;

end img_address_arch;