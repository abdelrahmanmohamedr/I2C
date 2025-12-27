module I2C_Pattern_Detector #(
    parameter ADDRESS = 7'h10,
    parameter ADDRESS_WIDTH = 7
) (
    input logic SCL_in,
    input logic SDA_in,
    input logic rst_n,
    input logic self_address_generated,
    output logic SDA_out, 
    output logic wr_enable, 
    output logic rd_enable 
);

parameter START_STOP_DECISION = 2'b00;
parameter OPERATING_DECISION = 2'b01;
parameter FINISH_DETECTION = 2'b10;

logic start_state, stop_state;

logic [ADDRESS_WIDTH:0] control_signal;
logic [ADDRESS_WIDTH:0] control_signal_reg;

logic [1:0] CS, NS;
logic [4:0] counter;
logic [4:0] counter_next;

logic SDA_out_reg;
logic ACK;
logic NACK_detected;
logic detect_ACK;
logic ack_done;
logic first_time;
logic reset_start_stop;

assign reset_start_stop = SCL_in & rst_n;

always @(negedge SCL_in or negedge rst_n) begin
    if (!rst_n) begin
        CS <= START_STOP_DECISION;
        SDA_out <= 1;
    end else begin
        CS <= NS;
        SDA_out <= SDA_out_reg;
    end 
end

always @(posedge SCL_in or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        control_signal <= 0;
    end else begin
        if (CS == OPERATING_DECISION) begin
            first_time = 1;
        end 
        if (CS == FINISH_DETECTION && first_time)begin
            counter <= 0;
            first_time <= 0;
        end else counter <= counter_next;
        
        control_signal <= control_signal_reg;
    end
end

always @(posedge SCL_in or negedge rst_n) begin
    if (detect_ACK && SDA_in) begin
        NACK_detected <= 1;
    end else NACK_detected <= 0;
end

always @(negedge SDA_in or negedge reset_start_stop) begin
    if (!reset_start_stop) start_state <= 0;
    else if (SCL_in) start_state <= 1;
    else start_state <= 0;
end

always @(posedge SDA_in or negedge reset_start_stop) begin
    if (!reset_start_stop) stop_state <= 0;
    else if (SCL_in) stop_state <= 1;
    else stop_state <= 0;
end

always @(*) begin
    case (CS)
        START_STOP_DECISION: begin
                SDA_out_reg = 1;
                ACK = 0;
                detect_ACK = 0;
                counter_next = 0;
                wr_enable <= 0;
                rd_enable <= 0;
            if (start_state && !self_address_generated) begin
                NS = OPERATING_DECISION;
                counter_next = 0;
                wr_enable = 0;
                rd_enable = 0;
            end else begin
                NS = START_STOP_DECISION;
            end
        end

        OPERATING_DECISION: begin
            control_signal_reg[ADDRESS_WIDTH - counter] = SDA_in;
            counter_next = counter + 1;
            if (counter == ADDRESS_WIDTH + 1) begin
                if (control_signal[ADDRESS_WIDTH:1] == ADDRESS) begin
                    SDA_out_reg = 0;
                end else begin
                    SDA_out_reg = 1;
                end 
            end else if (counter == ADDRESS_WIDTH + 2) begin
                if (control_signal[ADDRESS_WIDTH:1] == ADDRESS) begin
                    if (!control_signal[0]) rd_enable = 1; 
                    else wr_enable = 1;
                end else begin
                    wr_enable = 0;
                    rd_enable = 0;
                end
                SDA_out_reg = 1;
                counter_next = 0;
                NS = FINISH_DETECTION;
            end
        end

        FINISH_DETECTION: begin
            if ((counter == ADDRESS_WIDTH + 1 && !first_time) || stop_state) begin
                ACK = 1;
                if (NACK_detected || stop_state) begin
                    NS = START_STOP_DECISION;
                    wr_enable = 0;
                    rd_enable = 0;
                end
                counter_next = 0;
            end else begin
                if (counter == ADDRESS_WIDTH) detect_ACK = 1;
                else detect_ACK = 0;
                ACK = 0;
                counter_next = counter + 1;
                
            end 
        end 
    endcase
end
endmodule










