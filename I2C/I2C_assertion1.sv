module I2C_assertion1 #(
    parameter DATA_WIDTH = 8,
    parameter ADDRESS = 7'h10,
    parameter ADDRESS_WIDTH = 7
) (
    input logic clk,
    input logic SCL_in,
    input logic SDA_in,
    input logic rst_n,
    input logic [DATA_WIDTH-1:0] controller_data_req,
    input logic self_address_generated,
    input logic SDA_out, 
    input logic wr_enable, 
    input logic rd_enable,
    input logic [DATA_WIDTH-1:0] controller_data_rsp 
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
        I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.CS == 2'b01
        && I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.counter == 8;
    endsequence

    sequence detect_NACK_sequence;
        I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.CS == 2'b10 &&
        I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.counter == 8 &&
        !I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.first_time;
    endsequence

    sequence ACK_sequence;
        I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.CS == 2'b01
        && I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.counter == 8;
    endsequence
    
    sequence signal_recieved_check_sequence;
        I2C_top_design_inst.I2C2.I2C_Controller_inst.CS == 2'b11
        && rd_enable && I2C_top_design_inst.I2C2.I2C_Controller_inst.counter == 8
        && !SDA_in;
    endsequence

    property write_enable_property;
        @(posedge SCL_in) disable iff (!rst_n)
        read_write_enable_sequence |=> if (I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.control_signal[7:1] == 7'h01)
            if (!I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.control_signal[0]) wr_enable == 0
            else wr_enable == 1
        else wr_enable == 0;
    endproperty 

    property read_enable_property;
        @(posedge SCL_in) disable iff (!rst_n)
        read_write_enable_sequence |=> if (I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.control_signal[7:1] == 7'h01)
            if (!I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.control_signal[0]) rd_enable == 1
            else rd_enable == 0
        else rd_enable == 0;
    endproperty 

    property ACK_property;
        @(negedge SCL_in) disable iff (!rst_n)
        ACK_sequence |=> if (I2C_top_design_inst.I2C1.I2C_Pattern_Detector_inst.control_signal[7:1] == 7'h01) SDA_out == 0
        else SDA_out == 1;
    endproperty

    property signal_recieved_check_property;
        @(posedge clk) disable iff (!rst_n)
        signal_recieved_check_sequence |=> controller_data_rsp == $past(controller_data_req);
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

    assert property (signal_recieved_check_property)
    else $display("error: recieve operation");
    cover property (signal_recieved_check_property);

endmodule