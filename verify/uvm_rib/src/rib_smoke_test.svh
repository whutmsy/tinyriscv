// RIB冒烟测试: 跑一个smoke_seq, 不做自动比对, 仅跑通+打印
class rib_smoke_test extends uvm_test;

    rib_env    env;
    rib_smoke_seq seq;

    `uvm_component_utils(rib_smoke_test)

    function new(string name = "rib_smoke_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = rib_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = rib_smoke_seq::type_id::create("seq");
        if (!seq.randomize())
            `uvm_fatal(get_type_name(), "seq randomize失败")
        `uvm_info(get_type_name(), "start running rib_smoke_seq ...", UVM_LOW)
        seq.start(env.agent.sequencer);
        #100;
        `uvm_info(get_type_name(), "smoke sequence finished, check waveform/print for routing & data", UVM_LOW)
        phase.drop_objection(this);
    endtask

endclass
