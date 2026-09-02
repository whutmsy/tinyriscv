`timescale 1 ns / 1 ps

// RIB总线接口定义
// 覆盖rib.v的全部端口：
//   4个master接口(m0~m3)：由UVM agent/外部激励驱动
//   8个slave接口(s0~s7)：rib输出(addr/data_o/we)，slave回读数据data_i由tb/从模型驱动
interface rib_if;

    logic clk;
    logic rst;

    // master 0 interface (CPU EX/load-store)
    logic [31:0] m0_addr;
    logic [31:0] m0_data_i;   // 写数据
    logic [31:0] m0_data_o;   // 读数据(rib返回)
    logic        m0_req;
    logic        m0_we;

    // master 1 interface (PC/取指)
    logic [31:0] m1_addr;
    logic [31:0] m1_data_i;
    logic [31:0] m1_data_o;
    logic        m1_req;
    logic        m1_we;

    // master 2 interface (JTAG debug)
    logic [31:0] m2_addr;
    logic [31:0] m2_data_i;
    logic [31:0] m2_data_o;
    logic        m2_req;
    logic        m2_we;

    // master 3 interface (UART debug)
    logic [31:0] m3_addr;
    logic [31:0] m3_data_i;
    logic [31:0] m3_data_o;
    logic        m3_req;
    logic        m3_we;

    // slave 0 interface (rom)
    logic [31:0] s0_addr;
    logic [31:0] s0_data_o;   // rib写向slave的数据
    logic [31:0] s0_data_i;   // slave回读数据
    logic        s0_we;

    // slave 1 interface (ram)
    logic [31:0] s1_addr;
    logic [31:0] s1_data_o;
    logic [31:0] s1_data_i;
    logic        s1_we;

    // slave 2 interface (timer)
    logic [31:0] s2_addr;
    logic [31:0] s2_data_o;
    logic [31:0] s2_data_i;
    logic        s2_we;

    // slave 3 interface (uart)
    logic [31:0] s3_addr;
    logic [31:0] s3_data_o;
    logic [31:0] s3_data_i;
    logic        s3_we;

    // slave 4 interface (gpio)
    logic [31:0] s4_addr;
    logic [31:0] s4_data_o;
    logic [31:0] s4_data_i;
    logic        s4_we;

    // slave 5 interface (spi)
    logic [31:0] s5_addr;
    logic [31:0] s5_data_o;
    logic [31:0] s5_data_i;
    logic        s5_we;

    // slave 6 interface (预留)
    logic [31:0] s6_addr;
    logic [31:0] s6_data_o;
    logic [31:0] s6_data_i;
    logic        s6_we;

    // slave 7 interface (预留)
    logic [31:0] s7_addr;
    logic [31:0] s7_data_o;
    logic [31:0] s7_data_i;
    logic        s7_we;

    // 总线状态
    logic hold_flag;

endinterface
