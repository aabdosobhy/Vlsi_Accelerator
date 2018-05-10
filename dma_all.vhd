LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity dma_all is 
	Generic (n : integer :=8);
port ( clk,rst,start,size,stride,readIAcc,readFAcc,write_acc : in std_logic;
	RAM_DataIn: in std_logic_vector(39 downto 0);
        data_from_cache: in std_logic_vector( n-1 downto 0);
        done,RAM_En,FAck,IAck,write_ack,Ors_F:out std_logic;
        RAM_Address: out std_logic_vector(19 downto 0);
	RAM_DataOut: out std_logic_vector(7 downto 0);
       outputpixel1,outputpixel2,outputpixel3,outputpixel4,outputpixel5 : OUT std_logic_vector(n-1 DOWNTO 0);
       counter_delayed:OUT std_logic_vector(2 DOWNTO 0));
end dma_all;

architecture dma_all_a of dma_all is 

component img_address is 

port (Clk,Rst,read_wind_acc,ack_F,ack_Img,stride,size : in std_logic;
upc_out : in std_logic_vector (19 downto 0);

upc_Img_address : out std_logic_vector( 19 downto 0);
last_start_address : out std_logic_vector(19 downto 0)


);

end component;

component dma IS 
GENERIC ( n : integer := 8); 
		PORT (	Clk,hardRst,readIAcc,readFAcc ,
		            size:IN std_logic;	
		            inputpixel1,inputpixel2,inputpixel3,inputpixel4,inputpixel5: IN std_logic_vector(n-1 DOWNTO 0);
		            imgAdd,lastWrAdd  : in std_logic_vector(19 DOWNTO 0);
		            ramAddrBus  : OUT std_logic_vector(19 DOWNTO 0);
			    outputpixel1,outputpixel2,outputpixel3,outputpixel4,outputpixel5 : OUT std_logic_vector(n-1 DOWNTO 0); 
			    FAck,IAck,readORs_out,Ors_F: OUT std_logic;
                            counter_delayed:OUT std_logic_vector(2 DOWNTO 0));       
END component;

component for_write is
PORT( Clk,Rst,write_acc,start,size,read_ors,read_ack: in std_logic;
 data_from_cache: in std_logic_vector( n-1 downto 0);
 ram_write_en , write_ack,write_Reg :  out std_logic;
 ram_write_address: out std_logic_vector( 19 downto 0);
 RAM_DataOut: out std_logic_vector(7 downto 0)

);


end component;

component pre_read_and_done is 

port (Clk,Rst,read_Img_bgd_bgd,write_reg,write_ack: in std_logic;
    last_start_address : in std_logic_vector(19 downto 0);
counter_delayed: in std_logic_vector(2 downto 0);

Read_I_acc,done: out std_logic);

end component;

signal R_I_acc_from_pre_read,FAck_sig,IAck_sig,readORs_sig,write_ack_sig,write_Reg_sig : std_logic;
signal ramAddrBus_sig,upc_Img_address_sig,ram_write_address_sig,last_start_address_sig:std_logic_vector(19 downto 0);
signal counter_delayed_sig:std_logic_vector(2 downto 0);
begin 

img_addresss:img_address port map(Clk => clk,Rst => rst,read_wind_acc =>R_I_acc_from_pre_read,
ack_F => FAck_sig,ack_Img => IAck_sig,stride => stride,size => size,
upc_out => ramAddrBus_sig,upc_Img_address => upc_Img_address_sig,
last_start_address => last_start_address_sig
 );


dmaa:dma port map(Clk => clk,hardRst => rst,readIAcc => R_I_acc_from_pre_read,readFAcc => readFAcc,
size => size,inputpixel1 => RAM_DataIn(39 downto 32)
,inputpixel2 =>  RAM_DataIn(31 downto 24),inputpixel3 => RAM_DataIn(23 downto 16),inputpixel4 =>RAM_DataIn(15 downto 8) ,
inputpixel5 => RAM_DataIn(7 downto 0),imgAdd => upc_Img_address_sig,lastWrAdd=>ram_write_address_sig,
ramAddrBus => ramAddrBus_sig,outputpixel1 => outputpixel1,outputpixel2 => outputpixel2,outputpixel3 => outputpixel3,
outputpixel4 => outputpixel4,outputpixel5 => outputpixel5,FAck => FAck_sig,IAck => IAck_sig,readORs_out => readORs_sig,
Ors_F => Ors_F,
counter_delayed => counter_delayed_sig
);


for_writee:for_write port map(Clk => clk,Rst=>rst,write_acc => write_acc,start => start,
size => size,read_ors => readORs_sig,read_ack => IAck_sig,data_from_cache =>  data_from_cache,
ram_write_en => RAM_En,write_ack => write_ack_sig,write_Reg => write_Reg_sig,ram_write_address => ram_write_address_sig,
RAM_DataOut => RAM_DataOut
);

write_ack <= write_ack_sig;

pre_read_and_donee:pre_read_and_done port map(Clk => clk,Rst => rst,read_Img_bgd_bgd => readIAcc,write_reg => write_reg_sig,
write_ack =>  write_ack_sig,last_start_address =>  last_start_address_sig,counter_delayed => counter_delayed_sig,
Read_I_acc => R_I_acc_from_pre_read,done => done);

end dma_all_a;
