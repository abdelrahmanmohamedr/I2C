module I2C_top_design #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 7
) (
    input logic clk,
    input logic rst_n1,
    input logic rst_n2,
    input logic [DATA_WIDTH-1:0] controller_data_req1,
    input logic [ADDR_WIDTH-1:0] controller_addr_req1,
    input logic controller_valid_req1,
    input logic controller_operation_req1,
    input logic controller_restart_req1,
    input logic error_signal1,
    input logic [DATA_WIDTH-1:0] controller_data_req2,
    input logic [ADDR_WIDTH-1:0] controller_addr_req2,
    input logic controller_valid_req2,
    input logic controller_operation_req2,
    input logic controller_restart_req2,
    input logic error_signal2,
    output logic [DATA_WIDTH-1:0] controller_data_rsp1,
    output logic [DATA_WIDTH-1:0] controller_data_rsp2
);

wand SDA;
wand SCL;

I2C #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .ADDRESS('h01)) I2C1 (
    .clk(clk),
    .rst_n(rst_n1),
    .controller_data_req(controller_data_req1),
    .controller_addr_req(controller_addr_req1),
    .controller_valid_req(controller_valid_req1),
    .controller_operation_req(controller_operation_req1),
    .controller_restart_req(controller_restart_req1),
    .error_signal(error_signal1),
    .controller_data_rsp(controller_data_rsp1),
    .SDA(SDA),
    .SCL(SCL)
);

I2C #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .ADDRESS('h10)) I2C2 (
    .clk(clk),
    .rst_n(rst_n2),
    .controller_data_req(controller_data_req2),
    .controller_addr_req(controller_addr_req2),
    .controller_valid_req(controller_valid_req2),
    .controller_operation_req(controller_operation_req2),
    .controller_restart_req(controller_restart_req2),
    .error_signal(error_signal2),
    .controller_data_rsp(controller_data_rsp2),
    .SDA(SDA),
    .SCL(SCL)
);
 
endmodule