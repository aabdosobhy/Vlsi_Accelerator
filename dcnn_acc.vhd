LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity dcnn_acc is 
	Generic (n : integer :=8);
port ( clk,rst,start,inst,size,stride: in std_logic;
	RAM_DataIn: in std_logic_vector(39 downto 0);
        done,RAM_En:out std_logic;
        RAM_Address: out std_logic_vector(19 downto 0);
	RAM_DataOut: out std_logic_vector(7 downto 0));
end dcnn_acc;

architecture dcnn_acc_a of dcnn_acc is 

component dma_all is 
	Generic (n : integer :=8);
port ( clk,rst,start,size,stride,readIAcc,readFAcc,write_acc : in std_logic;
	RAM_DataIn: in std_logic_vector(39 downto 0);
        data_from_cache: in std_logic_vector( n-1 downto 0);
        done,RAM_En,FAck,IAck,write_ack,Ors_F:out std_logic;
        RAM_Address: out std_logic_vector(19 downto 0);
	RAM_DataOut: out std_logic_vector(7 downto 0);
       outputpixel1,outputpixel2,outputpixel3,outputpixel4,outputpixel5 : OUT std_logic_vector(n-1 DOWNTO 0);
       counter_delayed:OUT std_logic_vector(2 DOWNTO 0));
end component;

component bet_cache_dma IS 
GENERIC ( n : integer := 8); 
		PORT (clk,rst,size,Ors_F : IN std_logic;
		    r0,r1,r2,r3,r4: IN std_logic_vector(n-1 DOWNTO 0);
                    counter_delayed_dma:  IN std_logic_vector(2 DOWNTO 0);
                    cache_w_in : in std_logic_vector(7 downto 0);
		    en_W_cache : in std_logic;
  		   alu1,alu2,alu3,alu4,alu5,alu6,alu7,alu8,alu9,alu10,alu11,alu12,alu13,alu14,alu15,alu16,alu17,alu18,alu19,alu20
,alu21,alu22,alu23,alu24,alu25 : OUT std_logic_vector(n-1 DOWNTO 0);
cache_w_out: out std_logic_vector(7 downto 0));
END component;


component Accelerator IS
GENERIC ( n : integer := 8);
PORT( Clk,Rst ,Start,Size,R_F_Ack, R_I_Ack,Write_ack,instr : in std_logic;
	 alu1,alu2,alu3,alu4,alu5,
	alu6,alu7,alu8,alu9,alu10,
	alu11,alu12,alu13,alu14,
	alu15,alu16,alu17,alu18,
	alu19,alu20,alu21,alu22,
	alu23,alu24,alu25 : in std_logic_vector(n-1 DOWNTO 0);  

	cache_w_in : out std_logic_vector(7 downto 0);
	R_I_acc,R_F_acc,Write_acc,en_W_cache : out std_logic
	);
END component;

signal R_I_acc_bgd_bgd,R_F_acc_sig,Write_acc_sig,FAck_sig,IAck_sig,write_ack_sig,Ors_F_sig,en_W_cache_sig:std_logic;
signal cache_w_out_sig,ro_sig,r1_sig,r2_sig,r3_sig,r4_sig,cache_w_in_sig : std_logic_vector(7 downto 0);
signal counter_delayed_sig:std_logic_vector(2 downto 0);
signal alu1_sig,alu2_sig,alu3_sig,alu4_sig,alu5_sig,alu6_sig,alu7_sig,alu8_sig,alu9_sig,alu10_sig,alu11_sig,alu12_sig,alu13_sig
,alu14_sig,alu15_sig,alu16_sig,alu17_sig,alu18_sig,alu19_sig,alu20_sig
,alu21_sig,alu22_sig,alu23_sig,alu24_sig,alu25_sig: std_logic_vector(7 downto 0);
begin 


dma_alll:dma_all port map(clk => clk,rst => rst,start => start,size => size,stride => stride,
readIAcc => R_I_acc_bgd_bgd,readFAcc => R_F_acc_sig,write_acc => Write_acc_sig,
RAM_DataIn => RAM_DataIn,data_from_cache => cache_w_out_sig,done => done,RAM_En=>RAM_En,
FAck => FAck_sig,IAck => IAck_sig,write_ack => write_ack_sig,Ors_F => Ors_F_sig,RAM_Address => RAM_Address,
RAM_DataOut => RAM_DataOut,outputpixel1 => ro_sig,outputpixel2 => r1_sig,outputpixel3 => r2_sig,outputpixel4 => r3_sig
,outputpixel5 =>r4_sig,counter_delayed => counter_delayed_sig);


bet_cache_dmaa:bet_cache_dma port map(clk => clk,rst => rst,size => size,Ors_F => Ors_F_sig,r0 => ro_sig,
r1 => r1_sig,r2 => r2_sig,r3 => r3_sig,r4 => r4_sig,counter_delayed_dma => counter_delayed_sig,
cache_w_in => cache_w_in_sig,en_W_cache => en_W_cache_sig,
alu1 => alu1_sig,alu2 =>alu2_sig,alu3 =>alu3_sig,alu4 =>alu4_sig,alu5 =>alu5_sig,alu6 =>alu6_sig,alu7 =>alu7_sig,alu8 =>alu8_sig,
alu9 =>alu9_sig,alu10 =>alu10_sig,alu11 =>alu11_sig,alu12 =>alu12_sig,alu13 =>alu13_sig
,alu14 =>alu14_sig,alu15 =>alu15_sig,alu16 =>alu16_sig,alu17 =>alu17_sig,alu18 =>alu18_sig,alu19 =>alu19_sig,alu20 =>alu20_sig
,alu21 =>alu21_sig,alu22 =>alu22_sig,alu23 =>alu23_sig,alu24 =>alu24_sig,alu25 =>alu25_sig,
cache_w_out => cache_w_out_sig);


Acceleratorr:Accelerator port map(Clk =>clk,Rst => rst,Start => start,Size => size,
R_F_Ack => FAck_sig, R_I_Ack => IAck_sig,Write_ack => write_ack_sig,instr => inst,
alu1 => alu1_sig,alu2 =>alu2_sig,alu3 =>alu3_sig,alu4 =>alu4_sig,alu5 =>alu5_sig,alu6 =>alu6_sig,alu7 =>alu7_sig,alu8 =>alu8_sig,
alu9 =>alu9_sig,alu10 =>alu10_sig,alu11 =>alu11_sig,alu12 =>alu12_sig,alu13 =>alu13_sig
,alu14 =>alu14_sig,alu15 =>alu15_sig,alu16 =>alu16_sig,alu17 =>alu17_sig,alu18 =>alu18_sig,alu19 =>alu19_sig,alu20 =>alu20_sig
,alu21 =>alu21_sig,alu22 =>alu22_sig,alu23 =>alu23_sig,alu24 =>alu24_sig,alu25 =>alu25_sig,
cache_w_in => cache_w_in_sig,R_I_acc => R_I_acc_bgd_bgd,R_F_acc => R_F_acc_sig,Write_acc => Write_acc_sig,
en_W_cache => en_W_cache_sig
);

end dcnn_acc_a;
