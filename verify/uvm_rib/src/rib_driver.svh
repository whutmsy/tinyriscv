// RIB master驱动器
// 本骨架只驱动master0口：复位结束后逐事务驱动m0_*端口。
// 时序：posedge发起请求 -> negedge采样读数据 -> 下一posedge撤销请求
class rib_driver extends uvm_driver #(rib_transaction);

    virtual rib_if vif;

    `uvm_component_utils(rib_driver)

    function new(string name = "rib_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual rib_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "cannot get virtual rib_if from config_db")
        end
    endfunction

    task run_phase(uvm_phase phase);
        // 等待复位释放(RstEnable为低电平复位)
        @(posedge vif.clk);
        while (vif.rst == 1'b0)
            @(posedge vif.clk);

        // 复位后先置空总线
        idle_bus();

        forever begin
            rib_transaction req;
            seq_item_port.get_next_item(req);
            drive_one(req);
            seq_item_port.item_done();
        end
    endtask

    // 总线idle：撤销master0的所有请求
    task idle_bus();
        vif.m0_req   = 1'b0;
        vif.m0_we    = 1'b0;
        vif.m0_addr  = 32'h0;
        vif.m0_data_i = 32'h0;
    endtask

    // 驱动一次读写
    task drive_one(rib_transaction t);
        @(posedge vif.clk);
        vif.m0_addr   = t.addr;
        vif.m0_data_i = t.data;
        vif.m0_we     = t.we;
        vif.m0_req    = 1'b1;

        @(negedge vif.clk);
        if (t.we == 1'b0)
            t.rdata = vif.m0_data_o;

        `uvm_info(get_type_name(), $psprintf("WR=%0d addr=0x%08x data=0x%08x rdata=0x%08x hold=%0d",
                    t.we, t.addr, t.data, t.rdata, vif.hold_flag), UVM_MEDIUM)
        @(posedge vif.clk);
        idle_bus();
    endtask

endclass
