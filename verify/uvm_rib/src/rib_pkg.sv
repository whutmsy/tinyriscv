`ifndef RIB_PKG_SV
`define RIB_PKG_SV

package rib_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "rib_transaction.svh"
    `include "rib_driver.svh"
    `include "rib_sequence.svh"
    `include "rib_agent.svh"
    `include "rib_env.svh"
    `include "rib_smoke_test.svh"

endpackage

`endif
