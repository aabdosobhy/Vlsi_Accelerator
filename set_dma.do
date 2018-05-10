vsim work.dma
add wave -position end sim:/dma/*
force -freeze sim:/dma/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/dma/hardRst 1 0
force -freeze sim:/dma/size 0 0
run
force -freeze sim:/dma/hardRst 0 0
force -freeze sim:/dma/inputpixel1 16#ff 0
force -freeze sim:/dma/inputpixel2 16#fe 0
force -freeze sim:/dma/inputpixel3 16#fd 0
force -freeze sim:/dma/inputpixel4 16#fc 0
force -freeze sim:/dma/inputpixel5 16#fb 0
force -freeze sim:/dma/imgAdd 16#ddddd 0
force -freeze sim:/dma/lastWrAdd 16#ddddf 0
force -freeze sim:/dma/readIAcc 1 0
force -freeze sim:/dma/readFAcc 1 0
run