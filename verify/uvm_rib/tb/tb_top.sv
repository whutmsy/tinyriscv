`timescale 1 ns / 1 ps

// RIB总线 UVM验证环境 tb顶层
// 例化 rib.v, 通过 rib_if 与 UVM agent 相连; slave回读数据由下面简单从模型提供
module tb_top;

    import uvm_pkg::*;
    import rib_pkg::*;

    rib_if u_if();

    // ---------------- 时钟/复位 ----------------
    // 时钟50MHz: 周期20ns
    initial begin
        forever #10 u_if.clk = ~u_if.clk;
    end

    // 复位(RstEnable=0有效), 5个时钟后释放
    initial begin
        repeat (5) @(posedge u_if.clk);
        u_if.rst = 1'b1;
        $display("reset release @ %0t", $time);
    end

    // ---------------- DUT: rib ----------------
    rib dut (
        .clk        (u_if.clk),
        .rst        (u_if.rst),

        .m0_addr_i  (u_if.m0_addr),
        .m0_data_i  (u_if.m0_data_i),
        .m0_data_o  (u_if.m0_data_o),
        .m0_req_i   (u_if.m0_req),
        .m0_we_i    (u_if.m0_we),

        .m1_addr_i  (u_if.m1_addr),
        .m1_data_i  (u_if.m1_data_i),
        .m1_data_o  (u_if.m1_data_o),
        .m1_req_i   (u_if.m1_req),
        .m1_we_i    (u_if.m1_we),

        .m2_addr_i  (u_if.m2_addr),
        .m2_data_i  (u_if.m2_data_i),
        .m2_data_o  (u_if.m2_data_o),
        .m2_req_i   (u_if.m2_req),
        .m2_we_i    (u_if.m2_we),

        .m3_addr_i  (u_if.m3_addr),
        .m3_data_i  (u_if.m3_data_i),
        .m3_data_o  (u_if.m3_data_o),
        .m3_req_i   (u_if.m3_req),
        .m3_we_i    (u_if.m3_we),

        .s0_addr_o  (u_if.s0_addr),
        .s0_data_o  (u_if.s0_data_o),
        .s0_data_i  (u_if.s0_data_i),
        .s0_we_o    (u_if.s0_we),

        .s1_addr_o  (u_if.s1_addr),
        .s1_data_o  (u_if.s1_data_o),
        .s1_data_i  (u_if.s1_data_i),
        .s1_we_o    (u_if.s1_we),

        .s2_addr_o  (u_if.s2_addr),
        .s2_data_o  (u_if.s2_data_o),
        .s2_data_i  (u_if.s2_data_i),
        .s2_we_o    (u_if.s2_we),

        .s3_addr_o  (u_if.s3_addr),
        .s3_data_o  (u_if.s3_data_o),
        .s3_data_i  (u_if.s3_data_i),
        .s3_we_o    (u_if.s3_we),

        .s4_addr_o  (u_if.s4_addr),
        .s4_data_o  (u_if.s4_data_o),
        .s4_data_i  (u_if.s4_data_i),
        .s4_we_o    (u_if.s4_we),

        .s5_addr_o  (u_if.s5_addr),
        .s5_data_o  (u_if.s5_data_o),
        .s5_data_i  (u_if.s5_data_i),
        .s5_we_o    (u_if.s5_we),

        .s6_addr_o  (u_if.s6_addr),
        .s6_data_o  (u_if.s6_data_o),
        .s6_data_i  (u_if.s6_data_i),
        .s6_we_o    (u_if.s6_we),

        .s7_addr_o  (u_if.s7_addr),
        .s7_data_o  (u_if.s7_data_o),
        .s7_data_i  (u_if.s7_data_i),
        .s7_we_o    (u_if.s7_we),

        .hold_flag_o(u_if.hold_flag)
    );

    // ---------------- 非被测master口(m1~m3)置空闲 ----------------
    assign u_if.m1_req    = 1'b0;
    assign u_if.m1_we     = 1'b0;
    assign u_if.m1_addr   = 32'h0;
    assign u_if.m1_data_i = 32'h0;

    assign u_if.m2_req    = 1'b0;
    assign u_if.m2_we     = 1'b0;
    assign u_if.m2_addr   = 32'h0;
    assign u_if.m2_data_i = 32'h0;

    assign u_if.m3_req    = 1'b0;
    assign u_if.m3_we     = 1'b0;
    assign u_if.m3_addr   = 32'h0;
    assign u_if.m3_data_i = 32'h0;

    // ---------------- 简单从模型 ----------------
    // 只做读数据回绕(读回 = {slave号, 偏移}), 不做存储;
    // 冒烟用它确认路由正确性。真实使用时请替换为ram/rom/外设模型
    assign u_if.s0_data_i = {4'h0, u_if.s0_addr[27:0]};
    assign u_if.s1_data_i = {4'h1, u_if.s1_addr[27:0]};
    assign u_if.s2_data_i = {4'h2, u_if.s2_addr[27:0]};
    assign u_if.s3_data_i = {4'h3, u_if.s3_addr[27:0]};
    assign u_if.s4_data_i = {4'h4, u_if.s4_addr[27:0]};
    assign u_if.s5_data_i = {4'h5, u_if.s5_addr[27:0]};
    assign u_if.s6_data_i = {4'h6, u_if.s6_addr[27:0]};
    assign u_if.s7_data_i = {4'h7, u_if.s7_addr[27:0]};

    // ---------------- 波形 ----------------
    initial begin
        $dumpfile("rib_uvm.vcd");
        $dumpvars(0, tb_top);
    end

    // ---------------- UVM入口 ----------------
    // run_test必须在0时刻调用, 不能先有仿真延时
    initial begin
        u_if.clk = 1'b0;
        u_if.rst = 1'b0;   // RstEnable
        uvm_config_db#(virtual rib_if)::set(null, "*", "vif", u_if);
        run_test("rib_smoke_test");
        $finish;
    end

    // 超时看门狗
    initial begin
        #1_000_000;
        $display("TIME OUT @ %0t", $time);
        $finish;
    end

endmodule
