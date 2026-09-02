// RIB冒烟序列
// master0 依次对 slave0/1/2/3/6/7 发起写+读，观察地址路由、数据通路与hold_flag。
class rib_smoke_seq extends uvm_sequence #(rib_transaction);

    `uvm_object_utils(rib_smoke_seq)
    `uvm_declare_p_sequencer(uvm_sequencer #(rib_transaction))

    function new(string name = "rib_smoke_seq");
        super.new(name);
    endfunction

    task body();
        send_write(32'h0000_000c, 32'h5a5a_1234); // slave0 (rom)
        send_read (32'h0000_000c);
        send_write(32'h1000_0010, 32'hdead_beef); // slave1 (ram)
        send_read (32'h1000_0010);
        send_write(32'h2000_0014, 32'h1234_abcd); // slave2 (timer)
        send_read (32'h2000_0014);
        send_read (32'h3000_0008);                // slave3 (uart) 只读
        send_write(32'h4000_0028, 32'h0bad_cafe); // slave4 (gpio)
        send_read (32'h4000_0028);
        send_write(32'h5000_002c, 32'hf00d_0005); // slave5 (spi)
        send_read (32'h5000_002c);
        send_write(32'h6000_0020, 32'h6000_0060); // slave6 (新增接口)
        send_read (32'h6000_0020);
        send_write(32'h7000_0024, 32'h7000_0070); // slave7 (新增接口)
        send_read (32'h7000_0024);
    endtask

    task send_write(input bit [31:0] addr, input bit [31:0] data);
        rib_transaction tr;
        tr = rib_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr = addr;
        tr.data = data;
        tr.we   = 1'b1;
        finish_item(tr);
    endtask

    task send_read(input bit [31:0] addr);
        rib_transaction tr;
        tr = rib_transaction::type_id::create("tr");
        start_item(tr);
        tr.addr = addr;
        tr.we   = 1'b0;
        finish_item(tr);
    endtask

endclass
