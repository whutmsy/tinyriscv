# RIB总线 UVM 仿真编译/运行脚本(QuestaSim)
# 运行方式: 在 verify 目录执行  vsim -c -do sim.tcl
# DUT:  rtl/core/rib.v
# UVM:  verify/uvm_rib

set UVM_HOME D:/questasim64_10.6c/verilog_src/uvm-1.1d
set UVM_DPI_HOME D:/questasim64_10.6c/uvm-1.1d/win64

# 重建工作库
catch {vdel -all -lib work}
vlib work
vmap work work

# 1. 编译UVM库
vlog +incdir+$UVM_HOME/src -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF $UVM_HOME/src/uvm_pkg.sv

# 2. 编译RTL(仅rib需要defines.v)
vlog +incdir+../rtl/core ../rtl/core/rib.v

# 3. 编译UVM环境源码(SV)
vlog +incdir+$UVM_HOME/src +incdir+uvm_rib/src +incdir+uvm_rib/tb uvm_rib/tb/rib_if.sv
vlog +incdir+$UVM_HOME/src +incdir+uvm_rib/src +incdir+uvm_rib/tb uvm_rib/src/rib_pkg.sv
vlog +incdir+$UVM_HOME/src +incdir+uvm_rib/src +incdir+uvm_rib/tb uvm_rib/tb/tb_top.sv

# 4. 运行(保存WLF波形到 rib_uvm.wlf; -novopt关闭优化, 保证DUT内部信号可见可记录)
catch {file delete -force rib_uvm.wlf}
vsim -c -do do.tcl -l transcript.log -wlf rib_uvm.wlf -novopt -sv_lib $UVM_DPI_HOME/uvm_dpi tb_top
