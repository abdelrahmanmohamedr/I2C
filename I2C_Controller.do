vlib work
vlog -f I2C_Controller.list +cover -covercells
vsim -coverage -voptargs="+acc +cover=bcfst" work.I2C_Controller_top -classdebug -uvmcontrol=all -logfile I2C_Controller.log
add wave /I2C_Controller_top/I2C_Controller_interface/clk
add wave /I2C_Controller_top/I2C_Controller_interface/rst_n
add wave /I2C_Controller_top/I2C_Controller_interface/controller_data_req
add wave /I2C_Controller_top/I2C_Controller_interface/controller_addr_req
add wave /I2C_Controller_top/I2C_Controller_interface/controller_valid_req
add wave /I2C_Controller_top/I2C_Controller_interface/controller_operation_req
add wave /I2C_Controller_top/I2C_Controller_interface/controller_restart_req
add wave /I2C_Controller_top/I2C_Controller_interface/SCL_in
add wave /I2C_Controller_top/I2C_Controller_interface/SDA_in
add wave /I2C_Controller_top/I2C_Controller_interface/SCL_out
add wave /I2C_Controller_top/I2C_Controller_interface/SDA_out
add wave /I2C_Controller_top/I2C_Controller_interface/write_enable
add wave /I2C_Controller_top/I2C_Controller_interface/read_enable
add wave /I2C_Controller_top/I2C_Controller_interface/self_address_generated
run -all
coverage save I2C_Manager.ucdb -onexit