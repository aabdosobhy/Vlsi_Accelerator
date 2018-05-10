LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY Accelerator IS
GENERIC ( n : integer := 8);
PORT( Clk,Rst ,Start,Size,R_F_Ack, R_I_Ack_dma,Write_ack,instr : in std_logic;
	 alu1,alu2,alu3,alu4,alu5,
	alu6,alu7,alu8,alu9,alu10,
	alu11,alu12,alu13,alu14,
	alu15,alu16,alu17,alu18,
	alu19,alu20,alu21,alu22,
	alu23,alu24,alu25 : in std_logic_vector(n-1 DOWNTO 0);  

	cache_w_in : out std_logic_vector(7 downto 0);
	R_I_acc,R_F_acc,Write_acc,en_W_cache : out std_logic
	);
END Accelerator;

ARCHITECTURE my_Accelerator OF Accelerator IS

component alu_component is 
	port (Clk,Rst,R_F_Ack,R_I_Ack , en_S,en_P: in std_logic;
		Data_from_cache : in std_logic_vector(7 downto 0);
		result : out std_logic_vector(7 downto 0)
		);

end component;

component my_nadder_noCout IS
       GENERIC (n : integer := 17);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);

             f : OUT std_logic_vector(n-1 DOWNTO 0)
             );
END component;

component my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

component my_nDFF_fall IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

component my_DFF IS
     PORT( clk,rst,en,d: IN std_logic;   q : OUT std_logic);
END component;

component my_DFF_rise IS
     PORT( clk,rst,en,d: IN std_logic;   q : OUT std_logic);
END component;


component mux4 is 
	Generic (m : integer :=16);
port ( s1,s0: in std_logic;
	input1,input2,input3,input4: in std_logic_vector(m-1 downto 0);
	output: out std_logic_vector(m-1 downto 0));
end component;

component mux2_1 IS 
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;


signal 	R_I_Ack,en_S,en_P, R_F_ack_reg_out,R_F_Ack_buff,en_counter ,en_mux_in_count ,counter_eq_zero,counter_del_not_zero,counter_del_eq_zero,R_I_Ack_buff , counter_eq_8 ,
	write_ack_buff_in,write_ack_buff_out,en_W_cache_sig ,Write_acc_sig ,write_ack_buf: std_logic;
signal counter_value,out_mux_in_counter ,counter_del_val,counter_dec,out_mux_ld_count_val: std_logic_vector(3 downto 0);
signal 	result_alu_comp1,result_alu_comp2,result_alu_comp3,result_alu_comp4,result_alu_comp5,
	result_alu_comp6,result_alu_comp7,result_alu_comp8,	result_alu_comp9,result_alu_comp10,
	result_alu_comp11,result_alu_comp12,result_alu_comp13,result_alu_comp14,result_alu_comp15,
	result_alu_comp16,	result_alu_comp17,result_alu_comp18,result_alu_comp19,result_alu_comp20,
	result_alu_comp21,result_alu_comp22,result_alu_comp23,result_alu_comp24,result_alu_comp25   : std_logic_vector(7 downto 0 );	

signal  mux_output_sum1,mux_output_sum2,mux_output_sum3,mux_output_sum4,mux_output_sum5,
		mux_output_sum6,mux_output_sum7,mux_output_sum8,mux_output_sum9,mux_output_sum10,
		mux_output_sum14,mux_output_sum15,mux_output_sum19,mux_output_sum20,mux_output_sum24,mux_output_sum25: std_logic_vector(7 downto 0 );
signal  out_sum1,out_sum2,out_sum3,out_sum4,out_sum5,out_sum6,out_sum7,
		out_sum8,out_sum9,out_sum10,out_sum11,out_sum12,out_sum13,out_sum14,out_sum15,
		out_sum16,out_sum17,out_sum18,out_sum19,out_sum20,out_sum21,out_sum22,out_sum23,out_sum24 : std_logic_vector(7 downto 0 );
signal out_sum24_shft3,out_sum24_shft5 : std_logic_vector (7 downto 0 );
signal  sh1,sh2 ,R_I_Ack_count_zero,R_I_Ack_special,save_R_I_Ack_bgd : std_logic;
signal const_zero_value : std_logic_vector (7 downto 0 );

BEGIN


R_F_ack_reg : my_DFF  PORT map (Clk,Rst,'1', R_F_Ack, R_F_ack_reg_out);
R_F_ack_buff_reg : my_DFF_rise  PORT map (Clk,Rst,'1', R_F_ack_reg_out, R_F_Ack_buff);


en_S<=R_F_Ack or R_F_Ack_buff;
counter_eq_zero <= '1' when counter_value = "0000" else '0';
counter_del_not_zero <= '1' WHEN counter_del_val /= "0000" else '0';

en_P<= R_I_Ack or  counter_del_not_zero ; 

en_mux_in_count<= R_F_Ack or R_I_Ack;
en_counter <= en_P or R_F_Ack;
Counter : my_nDFF_fall GENERIC map ( n =>4) PORT map ( Clk,Rst,en_counter,  out_mux_in_counter,counter_value);
mux_counter :	mux2_1 Generic map (n=>4) port map (counter_dec,out_mux_ld_count_val,en_mux_in_count,out_mux_in_counter);
mux_ld_count_val: mux2_1 Generic map (n=>4) port map ("0010","1000",R_I_Ack,out_mux_ld_count_val);
counter_dec <= counter_value - 1 ;
Counter_delay :  my_nDFF GENERIC map ( n => 4) PORT map ( Clk,Rst,'1' ,counter_value, counter_del_val);

counter_eq_8 <= '1' when counter_value= "1000" else '0';
R_I_acc<= counter_eq_8 or R_F_ack_reg_out ;
R_F_acc	<= Start;

R_I_Ack_buffer : my_DFF  PORT map (Clk,Rst,R_I_Ack, R_I_Ack, R_I_Ack_buff);

write_ack_buff_in <=Write_ack or Start ;
write_ack_buff_reg : my_DFF_rise  PORT map (Clk,write_ack_buf, write_ack_buff_in , write_ack_buff_in, write_ack_buff_out);



en_W_cache_sig<=counter_eq_zero and write_ack_buff_out and R_I_Ack_buff ;
en_W_cache <= en_W_cache_sig;

Write_acc_reg :my_DFF_rise   PORT map (Clk,Rst,'1', en_W_cache_sig, Write_acc_sig);
Write_acc <= Write_acc_sig;
write_ack_buf_reg :my_DFF   PORT map (Clk,Rst,'1', Write_acc_sig, write_ack_buf);


alu_comp_1 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu1,result_alu_comp1);
alu_comp_2 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P, alu2,result_alu_comp2);
alu_comp_3 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P, alu3,result_alu_comp3);
alu_comp_4 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P, alu4,result_alu_comp4);
alu_comp_5 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P, alu5,result_alu_comp5);
alu_comp_6 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu6,result_alu_comp6);
alu_comp_7 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu7,result_alu_comp7);
alu_comp_8 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu8,result_alu_comp8);
alu_comp_9 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu9,result_alu_comp9);
alu_comp_10 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu10,result_alu_comp10);
alu_comp_11 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu11,result_alu_comp11);
alu_comp_12 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu12,result_alu_comp12);
alu_comp_13 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu13,result_alu_comp13);
alu_comp_14 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu14,result_alu_comp14);
alu_comp_15 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu15,result_alu_comp15);
alu_comp_16 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu16,result_alu_comp16);
alu_comp_17 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu17,result_alu_comp17);
alu_comp_18 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu18,result_alu_comp18);
alu_comp_19 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu19,result_alu_comp19);
alu_comp_20 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu20,result_alu_comp20);
alu_comp_21 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu21,result_alu_comp21);
alu_comp_22 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu22,result_alu_comp22);
alu_comp_23 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu23,result_alu_comp23);
alu_comp_24 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu24,result_alu_comp24);
alu_comp_25 : alu_component port map (Clk,Start,R_F_Ack,R_I_Ack , en_S,en_P,alu25,result_alu_comp25);

const_zero_value <="00000000";

mux_input_sum1 :mux2_1 Generic map (n=>8) port map (result_alu_comp1,const_zero_value,Size,mux_output_sum1 );
mux_input_sum2 :mux2_1 Generic map (n=>8) port map (result_alu_comp2,const_zero_value,Size,mux_output_sum2 );
mux_input_sum3 :mux2_1 Generic map (n=>8) port map (result_alu_comp3,const_zero_value,Size,mux_output_sum3 );
mux_input_sum4 :mux2_1 Generic map (n=>8) port map (result_alu_comp4,const_zero_value,Size,mux_output_sum4 );
mux_input_sum5 :mux2_1 Generic map (n=>8) port map (result_alu_comp5,const_zero_value,Size,mux_output_sum5 );
mux_input_sum6 :mux2_1 Generic map (n=>8) port map (result_alu_comp6,const_zero_value,Size,mux_output_sum6 );
mux_input_sum7 :mux2_1 Generic map (n=>8) port map (result_alu_comp7,const_zero_value,Size,mux_output_sum7 );
mux_input_sum8 :mux2_1 Generic map (n=>8) port map (result_alu_comp8,const_zero_value,Size,mux_output_sum8 );
mux_input_sum9 :mux2_1 Generic map (n=>8) port map (result_alu_comp9,const_zero_value,Size,mux_output_sum9 );
mux_input_sum10 :mux2_1 Generic map (n=>8) port map (result_alu_comp10,const_zero_value,Size,mux_output_sum10 );
mux_input_sum14 :mux2_1 Generic map (n=>8) port map (result_alu_comp14,const_zero_value,Size,mux_output_sum14);
mux_input_sum15 :mux2_1 Generic map (n=>8) port map (result_alu_comp15,const_zero_value,Size,mux_output_sum15);
mux_input_sum19 :mux2_1 Generic map (n=>8) port map (result_alu_comp19,const_zero_value,Size,mux_output_sum19);
mux_input_sum20 :mux2_1 Generic map (n=>8) port map (result_alu_comp20,const_zero_value,Size,mux_output_sum20);
mux_input_sum24 :mux2_1 Generic map (n=>8) port map (result_alu_comp24,const_zero_value,Size,mux_output_sum24);
mux_input_sum25 :mux2_1 Generic map (n=>8) port map (result_alu_comp25,const_zero_value,Size,mux_output_sum25);


sum1: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum1,mux_output_sum2,out_sum1);
sum2: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum3,mux_output_sum4,out_sum2);
sum3: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum5,mux_output_sum6,out_sum3);
sum4: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum7,mux_output_sum8,out_sum4);
sum5: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum9,mux_output_sum10,out_sum5);
sum6: my_nadder_noCout GENERIC map (n => 8) PORT map (result_alu_comp11,result_alu_comp12,out_sum6);
sum7: my_nadder_noCout GENERIC map (n => 8) PORT map (result_alu_comp13,mux_output_sum14,out_sum7);
sum8: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum15,result_alu_comp16,out_sum8);
sum9: my_nadder_noCout GENERIC map (n => 8) PORT map (result_alu_comp17,result_alu_comp18,out_sum9);
sum10: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum19,mux_output_sum20,out_sum10);
sum11: my_nadder_noCout GENERIC map (n => 8) PORT map (result_alu_comp21,result_alu_comp22,out_sum11);
sum12: my_nadder_noCout GENERIC map (n => 8) PORT map (result_alu_comp23,mux_output_sum24,out_sum12);
sum13: my_nadder_noCout GENERIC map (n => 8) PORT map (mux_output_sum25,out_sum1,out_sum13);
sum14: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum3,out_sum4,out_sum14);
sum15: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum5,out_sum6,out_sum15);
sum16: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum7,out_sum8,out_sum16);
sum17: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum9,out_sum10,out_sum17);
sum18: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum11,out_sum12,out_sum18);
sum19: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum2,out_sum13,out_sum19);
sum20: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum14,out_sum19,out_sum20);
sum21: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum15,out_sum16,out_sum21);
sum22: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum17,out_sum18,out_sum22);
sum23: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum21,out_sum22,out_sum23);
sum24: my_nadder_noCout GENERIC map (n => 8) PORT map (out_sum23,out_sum20,out_sum24);

sh1<=Size and instr;
sh2<= not (Size) and instr;

out_sum24_shft3 <= "000" & out_sum24 (7 downto 3);
out_sum24_shft5<= "00000" & out_sum24 (7 downto 5);

out_cache_value :  mux4	Generic map (m=>8) port map ( sh2,sh1,out_sum24,out_sum24_shft3,out_sum24_shft5,out_sum24,cache_w_in);



counter_del_eq_zero<= not counter_del_not_zero ;
save_R_I_Ack_bgd <= R_I_Ack_dma and en_P;

R_I_Ack_spical_1 : my_DFF  PORT map (Clk,Rst,save_R_I_Ack_bgd, save_R_I_Ack_bgd, R_I_Ack_special);
R_I_Ack_spical_2 : my_DFF_rise  PORT map (Clk,Rst,counter_del_eq_zero,R_I_Ack_special , R_I_Ack_count_zero);

R_I_Ack  <= (R_I_Ack_dma and  not (en_P)) or (R_I_Ack_count_zero and not (en_P));


end my_Accelerator;