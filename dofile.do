vsim work.alu_component


add wave -position end  sim:/alu_component/Clk
add wave -position end  sim:/alu_component/Rst
add wave -position end  sim:/alu_component/R_F_Ack
add wave -position end  sim:/alu_component/R_I_Ack
add wave -position end  sim:/alu_component/en_S
add wave -position end  sim:/alu_component/en_P
add wave -position end  sim:/alu_component/Data_from_cache
add wave -position end  sim:/alu_component/Alu_out
add wave -position end  sim:/alu_component/S_out
add wave -position end  sim:/alu_component/A_out
add wave -position end  sim:/alu_component/P_out
add wave -position end  sim:/alu_component/result
add wave -position end  sim:/alu_component/Out_shift
add wave -position end  sim:/alu_component/Alu_shift_one
add wave -position end  sim:/alu_component/S_in_createSig
add wave -position end  sim:/alu_component/S_In_out_mux
add wave -position end  sim:/alu_component/A_in_createSig
add wave -position end  sim:/alu_component/P_in_createSig
add wave -position end  sim:/alu_component/P_In_out_mux
add wave -position end  sim:/alu_component/RT_OP_ALU
add wave -position end  sim:/alu_component/LFT_OP_ALU
add wave -position end  sim:/alu_component/const_Carry_one
add wave -position end  sim:/alu_component/const_zero
add wave -position end  sim:/alu_component/Sel_H_Lft_OP_mux
add wave -position end  sim:/alu_component/not_en_S


force -freeze sim:/alu_component/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/alu_component/Rst 1 0

run
force -freeze sim:/alu_component/Rst 0 0
force -freeze sim:/alu_component/R_F_Ack 1 0
force -freeze sim:/alu_component/en_S 1 0
force -freeze sim:/alu_component/Data_from_cache 00001010 0
force -freeze sim:/alu_component/en_P 0 0
run
force -freeze sim:/alu_component/R_F_Ack 0 0
run

force -freeze sim:/alu_component/en_S 0 0
force -freeze sim:/alu_component/en_P 1 0
force -freeze sim:/alu_component/R_I_Ack 1 0
force -freeze sim:/alu_component/Data_from_cache 00010110 0
run

force -freeze sim:/alu_component/R_I_Ack 0 0


