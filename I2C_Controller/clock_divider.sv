module clock_divider #(
    parameter INPUT_CLOCK_SPEED = 2000000,
    parameter OUTPUT_CLOCK_SPEED = 100000
) (
    input logic clk,
    input logic rst_n,
    output logic divided_clk
);

localparam DIVIDE_BY = INPUT_CLOCK_SPEED / (2*OUTPUT_CLOCK_SPEED) ;
localparam DIVIDE_BY_WIDTH = $clog2(DIVIDE_BY);

logic [DIVIDE_BY_WIDTH-1 : 0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        divided_clk <= 0;
    end else if (counter == DIVIDE_BY-1) begin
        counter <= 0;
        divided_clk <= ~divided_clk;
    end else 
        counter <= counter + 1;
end
    
endmodule



