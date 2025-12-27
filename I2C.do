vlib work
vlog -f I2C.list +cover -covercells
vsim -coverage -voptargs="+acc +cover=bcfst" work.I2C_top -classdebug -uvmcontrol=all -logfile I2C.log
add wave /I2C_top/I2C_interface_1/clk
add wave /I2C_top/I2C_interface_1/rst_n
add wave /I2C_top/I2C_interface_1/controller_data_req
add wave /I2C_top/I2C_interface_1/controller_addr_req
add wave /I2C_top/I2C_interface_1/controller_valid_req
add wave /I2C_top/I2C_interface_1/controller_operation_req
add wave /I2C_top/I2C_interface_1/controller_restart_req
add wave /I2C_top/I2C_interface_1/SCL_in
add wave /I2C_top/I2C_interface_1/SDA_in
add wave /I2C_top/I2C_interface_1/write_enable
add wave /I2C_top/I2C_interface_1/read_enable
add wave /I2C_top/I2C_interface_1/self_address_generated
add wave /I2C_top/I2C_interface_1/start_state
add wave /I2C_top/I2C_interface_1/stop_state
add wave /I2C_top/I2C_interface_1/controller_data_rsp
add wave /I2C_top/I2C_interface_2/rst_n
add wave /I2C_top/I2C_interface_2/controller_data_req
add wave /I2C_top/I2C_interface_2/controller_addr_req
add wave /I2C_top/I2C_interface_2/controller_valid_req
add wave /I2C_top/I2C_interface_2/controller_operation_req
add wave /I2C_top/I2C_interface_2/controller_restart_req
add wave /I2C_top/I2C_interface_2/SCL_in
add wave /I2C_top/I2C_interface_2/SDA_in
add wave /I2C_top/I2C_interface_2/SCL_out
add wave /I2C_top/I2C_interface_2/SDA_out
add wave /I2C_top/I2C_interface_2/write_enable
add wave /I2C_top/I2C_interface_2/read_enable
add wave /I2C_top/I2C_interface_2/self_address_generated
add wave /I2C_top/I2C_interface_1/start_state
add wave /I2C_top/I2C_interface_1/stop_state
add wave /I2C_top/I2C_interface_1/controller_data_rsp
run -all
coverage save I2C_Manager.ucdb -onexit