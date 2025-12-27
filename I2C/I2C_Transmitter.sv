module I2C_Transmitter #(
    parameter DATA_WIDTH = 8
) (
    input logic clk,
    input logic rst_n,
    input logic [DATA_WIDTH-1:0] data_req,
    input logic write_enable_pattern_detector,
    input logic write_enable_controller,
    input logic SCL_in,
    input logic error,
    output logic SDA_out
);

localparam BIT_NO = $clog2(DATA_WIDTH);


logic write_enable;
logic SDA_out_reg;
logic error_check;
logic ACK;
logic [BIT_NO:0] counter;

assign write_enable = write_enable_pattern_detector || write_enable_controller;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        SDA_out <= 1;
    end else begin
        if (ACK) SDA_out <= 1;
        else if (!SCL_in) SDA_out <= SDA_out_reg;
    end 
end

always @(negedge SCL_in or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        SDA_out_reg <= 1;
    end else begin
        if (write_enable) begin
            if ((!((counter) % 8)) && counter) begin
                ACK = 1;
                counter <= 0;
            end else if ((((counter) % 8) || !counter) && !SCL_in) begin
                SDA_out_reg <= data_req[DATA_WIDTH-counter-1];
                error_check <= 0;
                counter <= counter + 1; 
                ACK = 0;
            end
        end else begin
            SDA_out_reg <= 1;
            counter <= 0;
        end
    end
end

endmodule


