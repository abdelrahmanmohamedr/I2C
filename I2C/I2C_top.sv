////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_top
////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
import I2C_test_pkg::*;
`include "uvm_macros.svh";

module I2C_top ();

bit clk;

initial begin
    clk = 0;
    forever begin
        #20;
        clk =~clk;
    end
end

I2C_interface I2C_interface_1 (clk);
I2C_interface I2C_interface_2 (clk);

logic rst_n;

I2C_top_design I2C_top_design_inst (
    .clk(clk),
    .rst_n1(I2C_interface_1.rst_n),
    .rst_n2(I2C_interface_2.rst_n),
    .controller_data_req1(I2C_interface_1.controller_data_req),
    .controller_addr_req1(I2C_interface_1.controller_addr_req),
    .controller_valid_req1(I2C_interface_1.controller_valid_req),
    .controller_operation_req1(I2C_interface_1.controller_operation_req),
    .controller_restart_req1(I2C_interface_1.controller_restart_req),
    .error_signal1(I2C_interface_1.error_signal),
    .controller_data_req2(I2C_interface_2.controller_data_req),
    .controller_addr_req2(I2C_interface_2.controller_addr_req),
    .controller_valid_req2(I2C_interface_2.controller_valid_req),
    .controller_operation_req2(I2C_interface_2.controller_operation_req),
    .controller_restart_req2(I2C_interface_2.controller_restart_req),
    .error_signal2(I2C_interface_2.error_signal),
    .controller_data_rsp1(I2C_interface_1.controller_data_rsp),
    .controller_data_rsp2(I2C_interface_2.controller_data_rsp)
);

bind I2C_top_design_inst I2C_assertion1 I2C_assertion1_inst (
    .clk(clk),
    .SCL_in(I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.SCL_in),
    .SDA_in(I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.SDA_in),
    .rst_n(I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.rst_n),
    .controller_data_req(I2C_interface_2.controller_data_req),
    .self_address_generated(I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.self_address_generated),
    .wr_enable(I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.wr_enable), 
    .SDA_out(I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.SDA_out),
    .rd_enable(I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.rd_enable), 
    .controller_data_rsp(I2C_interface_1.controller_data_rsp) 
);

bind I2C_top_design_inst I2C_assertion2 I2C_assertion2_inst (
    .clk(clk),
    .SCL_in(I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.SCL_in),
    .SDA_in(I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.SDA_in),
    .rst_n(I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.rst_n),
    .controller_data_req(I2C_interface_1.controller_data_req),
    .self_address_generated(I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.self_address_generated),
    .wr_enable(I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.wr_enable), 
    .SDA_out(I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.SDA_out),
    .rd_enable(I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.rd_enable),
    .controller_data_rsp(I2C_interface_2.controller_data_rsp) 
);

assign I2C_interface_1.start_state = I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.start_state;
assign I2C_interface_2.start_state = I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.start_state;
assign I2C_interface_1.stop_state = I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.stop_state;
assign I2C_interface_2.stop_state = I2C_top_design_inst.I2C2.I2C_Pattern_Detector_inst.stop_state;

assign I2C_interface_1.SDA_in = I2C_top_design_inst.SDA;
assign I2C_interface_1.SCL_in = I2C_top_design_inst.SCL;
assign I2C_interface_2.SDA_in = I2C_top_design_inst.SDA;
assign I2C_interface_2.SCL_in = I2C_top_design_inst.SCL;

assign I2C_interface_1.SDA_out = I2C_top_design_inst.SDA;
assign I2C_interface_1.SCL_out = I2C_top_design_inst.SCL;
assign I2C_interface_2.SDA_out = I2C_top_design_inst.SDA;
assign I2C_interface_2.SCL_out = I2C_top_design_inst.SCL;

assign I2C_interface_1.self_address_generated = I2C_top_design_inst.I2C1.self_address_generated;
assign I2C_interface_2.self_address_generated = I2C_top_design_inst.I2C2.self_address_generated;

assign I2C_interface_1.write_enable = I2C_top_design_inst.I2C1.write_enable_pattern_detector | I2C_top_design_inst.I2C1.write_enable_controller;
assign I2C_interface_2.write_enable = I2C_top_design_inst.I2C2.write_enable_pattern_detector | I2C_top_design_inst.I2C2.write_enable_controller;
assign I2C_interface_1.read_enable = I2C_top_design_inst.I2C1.read_enable_pattern_detector | I2C_top_design_inst.I2C1.read_enable_controller;
assign I2C_interface_2.read_enable = I2C_top_design_inst.I2C2.read_enable_pattern_detector | I2C_top_design_inst.I2C2.read_enable_controller; 

initial begin
    uvm_config_db #(virtual I2C_interface)::set(null,"*","int1",I2C_interface_1);
    uvm_config_db #(virtual I2C_interface)::set(null,"*","int2",I2C_interface_2);
    run_test("I2C_test_class");
end


endmodule