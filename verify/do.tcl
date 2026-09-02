# RIB UVM 仿真运行脚本(由 sim.tcl 调用)
# 只记录DUT(rib)内部与端口信号到WLF波形(文件名由 sim.tcl 的 -wlf rib_uvm.wlf 指定)
# onerror确保出错也退出, 避免残留进程锁住 work 库
onerror {quit -f}

log -r /tb_top/dut/*

run -all
quit -f
