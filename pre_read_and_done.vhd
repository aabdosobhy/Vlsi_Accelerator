LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity pre_read_and_done is 

port (Clk,Rst,read_Img_bgd_bgd,write_reg,write_ack: in std_logic;
    last_start_address : in std_logic_vector(19 downto 0);
counter_delayed: in std_logic_vector(2 downto 0);


Read_I_acc,done: out std_logic);

end entity pre_read_and_done;


ARCHITECTURE pre_read_and_done_a OF pre_read_and_done IS

component my_DFF_rise IS
     PORT( clk,rst,en,d: IN std_logic;   q : OUT std_logic);
END component;

signal rst_special_reg,en_special,read_Img_bgd,x1,x3,x4,last_start_address_is:std_logic;

BEGIN
last_start_address_is<= '1' when last_start_address = (65025)
                        else '0';
read_Img_bgd <= read_Img_bgd_bgd and not(last_start_address_is);
rst_special_reg <= rst or counter_delayed(2) or counter_delayed(1) or counter_delayed(0);
en_special<= read_Img_bgd and write_reg;
x3 <= x1 and  not(write_reg);
x4 <= read_Img_bgd and  not(write_reg);
special_case_reg: my_DFF_rise port map (clk,rst_special_reg,en_special,read_Img_bgd,x1);
Read_I_acc <= x3 or x4;

done <= last_start_address_is and write_ack;

END pre_read_and_done_a;

