#!/bin/bash
# 1. Set Environment Variables
export VERDI_HOME=/home/tools/synopsys/install/verdi/V-2023.12-1
export VCS_HOME=/tools/synopsys/install/vcs/V-2023.12-1
export PATH=$VCS_HOME/bin:$VERDI_HOME/bin:$PATH

# 2. Cleanup previous runs
rm -rf csrc simv simv.daidir ucli.key vc_hdrs.h waves.fsdb verdiLog novas*

# 3. Compile Step - Add Verdi PLI for FSDB support
vcs -f I2C_Controller.list \
    -sverilog \
    -ntb_opts uvm-1.2 \
    -lca \
    -debug_access+all+reverse \
    -full64 \
    -kdb \
    +define+WEAK_OPERATOR+SIM \
    +vcs+assertion+weak \
    -race \
    -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab \
    ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a \
    -l compile.log

# Check if compilation succeeded
if [ $? -ne 0 ]; then
    echo "Compilation Failed!"
    exit 1
fi

# 4. Simulation Step with runtime dumping
./simv +UVM_TIMEOUT=0 \
       +UVM_VERDI_TRACE='UVM_AWARE|TLM|HIER' \
       +UVM_TR_RECORD \
       +race=all \
       +race_max=100 \
       -ucli -do dump.tcl \
       -l transcript.log

# Check if simulation succeeded
if [ $? -eq 0 ]; then
    echo "Simulation completed successfully!"
    echo "Waveform saved to: waves.fsdb"
    echo "To view: verdi -ssf waves.fsdb &"
fi