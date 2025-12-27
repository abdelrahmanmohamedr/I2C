export VERDI_HOME=/home/tools/synopsys/install/verdi/V-2023.12-1
export VCS_HOME=/tools/synopsys/install/vcs/V-2023.12-1
vcs -f I2C.list -sverilog -ntb_opts uvm-1.2 -lca -debug_access+all+reverse -full64 -kdb +define+WEAK_OPERATOR+SIM +vcs+assertion+weak
./simv +UVM_TIMEOUT=0 -l transcript.log