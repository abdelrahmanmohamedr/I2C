package i2c_config_package;

    import uvm_pkg::*;
    `include "uvm_macros.svh";

    class i2c_config_class extends uvm_object;
        `uvm_object_utils(i2c_config_class)

        virtual I2C_interface vif;
        bit is_active = UVM_ACTIVE;
        bit is_top = 1;
        bit [6:0] i2c_address;

        function new(string name = "i2c_config_class");
            super.new(name);
        endfunction
    endclass
endpackage
