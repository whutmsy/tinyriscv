// RIB总线事务
// master侧发起一次读写请求：addr[31:28] 决定访问哪个slave
class rib_transaction extends uvm_sequence_item;

    rand bit [31:0] addr;
    rand bit [31:0] data;   // 写数据
    rand bit        we;     // 1:写, 0:读

    bit [31:0] rdata;       // 读返回数据(仿真回填)

    `uvm_object_utils_begin(rib_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(we,   UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "rib_transaction");
        super.new(name);
    endfunction

endclass
