vsim -gui work.bet_cache_dma
# vsim -gui work.bet_cache_dma 
# Start time: 15:31:48 on May 09,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.bet_cache_dma(bet_cache_dma_a)
# Loading work.my_dec(a_my_dec)
# Loading work.my_dec8(a_my_dec8)
# Loading work.my_ndff(a_my_ndff)
# Loading work.mux2_1(mux2_1_a)

add wave -position insertpoint  \
sim:/bet_cache_dma/n -dec \
sim:/bet_cache_dma/clk \
sim:/bet_cache_dma/rst \
sim:/bet_cache_dma/size \
sim:/bet_cache_dma/Ors_F \
sim:/bet_cache_dma/r0 \
sim:/bet_cache_dma/r1 \
sim:/bet_cache_dma/r2 \
sim:/bet_cache_dma/r3 \
sim:/bet_cache_dma/r4 \
sim:/bet_cache_dma/counter_delayed_dma \
sim:/bet_cache_dma/alu1 \
sim:/bet_cache_dma/alu2 \
sim:/bet_cache_dma/alu3 \
sim:/bet_cache_dma/alu4 \
sim:/bet_cache_dma/alu5 \
sim:/bet_cache_dma/alu6 \
sim:/bet_cache_dma/alu7 \
sim:/bet_cache_dma/alu8 \
sim:/bet_cache_dma/alu9 \
sim:/bet_cache_dma/alu10 \
sim:/bet_cache_dma/alu11 \
sim:/bet_cache_dma/alu12 \
sim:/bet_cache_dma/alu13 \
sim:/bet_cache_dma/alu14 \
sim:/bet_cache_dma/alu15 \
sim:/bet_cache_dma/alu16 \
sim:/bet_cache_dma/alu17 \
sim:/bet_cache_dma/alu18 \
sim:/bet_cache_dma/alu19 \
sim:/bet_cache_dma/alu20 \
sim:/bet_cache_dma/alu21 \
sim:/bet_cache_dma/alu22 \
sim:/bet_cache_dma/alu23 \
sim:/bet_cache_dma/alu24 \
sim:/bet_cache_dma/alu25 \
sim:/bet_cache_dma/dec_F_in \
sim:/bet_cache_dma/dec_I_in \
sim:/bet_cache_dma/dec_F_out \
sim:/bet_cache_dma/dec_I_out \
sim:/bet_cache_dma/mux1_out \
sim:/bet_cache_dma/mux2_out \
sim:/bet_cache_dma/mux3_out \
sim:/bet_cache_dma/mux4_out \
sim:/bet_cache_dma/mux5_out \
sim:/bet_cache_dma/mux6_out \
sim:/bet_cache_dma/en_Dec_F \
sim:/bet_cache_dma/en_alu11_13 \
sim:/bet_cache_dma/en_alu16_17 \
sim:/bet_cache_dma/en_alu21_23 \
sim:/bet_cache_dma/en_alu18

force -freeze sim:/bet_cache_dma/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/bet_cache_dma/rst 1 0
run
force -freeze sim:/bet_cache_dma/rst 0 0
force -freeze sim:/bet_cache_dma/size 1 0
force -freeze sim:/bet_cache_dma/Ors_F 1 0
force -freeze sim:/bet_cache_dma/r0 00000001 0
force -freeze sim:/bet_cache_dma/r1 00000010 0
force -freeze sim:/bet_cache_dma/r2 00000011 0
force -freeze sim:/bet_cache_dma/r3 00000100 0
force -freeze sim:/bet_cache_dma/r4 00000101 0

force -freeze sim:/bet_cache_dma/counter_delayed_dma 010 0
run
force -freeze sim:/bet_cache_dma/counter_delayed_dma 001 0
run
force -freeze sim:/bet_cache_dma/counter_delayed_dma 000 0
run

force -freeze sim:/bet_cache_dma/Ors_F 0 0
force -freeze sim:/bet_cache_dma/r0 00000110 0
force -freeze sim:/bet_cache_dma/r1 00000111 0
force -freeze sim:/bet_cache_dma/r2 00001000 0
force -freeze sim:/bet_cache_dma/r3 00001001 0
force -freeze sim:/bet_cache_dma/r4 00001010 0


force -freeze sim:/bet_cache_dma/counter_delayed_dma 011 0
run
force -freeze sim:/bet_cache_dma/counter_delayed_dma 010 0
run
force -freeze sim:/bet_cache_dma/counter_delayed_dma 001 0
run
force -freeze sim:/bet_cache_dma/counter_delayed_dma 000 0
run

