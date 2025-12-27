////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller
////////////////////////////////////////////////////////////////////////////////

module I2C_Controller #(
    parameter DATA_WIDTH = 8,
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
    input logic controller_error_req,
    input logic SCL_in,
    input logic SDA_in,
    output logic SCL_out,
    output logic SDA_out,
    output logic write_enable,
    output logic read_enable,
    output logic self_address_generated
);

localparam IDLE_STATE = 3'b000;
localparam START_STATE = 3'b001;
localparam ACTIVE_ADDRESS_STATE = 3'b010;
localparam ACTIVE_DATA_STATE = 3'b011;
localparam STOP_STATE = 3'b100;

localparam BIT_NO = $clog2(DATA_WIDTH);

logic SDA_reg;
logic SDA_sync;
logic SDA_comb;
logic divided_clk;
logic divided_clk_rst_n;
logic operation;
logic [ADDR_WIDTH-1:0] address;
logic [2:0] NS, CS;

logic [BIT_NO-1:0] bit_sel;
logic [BIT_NO-1:0] bit_sel_next;
logic [4:0] counter;
logic [4:0] counter_next;
logic stop_counter;
logic stop_counter_next;
logic data_sent;
logic ACK_check;
logic stop_ACK;
logic stop_req;
logic restart_req;
logic error;

clock_divider #(.INPUT_CLOCK_SPEED(LOCAL_CLOCK_SPEED),.OUTPUT_CLOCK_SPEED(FORWARDED_CLOCK_SPEED)) clock_divider_inst (.clk(clk),.rst_n(divided_clk_rst_n),.divided_clk(divided_clk));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE_STATE;
        stop_counter <= 0; 
    end else begin
        CS <= NS; 
        stop_counter <= stop_counter_next;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        SDA_sync <= 0;
    end else begin
        if (!SCL_out)  SDA_sync <= SDA_reg;
    end  
end

always @(negedge SCL_in) begin
    if (CS == ACTIVE_DATA_STATE && counter == 9) stop_ACK = 1;
    else stop_ACK = 0;
end

always @(posedge SCL_in or negedge rst_n) begin
     if (!rst_n) begin
         counter <= 0;
         bit_sel <= 0;
     end else begin
        if ((ACK_check && counter == 7 && CS == ACTIVE_DATA_STATE) || (ACK_check && counter == 8 && CS == ACTIVE_ADDRESS_STATE)) begin
            if (SDA_in || !controller_valid_req) begin
                stop_req <= 1;
            end else if (controller_restart_req) begin
                restart_req <= 1;
            end
        end else begin
            stop_req <= 0;
            restart_req <= 0;
        end
        counter <= counter_next;
        bit_sel <= bit_sel_next;
    end
 end

 always @(*) begin
    if (CS == START_STATE || CS == STOP_STATE || CS == IDLE_STATE || (error &&  CS == ACTIVE_DATA_STATE)) begin
        SDA_out = SDA_comb;
    end else begin
        SDA_out = SDA_sync;
    end
end  

always @(*) begin
    case (CS)
        IDLE_STATE: begin
            SCL_out = 1;
            SDA_comb = 1;
            data_sent = 0;
            divided_clk_rst_n = 1;
            stop_counter_next = 0;
            write_enable = 0;
            read_enable = 0;
            ACK_check = 0;
            bit_sel_next = 0;
            counter_next = 0;
            error = 0;
            self_address_generated = 0;
            if (controller_valid_req) begin
                NS = START_STATE;
                address = controller_addr_req;
                operation = controller_operation_req;
            end else NS = IDLE_STATE;
        end

        START_STATE: begin
            SDA_comb = 0;
            SCL_out = 1;
            divided_clk_rst_n = 0;
            self_address_generated = 1;
            bit_sel_next = 0;
            counter_next = 0;
            NS = ACTIVE_ADDRESS_STATE;
        end

        ACTIVE_ADDRESS_STATE: begin
            divided_clk_rst_n = 1;
            SCL_out = divided_clk;
            case (ADDR_WIDTH)
                7: begin
                    if (counter < 7) begin
                        SDA_reg = address [ADDR_WIDTH-bit_sel-1];
                        bit_sel_next = bit_sel + 1;
                        counter_next = counter + 1; 
                    end else if (counter == 7) begin
                        SDA_reg = operation;
                        counter_next = counter + 1; 
                    end else if (counter == 8) begin
                        SDA_reg = 1;
                        bit_sel_next = 0;
                        counter_next = counter + 1;
                        ACK_check = 1;
                    end else if (counter == 9) begin
                        NS = ACTIVE_DATA_STATE;
                        counter_next = 0;
                    end
                end 
            endcase
        end

        ACTIVE_DATA_STATE: begin
            SCL_out = divided_clk;
            if (counter >= 8 && ((stop_req || restart_req) && !SCL_out)) begin
                if (stop_req) begin
                        NS = STOP_STATE;
                    end else begin
                        NS = IDLE_STATE;
                    end
                    error = 1;
                    SDA_comb = 0;
                    counter_next = 0;
                    data_sent = 0;
                    ACK_check = 0; 
                    read_enable = 0;
                    write_enable = 0;
            end else begin
                if (!operation) write_enable = 1;
                else read_enable = 1;
                if (counter >= 8) counter_next = 0;
                else counter_next = counter + 1; 
                data_sent = 1;
                if (counter == 7) ACK_check = 1;
                else ACK_check = 0;
                SDA_reg = 1;
            end
        end

        STOP_STATE: begin
            error = 0;
            SCL_out = 1;
            stop_counter_next = 1;
            if (stop_counter) begin
                SDA_comb = 1;
                NS = IDLE_STATE;
            end
            
        end
    endcase
end
endmodule




