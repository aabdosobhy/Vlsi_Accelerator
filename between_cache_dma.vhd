LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY bet_cache_dma IS 
GENERIC ( n : integer := 8); 
		PORT (clk,rst,size,Ors_F : IN std_logic;
		    r0,r1,r2,r3,r4: IN std_logic_vector(n-1 DOWNTO 0);
                    counter_delayed_dma:  IN std_logic_vector(2 DOWNTO 0);
                    cache_w_in : in std_logic_vector(7 downto 0);
		    en_W_cache : in std_logic;
  		   alu1,alu2,alu3,alu4,alu5,alu6,alu7,alu8,alu9,alu10,alu11,alu12,alu13,alu14,alu15,alu16,alu17,alu18,alu19,alu20
,alu21,alu22,alu23,alu24,alu25 : OUT std_logic_vector(n-1 DOWNTO 0);
cache_w_out: out std_logic_vector(7 downto 0));    
END ENTITY bet_cache_dma;


ARCHITECTURE bet_cache_dma_a OF bet_cache_dma IS

component mux2_1 IS 
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;

component my_dec8 IS

PORT( in_dec : in std_logic_vector (3 downto 0);
      out_dec: out std_logic_vector (7 downto 0));
END component;

component my_dec IS

PORT( in_dec : in std_logic_vector (2 downto 0);
      out_dec: out std_logic_vector (3 downto 0));
END component;

component my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;


signal dec_F_in: std_logic_vector(2 DOWNTO 0);
signal dec_F_out: std_logic_vector(3 DOWNTO 0);
signal dec_I_in: std_logic_vector(3 DOWNTO 0);
signal dec_I_out,mux1_out,mux2_out,mux3_out,mux4_out,mux5_out,mux6_out: std_logic_vector(7 DOWNTO 0);
signal en_Dec_F,en_alu11_13,en_alu14_15,en_alu16_17,en_alu18,en_alu19_20,en_alu21_23,en_alu24_25: std_logic;
BEGIN

en_Dec_F <= (Ors_F and size);
dec_F_in<= (en_Dec_F & counter_delayed_dma(1 downto 0));
dec_F: my_dec port map (dec_F_in,dec_F_out);

dec_I_in <= (not(en_Dec_F) & counter_delayed_dma);
dec_I: my_dec8 port map (dec_I_in,dec_I_out);

mux1:mux2_1 GENERIC MAP (n=>8) port map (r0,r3,en_Dec_F ,mux1_out);
mux2:mux2_1 GENERIC MAP (n=>8) port map (r1,r4,en_Dec_F ,mux2_out);
mux3:mux2_1 GENERIC MAP (n=>8) port map (r2,r0,en_Dec_F ,mux3_out);
mux4:mux2_1 GENERIC MAP (n=>8) port map (r0,r1,en_Dec_F ,mux4_out);
mux5:mux2_1 GENERIC MAP (n=>8) port map (r1,r2,en_Dec_F ,mux5_out);
mux6:mux2_1 GENERIC MAP (n=>8) port map (r2,r3,en_Dec_F ,mux6_out);

en_alu11_13<= dec_I_out(3) or dec_F_out(2);
en_alu14_15<= dec_I_out(3) and not(size);
en_alu16_17<=dec_I_out(2) or dec_F_out(2);
en_alu18 <= dec_I_out(2) or dec_F_out(1);
en_alu19_20<= dec_I_out(2) and not(size);
en_alu21_23 <= dec_I_out(1) or dec_F_out(1);
en_alu24_25 <= dec_I_out(1) and not(size);

aluu1: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(5),r0,alu1);
aluu2: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(5),r1,alu2);
aluu3: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(5),r2,alu3);
aluu4: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(5),r3,alu4);
aluu5: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(5),r4,alu5);

aluu6: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(4),r0,alu6);
aluu7: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(4),r1,alu7);
aluu8: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(4),r2,alu8);
aluu9: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(4),r3,alu9);
aluu10: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,dec_I_out(4),r4,alu10);

aluu11: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu11_13,r0,alu11);
aluu12: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu11_13,r1,alu12);
aluu13: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu11_13,r2,alu13);
aluu14: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu14_15,r3,alu14);
aluu15: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu14_15,r4,alu15);

aluu16: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu16_17,mux1_out,alu16);
aluu17: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu16_17,mux2_out,alu17);
aluu18: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu18,mux3_out,alu18);
aluu19: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu19_20,r3,alu19);
aluu20: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu19_20,r4,alu20);

aluu21: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu21_23,mux4_out,alu21);
aluu22: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu21_23,mux5_out,alu22);
aluu23: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu21_23,mux6_out,alu23);
aluu24: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu24_25,r3,alu24);
aluu25: my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_alu24_25,r4,alu25);


cache_write_reg:my_nDFF GENERIC MAP (n=>8) port map (clk,rst,en_W_cache,cache_w_in,cache_w_out);

END bet_cache_dma_a;