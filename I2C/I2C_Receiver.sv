module I2C_Receiver #(
    parameter DATA_WIDTH = 8
) (
    input logic clk,
    input logic rst_n,
    input logic read_enable_pattern_detector,
    input logic read_enable_controller,
    input logic SCL_in,
    input logic valid,
    input logic SDA_in,
    input logic error,
    output logic [DATA_WIDTH-1:0] controller_data_rsp,
    output logic SDA_out
);

localparam BIT_NO = $clog2(DATA_WIDTH);

logic read_enable;
logic read_sample;
logic [DATA_WIDTH-1:0] data_rsp_reg;
logic [BIT_NO:0] counter;

 
assign read_enable = read_enable_pattern_detector || read_enable_controller;

always @(posedge SCL_in or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        data_rsp_reg <= 0;
    end else begin
        if (read_enable) begin
                if (((counter) % 8) || !counter) begin
                    data_rsp_reg[DATA_WIDTH-counter-1] <= SDA_in;
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                end
            end else begin
            data_rsp_reg <= 0;
            counter <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        controller_data_rsp <= 0;
    end else if (read_sample) begin
        controller_data_rsp <= data_rsp_reg;
    end
end

always @(negedge SCL_in or negedge rst_n) begin
    if (!rst_n) SDA_out <= 1;
    else begin 
        if (read_enable_pattern_detector) begin
            if ((!((counter) % 8)) && (counter)) begin
                if (error) SDA_out <= 1;
                else SDA_out <= 0;
            end else SDA_out <= 1;
        end
    end      
end

always @(posedge SCL_in or negedge rst_n) begin
    if (!rst_n) read_sample <= 0;
    else begin 
        if ((!((counter) % 8)) && (counter)) read_sample = 1;
        else read_sample = 0;
    end      
end
endmodule

