module I2C #(
    parameter DATA_WIDTH = 8,
    parameter ADDRESS = 7'h10,
    parameter ADDR_WIDTH = 7,
    parameter FORWARDED_CLOCK_SPEED = 100000,
    parameter LOCAL_CLOCK_SPEED = 1000000
) (
    input logic clk,
    input logic rst_n,
    input logic [DATA_WIDTH-1:0] controller_data_req,
    input logic [ADDR_WIDTH-1:0] controller_addr_req,
    input logic controller_valid_req,
    input logic controller_operation_req,
    input logic controller_restart_req,
    input logic error_signal,
    output logic [DATA_WIDTH-1:0] controller_data_rsp,
    inout wire SDA,
    inout wire SCL
);

logic write_enable_pattern_detector;
logic write_enable_controller;
logic read_enable_pattern_detector;
logic read_enable_controller;

logic SDA_out_controller;
logic SDA_out_detector;
logic SDA_out_transmitter;
logic SDA_out_receiver;
logic [DATA_WIDTH-1:0]data_rsp;

logic SCL_out_controller;

logic self_address_generated;

assign SDA = SDA_out_controller 
& SDA_out_detector 
& SDA_out_transmitter 
& SDA_out_receiver;

assign SCL = SCL_out_controller;

I2C_Pattern_Detector #(.ADDRESS(ADDRESS), .ADDRESS_WIDTH(ADDR_WIDTH)) I2C_Pattern_Detector_inst (
    .SCL_in(SCL),
    .SDA_in(SDA),
    .rst_n(rst_n),
    .self_address_generated(self_address_generated),
    .SDA_out(SDA_out_detector), 
    .wr_enable(write_enable_pattern_detector), 
    .rd_enable(read_enable_pattern_detector) 
);

I2C_Controller #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .FORWARDED_CLOCK_SPEED(FORWARDED_CLOCK_SPEED), .LOCAL_CLOCK_SPEED(LOCAL_CLOCK_SPEED)) I2C_Controller_inst (
    .clk(clk),
    .rst_n(rst_n),
    .controller_data_req(controller_data_req),
    .controller_addr_req(controller_addr_req),
    .controller_valid_req(controller_valid_req),
    .controller_operation_req(controller_operation_req),
    .controller_restart_req(controller_restart_req),
    .controller_error_req(error_signal),
    .SCL_in(SCL),
    .SDA_in(SDA),
    .SCL_out(SCL_out_controller),
    .SDA_out(SDA_out_controller),
    .write_enable(write_enable_controller),
    .read_enable(read_enable_controller),
    .self_address_generated(self_address_generated)
);

I2C_Receiver #(.DATA_WIDTH(DATA_WIDTH)) I2C_Receiver_inst (
    .clk(clk),
    .rst_n(rst_n),
    .read_enable_pattern_detector(read_enable_pattern_detector),
    .read_enable_controller(read_enable_controller),
    .SCL_in(SCL),
    .valid(controller_valid_req),
    .SDA_in(SDA),
    .error(error_signal),
    .controller_data_rsp(controller_data_rsp),
    .SDA_out(SDA_out_receiver)
);

I2C_Transmitter #(.DATA_WIDTH(DATA_WIDTH)) I2C_Transmitter_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_req(controller_data_req),
    .write_enable_pattern_detector(write_enable_pattern_detector),
    .write_enable_controller(write_enable_controller),
    .SCL_in(SCL),
    .error(error_signal),
    .SDA_out(SDA_out_transmitter)
);

    
endmodule