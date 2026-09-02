// RIB agent: sequencer + driver
class rib_agent extends uvm_agent;

    uvm_sequencer #(rib_transaction) sequencer;
    rib_driver                        driver;

    `uvm_component_utils(rib_agent)

    function new(string name = "rib_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_sequencer#(rib_transaction)::type_id::create("sequencer", this);
        driver    = rib_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass
