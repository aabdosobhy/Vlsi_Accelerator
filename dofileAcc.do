vsim work.accelerator
# vsim work.accelerator 
# Start time: 14:07:59 on May 10,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.accelerator(my_accelerator)
# Loading work.my_dff(a_my_dff)
# Loading work.my_dff_rise(a_my_dff_rise)
# Loading work.my_ndff_fall(a_my_ndff_fall)
# Loading work.mux2_1(mux2_1_a)
# Loading work.my_ndff(a_my_ndff)
add wave -position end  sim:/accelerator/Clk
add wave -position end  sim:/accelerator/Rst
add wave -position end  sim:/accelerator/Start
add wave -position end  sim:/accelerator/Size
add wave -position end  sim:/accelerator/R_F_Ack
add wave -position end  sim:/accelerator/R_I_Ack
add wave -position end  sim:/accelerator/Write_ack
add wave -position end  sim:/accelerator/instr
add wave -position end  sim:/accelerator/R_I_acc
add wave -position end  sim:/accelerator/R_F_acc
add wave -position end  sim:/accelerator/Write_acc
add wave -position end  sim:/accelerator/en_W_cache
add wave -position end  sim:/accelerator/en_S
add wave -position end  sim:/accelerator/en_P
add wave -position end  sim:/accelerator/counter_value
add wave -position end  sim:/accelerator/counter_del_val
add wave -position end  sim:/accelerator/R_F_ack_reg_out
add wave -position end  sim:/accelerator/R_F_Ack_buff
add wave -position end  sim:/accelerator/en_counter
add wave -position end  sim:/accelerator/en_mux_in_count
add wave -position end  sim:/accelerator/counter_eq_zero
add wave -position end  sim:/accelerator/R_I_Ack_buff
add wave -position end  sim:/accelerator/counter_eq_8
add wave -position end  sim:/accelerator/write_ack_buff_in
add wave -position end  sim:/accelerator/write_ack_buff_out
add wave -position end  sim:/accelerator/en_W_cache_sig
add wave -position end  sim:/accelerator/Write_acc_sig
add wave -position end  sim:/accelerator/write_ack_buf

add wave -position end  sim:/accelerator/out_mux_in_counter

add wave -position end  sim:/accelerator/counter_dec
add wave -position end  sim:/accelerator/out_mux_ld_count_val
force -freeze sim:/accelerator/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/accelerator/Rst 1 0
run


force -freeze sim:/accelerator/Rst 0 0
force -freeze sim:/accelerator/Start 1 0
run
force -freeze sim:/accelerator/Start 0 0
run
force -freeze sim:/accelerator/Write_ack 0 0
run
force -freeze sim:/accelerator/R_F_Ack 1 0
force -freeze sim:/accelerator/R_I_Ack 0 0
run
force -freeze sim:/accelerator/R_F_Ack 0 0
run
run

run
run
force -freeze sim:/accelerator/R_I_Ack 1 0
run
force -freeze sim:/accelerator/R_I_Ack 0 0
run
run
run
run
force -freeze sim:/accelerator/Write_ack 1 0
run
force -freeze sim:/accelerator/Write_ack 0 0
run
run
run
run
force -freeze sim:/accelerator/R_I_Ack 1 0
run
force -freeze sim:/accelerator/R_I_Ack 0 0
run
run
force -freeze sim:/accelerator/Write_ack 1 0
run
force -freeze sim:/accelerator/Write_ack 0 0
run
run
run
run
run
run
run
run
