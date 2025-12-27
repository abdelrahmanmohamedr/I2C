vlib work
vlog -f I2C_Pattern_Detector.list +cover -covercells
vsim -coverage -voptargs="+acc +cover=bcfst" work.I2C_Pattern_Detector_top -classdebug -uvmcontrol=all -logfile I2C_Pattern_Detector.log
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/clk
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/rst_n
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/SCL_in
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/SDA_in
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/self_address_generated
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/write_enable
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/read_enable
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/SDA_out
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/start_state
add wave /I2C_Pattern_Detector_top/I2C_Pattern_Detector_interface/stop_state
run -all
coverage save I2C_Manager.ucdb -onexit