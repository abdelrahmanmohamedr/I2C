module I2C_Pattern_Detector_assertion #(
    parameter ADDRESS = 7'h10,
    parameter ADDRESS_WIDTH = 7
) (
    input logic SCL_in,
    input logic SDA_in,
    input logic rst_n,
    input logic self_address_generated,
    input logic SDA_out, 
    input logic wr_enable, 
    input logic rd_enable 
);

logic neg_edge;
logic pos_edge;

    always_comb begin :reset_assertion
        if (!rst_n) begin
            assert final (!wr_enable
                    && !rd_enable
                    && SDA_out)
            else $display("error: reset state");
        end
    end

    sequence read_write_enable_sequence;
        I2C_Pattern_Detector.CS == 2'b01
        && I2C_Pattern_Detector.counter == 8;
    endsequence

    sequence detect_NACK_sequence;
        I2C_Pattern_Detector.CS == 2'b10 &&
        I2C_Pattern_Detector.counter == 8 &&
        !I2C_Pattern_Detector.first_time;
    endsequence

    sequence ACK_sequence;
        I2C_Pattern_Detector.CS == 2'b01
        && I2C_Pattern_Detector.counter == 8;
    endsequence

    property write_enable_property;
        @(posedge SCL_in) disable iff (!rst_n)
        read_write_enable_sequence |=> if (I2C_Pattern_Detector.control_signal[7:1] == 7'h10)
            if (!I2C_Pattern_Detector.control_signal[0]) wr_enable == 0
            else wr_enable == 1
        else wr_enable == 0;
    endproperty 

    property read_enable_property;
        @(posedge SCL_in) disable iff (!rst_n)
        read_write_enable_sequence |=> if (I2C_Pattern_Detector.control_signal[7:1] == 7'h10)
            if (!I2C_Pattern_Detector.control_signal[0]) rd_enable == 1
            else rd_enable == 0
        else rd_enable == 0;
    endproperty 

    property ACK_property;
        @(negedge SCL_in) disable iff (!rst_n)
        ACK_sequence |=> if (I2C_Pattern_Detector.control_signal[7:1] == 7'h10) SDA_out == 0
        else SDA_out == 1;
    endproperty

    assert property (write_enable_property)
    else $display("error: write operation");
    cover property (write_enable_property);

    assert property (read_enable_property)
    else $display("error: read operation");
    cover property (read_enable_property);

    assert property (ACK_property)
    else $display("error: ACK operation");
    cover property (ACK_property);

endmodule