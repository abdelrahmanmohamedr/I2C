////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_directed_restart_sequence
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_directed_restart_sequence_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Controller TX main sequence class extending uvm_sequence
    class I2C_Controller_directed_restart_sequence_class extends uvm_sequence #(I2C_Controller_sequence_item_class);

        // Factory registration
        `uvm_object_utils(I2C_Controller_directed_restart_sequence_class);

        // Sequence item declaration
        I2C_Controller_sequence_item_class MAIN_sequence_item;

        bit top = 1;

        // Constructor
        function new(string name = "I2C_Controller_directed_restart_sequence_class");
            super.new(name);
        endfunction //new()

        // Body task
        task body;
            MAIN_sequence_item = I2C_Controller_sequence_item_class::type_id::create("MAIN_sequence_item");
               start_item(MAIN_sequence_item);
                    MAIN_sequence_item.rst_n=1;
                    MAIN_sequence_item.controller_data_req='h34;
                    MAIN_sequence_item.controller_addr_req='h10;
                    MAIN_sequence_item.controller_valid_req=1;
                    MAIN_sequence_item.controller_operation_req=0;
                    MAIN_sequence_item.controller_restart_req=1;
                    MAIN_sequence_item.error_signal=0;
                    if (!top) begin
                        MAIN_sequence_item.SDA_in=0;
                    end
                finish_item(MAIN_sequence_item); 
        endtask //body()

    endclass //I2C_Controller_directed_restart_sequence_class extends uvm_sequence

endpackage //I2C_Controller_directed_restart_sequence_pkg



