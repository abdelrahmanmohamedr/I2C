////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_top
////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
import I2C_Controller_test_pkg::*;
`include "uvm_macros.svh";

module I2C_Controller_top ();

bit clk;

initial begin
    clk = 0;
    forever begin
        #20;
        clk =~clk;
    end
end

I2C_interface I2C_Controller_interface (clk);

I2C_Controller I2C_Controller (
    .clk(I2C_Controller_interface.clk),
    .rst_n(I2C_Controller_interface.rst_n),
    .controller_data_req(I2C_Controller_interface.controller_data_req),
    .controller_addr_req(I2C_Controller_interface.controller_addr_req),
    .controller_valid_req(I2C_Controller_interface.controller_valid_req),
    .controller_operation_req(I2C_Controller_interface.controller_operation_req),
    .controller_restart_req(I2C_Controller_interface.controller_restart_req),
    .SCL_in(I2C_Controller_interface.SCL_in),
    .SDA_in(I2C_Controller_interface.SDA_in),
    .SCL_out(I2C_Controller_interface.SCL_out),
    .SDA_out(I2C_Controller_interface.SDA_out),
    .write_enable(I2C_Controller_interface.write_enable),
    .read_enable(I2C_Controller_interface.read_enable),
    .self_address_generated(I2C_Controller_interface.self_address_generated) 
);

assign I2C_Controller_interface.SCL_in = I2C_Controller_interface.SCL_out;

initial begin
    uvm_config_db #(virtual I2C_interface)::set(null,"*","int",I2C_Controller_interface);
    run_test("I2C_Controller_test_class");
end


endmodule