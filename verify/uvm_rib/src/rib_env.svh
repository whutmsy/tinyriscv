// RIB环境: 本骨架只包含一个绑到master0口的agent
class rib_env extends uvm_env;

    rib_agent agent;

    `uvm_component_utils(rib_env)

    function new(string name = "rib_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = rib_agent::type_id::create("agent", this);
    endfunction

endclass
