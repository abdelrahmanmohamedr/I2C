////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_top
////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
import I2C_Pattern_Detector_test_pkg::*;
`include "uvm_macros.svh";

module I2C_Pattern_Detector_top ();

I2C_interface I2C_Pattern_Detector_interface ();

I2C_Pattern_Detector I2C_Pattern_Detector (
    .SCL_in(I2C_Pattern_Detector_interface.SCL_in),
    .SDA_in(I2C_Pattern_Detector_interface.SDA_in),
    .rst_n(I2C_Pattern_Detector_interface.rst_n),
    .self_address_generated(I2C_Pattern_Detector_interface.self_address_generated),
    .wr_enable(I2C_Pattern_Detector_interface.write_enable), 
    .SDA_out(I2C_Pattern_Detector_interface.SDA_out),
    .rd_enable(I2C_Pattern_Detector_interface.read_enable) 
);

bind I2C_Pattern_Detector I2C_Pattern_Detector_assertion I2C_Pattern_Detector_assertion_inst (
    .SCL_in(I2C_Pattern_Detector_interface.SCL_in),
    .SDA_in(I2C_Pattern_Detector_interface.SDA_in),
    .rst_n(I2C_Pattern_Detector_interface.rst_n),
    .self_address_generated(I2C_Pattern_Detector_interface.self_address_generated),
    .wr_enable(I2C_Pattern_Detector_interface.write_enable), 
    .SDA_out(I2C_Pattern_Detector_interface.SDA_out),
    .rd_enable(I2C_Pattern_Detector_interface.read_enable) 
);

assign I2C_Pattern_Detector_interface.start_state = I2C_Pattern_Detector.start_state;
assign I2C_Pattern_Detector_interface.stop_state = I2C_Pattern_Detector.stop_state;

initial begin
    uvm_config_db #(virtual I2C_interface)::set(null,"*","int",I2C_Pattern_Detector_interface);
    run_test("I2C_Pattern_Detector_test_class");
end


endmodule